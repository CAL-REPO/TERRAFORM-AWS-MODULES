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

resource "aws_eip" "EIP" {
    count = (length(var.EIPs) > 0 ?
            length(var.EIPs) : 0)

    domain = "vpc"
    tags = {
        Name = "${var.EIPs[count.index].NAME}"
    }
}

resource "aws_eip_association" "EIP_ASS" {
    count = (length(var.EIPs) > 0 ?
            length(var.EIPs) : 0)
    
    depends_on = [ aws_eip.EIP ]
    allocation_id = aws_eip.EIP[count.index].id
    instance_id = try(var.EIPs[count.index].INS_ID, null)
    network_interface_id = try(var.EIPs[count.index].NIC_ID, null)
}

# resource "aws_network_interface" "ADD_NIC" {
#     count = (length(var.ADD_NIC_NAME) > 0 ?
#             length(var.ADD_NIC_NAME) : 0)

#     subnet_id       = var.ADD_NIC_INFO[count.index].SN_ID
#     private_ips     = var.ADD_NIC_INFO[count.index].PRI_IPV4S
#     security_groups = var.ADD_NIC_INFO[count.index].VPC_SG_IDS

#     tags = {
#         Name = "${var.ADD_NIC_NAME[count.index]}${count.index}"
#     }
# }

# resource "aws_network_interface_attachment" "ADD_NIC_ATT" {
#     count = (length(var.ADD_NIC_NAME) > 0 ?
#             length(var.ADD_NIC_NAME) : 0)

#     network_interface_id = aws_network_interface.ADD_NIC[count.index].id
#     instance_id          = var.ADD_NIC_INS_ID[count.index]
#     device_index         = var.ADD_NIC_INFO[count.index].EC2_NIC_INDEX
# }

