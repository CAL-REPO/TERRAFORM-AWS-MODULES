variable "PROFILE" {
    type = string
    default = null
}

variable "IGW" {
    type = list(object({
        NAME = string
        VPC_ID = string
    }))
    default = []
}

variable "NGW" {
    type = list(object({
        NAME = string
        VPC_ID = string
    }))    
    default = []
}

variable "VGW" {
    type = list(object({
        NAME = string
        AWS_ASN = string
        VPC_ID = string
        ZONE = string
    }))
    default = []    
}

variable "CGW" {
    type = list(object({
        NAME = string
        BGP_ASN = string
        IP = string
        TYPE = string 
    }))
    default = []
}

variable "TGW" {
    type = list(object({
        NAME = string
        AWS_ASN =string
        DNS_SUP = string
        VPN_DEFAULT_RTB_ASS = optional(string)
        VPN_DEFAULT_RTB_PROP = optional(string)
        VPN_ECMP_SUP = string
        MULTICAST_SUP = string
        AUTO_CROSS_ACC_ATT = string
        CIDRS = optional(list(string))
    }))
    default = []   
}

variable "TGW_CON_VPC" {
    type = list(object({
        NAME = string
        TGW_ID = string
        TGW_RTB_ID = string
        VPC_ID = string
        SN_IDs = list(string)
    }))
    default = []   
}

variable "TGW_CON_CGW" {
    type = list(object({
        NAME = string
        TGW_ID = string
        TGW_RTB_ID = string 
        DESTINATION_CIDR = string
        CGW_ID = string
        TYPE = string
        STATIC_ROUTE = bool
        TUNNEL1_PSK = string
        TUNNEL2_PSK = string
    }))
    default = []    
}

variable "TGW_PEER_REQUEST" {
    type = list(object({
        NAME = string
        TGW_ID = string
        TGW_RTB_ID = string 
        DESTINATION_CIDR = string
        PEER_OWNER_ID = string
        PEER_REG_NAME = string
        PEER_TGW_ID = string
        PEER_VPC_ID = string
    }))
    default = []    
}

variable "TGW_PEER_ACCEPT" {
    type = list(object({
        NAME = string
        TGW_ATT_ID = string
        TGW_RTB_ID = string 
        DESTINATION_CIDR = string
    }))
    default = []    
}

variable "TGW_PEER_REQUEST_ADD_ROUTE" {
    type = list(object({
        DESTINATION_CIDR    = string
        TGW_ATT_ID          = string
        TGW_RTB_ID          = string
        BLACKHOLE           = bool      
    }))
    default = []    
}

variable "TGW_PEER_ACCEPT_ADD_ROUTE" {
    type = list(object({
        DESTINATION_CIDR    = string
        TGW_ATT_ID          = string
        TGW_RTB_ID          = string
        BLACKHOLE           = bool      
    }))
    default = []    
}

# variable "TGW_CON_DX" {
#     type = list(object({
#         NAME = string
#         TGW_ATT_ID = string
#         TARGET_TGW_ID = string
#     }))
#     default = []
# }

variable "PEER_REQUEST" {
    type = list(object({
            NAME = string
            VPC_ID = string
            PEER_OWNER_ID = string
            PEER_VPC_ID = string
            PEER_REGION_NAME = string
            AUTO_ACCEPT = bool
    }))
    default = []    
}

variable "PEER_ACCEPT" {
    type = list(object({
        NAME = string
        PEER_ID = string
        AUTO_ACCEPT = bool 
    }))
    default = []    
}


