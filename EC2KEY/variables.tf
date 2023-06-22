variable "PROFILE" {
    type = string
    default = null
}

variable "KEYs" {
    type = list(object({
        NAME = string 
        ALGORITHM = optional(string)
        RSA_SIZE = optional(number)
        FILE_TYPE = optional(string)
        BACKUP_DIR = optional(string)
        LINUX_DIR = optional(string)
        S3_DIR = optional(string)
    }))
}