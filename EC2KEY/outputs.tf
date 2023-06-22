output "KEY_NAME" {
    value = aws_key_pair.KEY[*].key_name
}

output "OWNER_ID" {
    value = data.aws_caller_identity.current.account_id
}

output "USER_ID" {
    value = data.aws_caller_identity.current.user_id
}

output "PRI_KEY" {
    value = try("${tls_private_key.PRI_KEY[*].private_key_pem}", null)
}