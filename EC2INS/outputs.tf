output "ID"{
    value = aws_instance.INS[*].id
}

output "DEFAULT_NIC_ID" {
    value = try(aws_instance.INS[*].primary_network_interface_id, null)
}

output "NIC_ID" {
    value = try(aws_network_interface.DEFAULT_NIC[*].id, null)
}

output "PUBLIC_IP" {
    value = try(aws_instance.INS[*].public_ip, null)
}