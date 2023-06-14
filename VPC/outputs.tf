output "VPC_ID" {
    value = aws_vpc.VPC[0].id
}

output "Za_SN1_ID" {
    value = try(aws_subnet.Za_SN1[0].id, null)
}

output "Za_SN2_ID" {
    value = try(aws_subnet.Za_SN2[0].id, null)
}

output "Za_SN3_ID" {
    value = try(aws_subnet.Za_SN3[0].id, null)
}

output "Zb_SN1_ID" {
    value = try(aws_subnet.Zb_SN1[0].id, null)
}

output "Zb_SN2_ID" {
    value = try(aws_subnet.Zb_SN2[0].id, null)
}

output "Zb_SN3_ID" {
    value = try(aws_subnet.Zb_SN3[0].id, null)
}

output "Zc_SN1_ID" {
    value = try(aws_subnet.Zc_SN1[0].id, null)
}

output "Zc_SN2_ID" {
    value = try(aws_subnet.Zc_SN2[0].id, null)
}

output "Zc_SN3_ID" {
    value = try(aws_subnet.Zc_SN3[0].id, null)
}

output "DEFAULT_SG_ID" {
    value = try(aws_default_security_group.DEFAULT_SG[0].id, null)
}

output "SG_ID" {
    value = try(aws_security_group.SG[*].id, null)
}

output "DEFAULT_RTB_ID" {
    value = try(aws_default_route_table.DEFAULT_RTB[0].id, null)
}

output "RTB_ID"{
    value = try(aws_route_table.RTB[*].id, null)
}