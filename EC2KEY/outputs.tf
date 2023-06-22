output "KEY_NAME" {
    value = [for KEY in local.KEYs : KEY.NAME]
}

output "KEY_FILE_NAME" {
    value = [for KEY in local.KEYs : KEY.KEY_FILE_NAME]
}

output "KEY_LINUX_FILE" {
    value = [for KEY in local.KEYs : KEY.KEY_LINUX_FILE]
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