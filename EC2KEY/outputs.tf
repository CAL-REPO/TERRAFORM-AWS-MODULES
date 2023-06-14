output "KEY_NAME" {
    value = aws_key_pair.KEY[*].key_name
}

output "OWNER_ID" {
    value = data.aws_caller_identity.current.account_id
}

output "USER_ID" {
    value = data.aws_caller_identity.current.user_id
}