output "EIP_ID" {
    value = try(aws_eip.EIP[*].id, null)
}

output "EIP_IP" {
    value = try(aws_eip.EIP[*].public_ip, null)
}

# output "NIC_ID" {
#     value = try(aws_network_interface.ADD_NIC[*].id, null)
# }