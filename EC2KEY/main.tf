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
                KEY_FILE_TYPE = "${KEY.FILE_TYPE}"
                KEY_FILE_NAME = "${upper(KEY.NAME)}.${KEY.FILE_TYPE}"
                KEY_LINUX_FILE =  "${KEY.LINUX_DIR}/${upper(KEY.NAME)}.${KEY.FILE_TYPE}"
                KEY_WIN_FILE = "${KEY.WIN_DIR}/${upper(KEY.NAME)}.${KEY.FILE_TYPE}"
                KEY_RUNNER_FILE = "${KEY.RUNNER_DIR}/${upper(KEY.NAME)}.${KEY.FILE_TYPE}"
                KEY_S3_FILE = "${KEY.S3_DIR}/${upper(KEY.NAME)}.${KEY.FILE_TYPE}"
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
        command = <<-EOF
            if [[ -n "${var.KEYs[count.index].LINUX_DIR}" ]]; then
                mkdir -p "${var.KEYs[count.index].LINUX_DIR}"
                sudo echo "${tls_private_key.PRI_KEY[count.index].private_key_pem}" > "${local.KEYs[count.index].KEY_LINUX_FILE}"    
                sudo chmod 400 "${local.KEYs[count.index].KEY_LINUX_FILE}"
                sudo chown $USER:$USER "${local.KEYs[count.index].KEY_LINUX_FILE}"
            fi
            if [[ -n "${var.KEYs[count.index].WIN_DIR}" ]]; then
                sudo echo "${tls_private_key.PRI_KEY[count.index].private_key_pem}" > "${local.KEYs[count.index].KEY_WIN_FILE}"
            fi
            if [[ -n "${var.KEYs[count.index].RUNNER_DIR}" ]]; then
                mkdir -p "${var.KEYs[count.index].RUNNER_DIR}"
                sudo echo "${tls_private_key.PRI_KEY[count.index].private_key_pem}" > "${local.KEYs[count.index].KEY_RUNNER_FILE}"
                sudo chmod 400 "${local.KEYs[count.index].KEY_RUNNER_FILE}"
                sudo chown $USER:$USER "${local.KEYs[count.index].KEY_RUNNER_FILE}"                  
            fi
            if [[ -n "${var.KEYs[count.index].S3_DIR}" ]]; then
                if [[ ${var.KEYs[count.index].LINUX_DIR} ]]; then
                    aws s3 cp "${local.KEYs[count.index].KEY_LINUX_FILE}" "s3://${local.KEYs[count.index].KEY_S3_FILE}"
                fi
                if [[ -n "${var.KEYs[count.index].WIN_DIR}" ]]; then
                    aws s3 cp "${local.KEYs[count.index].KEY_WIN_FILE}" "s3://${local.KEYs[count.index].KEY_S3_FILE}"
                fi
                if [[ -n "${var.KEYs[count.index].RUNNER_DIR}" ]]; then
                    aws s3 cp "${local.KEYs[count.index].KEY_RUNNER_FILE}" "s3://${local.KEYs[count.index].KEY_S3_FILE}"
                fi
            fi
            ls -al "${local.KEYs[count.index].KEY_RUNNER_FILE}"
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
        KEY_WIN_FILE = each.value.KEY_WIN_FILE
        KEY_LINUX_FILE = each.value.KEY_LINUX_FILE
    }

    provisioner "local-exec" {
        when    = destroy
        command = <<-EOF
            if [ -f "${self.triggers.KEY_WIN_FILE}" ]; then
                sudo rm -rf "${self.triggers.KEY_WIN_FILE}"
            fi
            if [ -f "${self.triggers.KEY_LINUX_FILE}" ]; then 
                sudo rm -rf "${self.triggers.KEY_LINUX_FILE}"
            fi
        EOF
    }
}