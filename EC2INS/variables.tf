variable "PROFILE" {
    type = string
    default = null
}

variable "INSs" {
    type = list(object({
        NAME = string
        KEY_NAME = string
        AMI = string
        TYPE = string
        AUTO_PUBLIC_IP = optional(bool)
        SRC_DEST_CHECK = optional(bool)
        SN_ID = optional(string)
        SG_IDs = optional(list(string))
        PRI_IPV4s = optional(list(string))
        VOL_DIR = string
        VOL_SIZE = number
        VOL_TYPE = string
    }))
    default = []
}

variable "INS_UDs" {
    type = object({
        FILE = list(list(string))
        SCRIPT = list(string)
    })

    default = {}
}

# variable "INS_UD_FILEs" {
#     type = list(list(string))
#     default = []
# }

# variable "INS_UD_SCRIPTs" {
#     type = list(string)
#     default = []
# }