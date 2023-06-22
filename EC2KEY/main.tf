# Standard AWS Provider Block
terraform {
    required_version = ">= 1.0"
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = ">= 5.0"
        }
    }
}

data "aws_caller_identity" "current" {}

# Create private key
resource "tls_private_key" "PRI_KEY" {
    count = (length(var.KEYs) > 0 ?
            length(var.KEYs) : 0)
    algorithm = try(var.KEYs[count.index].ALGORITHM, "RSA") # "RSA" "ED25519"
    rsa_bits  = try(var.KEYs[count.index].RSA_SIZE, 4096) # "2048" "4096"
}

locals {
    KEYs = {
        for EACH, KEY in var.KEYs:
            EACH => {
                NAME = "${upper(KEY.NAME)}"
                KEY_FILE_NAME = "${upper(KEY.NAME)}.pem"
                KEY_BACKUP_FILE = "${KEY.BACKUP_DIR}/${KEY.KEY_FILE_NAME})"
                KEY_LINUX_FILE =  "${KEY.LINUX_DIR}/${KEY.KEY_FILE_NAME})"
                KEY_S3_FILE = "${KEY.S3_DIR}/${KEY.KEY_FILE_NAME})"
            }
    }
}

# Create key pair
resource "aws_key_pair" "KEY" {
    count = (length(tls_private_key.PRI_KEY) > 0 ?
            length(tls_private_key.PRI_KEY) : 0)
    
    depends_on = [ tls_private_key.PRI_KEY ]
    key_name = local.KEYs[count.index].NAME
    public_key = tls_private_key.PRI_KEY[count.index].public_key_openssh

    provisioner "local-exec" {
        command = <<EOF
            sudo echo "${tls_private_key.PRI_KEY[count.index].private_key_pem}" > "${local.KEYs[count.index].KEY_BACKUP_FILE}"
            sudo echo "${tls_private_key.PRI_KEY[count.index].private_key_pem}" > "${local.KEYs[count.index].KEY_LINUX_FILE}"    
            sudo chmod 400 "${local.KEYs[count.index].KEY_LINUX_FILE}"
            sudo chown $USER:$USER "${local.KEYs[count.index].KEY_LINUX_FILE}"
            aws s3 cp "${local.KEYs[count.index].KEY_LINUX_FILE}" "s3://${local.KEYs[count.index].KEY_S3_FILE}"
        EOF
    }

    lifecycle {
        create_before_destroy = true
    }
}

# Remove private key when destroy
resource "null_resource" "REMOVE_KEY" {

    for_each = local.KEYs
    triggers = {
        KEY_BACKUP_FILE = each.value.KEY_BACKUP_FILE
        KEY_LINUX_FILE = each.value.KEY_LINUX_FILE
    }

    provisioner "local-exec" {
        when    = destroy
        command = <<EOF
            if [ -f "${self.triggers.KEY_BACKUP_FILE}" ]; then
                sudo rm -rf "${self.triggers.KEY_BACKUP_FILE}"
            fi
            if [ -f "${self.triggers.KEY_LINUX_FILE}" ]; then 
                sudo rm -rf "${self.triggers.KEY_LINUX_FILE}"
            fi
        EOF
    }
}