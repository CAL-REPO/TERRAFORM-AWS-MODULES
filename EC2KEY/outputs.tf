output "KEY_NAME" {
    value = join(",", values(local.KEYs[*].NAME))
}

output "KEY_FILE_NAME" {
    value = join(",", values(local.KEYs[*].KEY_FILE_NAME))
}

output "KEY_LINUX_FILE" {
    value = join(",", values(local.KEYs[*].KEY_LINUX_FILE))
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