variable "PROFILE" {
    type = string
    default = null
}

variable "EIPs_NAME" {
    type = list(string)
    default = []
}

variable "EIPs" {
    type = list(object({
        NAME = string
        INS_ID = optional(string)
        NIC_ID = optional(string)
    }))
    default = []
}

# variable "NIC" {
#     type = list(string)
#     default = []
# }