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

resource "aws_instance" "INS" {
    count = (length(var.INSs) > 0 ?
            length(var.INSs) : 0)

    key_name      = var.INSs[count.index].KEY_NAME
    ami           = var.INSs[count.index].AMI
    instance_type = var.INSs[count.index].TYPE
    tags = {
        Name = "${var.INSs[count.index].NAME}"
    }
    
    associate_public_ip_address = var.INSs[count.index].AUTO_PUBLIC_IP == true ? var.INSs[count.index].AUTO_PUBLIC_IP : null
    source_dest_check           = var.INSs[count.index].AUTO_PUBLIC_IP == true ? var.INSs[count.index].SRC_DEST_CHECK : null
    subnet_id                   = var.INSs[count.index].AUTO_PUBLIC_IP == true ? var.INSs[count.index].SN_ID : null
    security_groups             = var.INSs[count.index].AUTO_PUBLIC_IP == true ? var.INSs[count.index].SG_IDs : null
    private_ip                  = var.INSs[count.index].AUTO_PUBLIC_IP == true ? var.INSs[count.index].PRI_IPV4s[0] : null

    ebs_block_device {
        device_name = var.INSs[count.index].VOL_DIR
        volume_size = var.INSs[count.index].VOL_SIZE
        volume_type = var.INSs[count.index].VOL_TYPE

        tags = {
            Name = "${var.INSs[count.index].NAME}_DEFAULT_VOL"
        }
    }

    dynamic "network_interface" {
        for_each = var.INSs[count.index].AUTO_PUBLIC_IP == false ? [1] : []
        content {
            device_index         = 0
            network_interface_id = aws_network_interface.DEFAULT_NIC[count.index].id
        }
    }

    user_data = data.template_file.EC2_USER_DATA[count.index].rendered
    user_data_replace_on_change = true

}

data "template_file" "EC2_USER_DATA" {
    count = (length(var.INSs) > 0 ?
            length(var.INSs) : 0)
    template = <<-EOF
    #!/bin/bash
    ${var.INS_UDs.SCRIPT[count.index]}
    ${join("\n", [for FILE in var.INS_UDs.FILE[count.index] : file("${FILE}")])}
    EOF
}

resource "aws_network_interface" "DEFAULT_NIC" {
    count = (length(var.INSs) > 0 ?
            length(var.INSs) : 0)

    source_dest_check   = try(var.INSs[count.index].SRC_DEST_CHECK, null)
    subnet_id           = try(var.INSs[count.index].SN_ID, null)
    security_groups     = var.INSs[count.index].AUTO_PUBLIC_IP == false ? var.INSs[count.index].SG_IDs : null
    private_ips         = var.INSs[count.index].AUTO_PUBLIC_IP == false ? var.INSs[count.index].PRI_IPV4s : null

    tags = {
        Name = var.INSs[count.index].AUTO_PUBLIC_IP == false ? "${var.INSs[count.index].NAME}_DEFAULT_NIC" : null
    }

    # lifecycle {
    #     create_before_destroy = true
    # }
}

# resource "null_resource" "DELETE_UNATTACHED_NIC" {
#     count = (length(var.INSs) > 0 ?
#             length(var.INSs) : 0)

#     depends_on = [ aws_instance.INS ]
#     # Execute the deletion only if the network interface is not attached to any EC2 instance
#     triggers = {
#         AUTO_NIC_ID         = aws_instance.INS[count.index].primary_network_interface_id
#         DEFAULT_NIC_ID      = aws_network_interface.DEFAULT_NIC[count.index].id
#         always_run          = timestamp()
#     }

#     provisioner "local-exec" {
#         command = <<-EOT
#         NIC_STATUS=$(aws ec2 describe-network-interfaces --network-interface-ids ${self.triggers.DEFAULT_NIC_ID} --query 'NetworkInterfaces[0].Status' --output text --profile=${var.PROFILE})
#         if [[ $NIC_STATUS == "available" ]]; then
#             aws ec2 delete-network-interface --network-interface-id ${self.triggers.DEFAULT_NIC_ID} --profile=${var.PROFILE}
#         fi
#         NIC_TAG=$(aws ec2 describe-network-interfaces --network-interface-ids ${self.triggers.AUTO_NIC_ID} --query 'NetworkInterfaces[0].TagSet[?Key==`Name`].Value' --output text --profile=${var.PROFILE})
#         if [[ $NIC_TAG == "" ]]; then
#             aws ec2 create-tags --resources ${self.triggers.AUTO_NIC_ID} --tags Key=Name,Value=${var.INSs[count.index].NAME}_DEFAULT_NIC --profile=${var.PROFILE}
#         fi
#         EOT
#         interpreter = ["bash", "-c"]
#         on_failure = continue
#     }
# }