variable "PROFILE" {
    type = string
    default = null
}

variable "VPC" {
    type = object({
        NAME                = string
        CIDR                = string
        DNS_SUP             = optional(bool)
        DNS_HOST            = optional(bool)
        DHCP_NAME           = optional(string)
        DHCP_DOMAIN         = optional(string)
        DHCP_DOMAIN_NSs     = optional(list(string))
        DHCP_DOMAIN_NTPs    = optional(list(string))
        DHCP_DOMAIN_NBSs    = optional(list(string))
        DHCP_DOMAIN_NODE    = optional(bool)
        Za_SN1_NAME         = optional(string)
        Za_SN2_NAME         = optional(string)
        Za_SN3_NAME         = optional(string)
        Za_SN1_CIDR         = optional(string)
        Za_SN2_CIDR         = optional(string)
        Za_SN3_CIDR         = optional(string)
        Zb_SN1_NAME         = optional(string)
        Zb_SN2_NAME         = optional(string)
        Zb_SN3_NAME         = optional(string)
        Zb_SN1_CIDR         = optional(string)
        Zb_SN2_CIDR         = optional(string)
        Zb_SN3_CIDR         = optional(string)
        Zc_SN1_NAME         = optional(string)
        Zc_SN2_NAME         = optional(string)
        Zc_SN3_NAME         = optional(string)
        Zc_SN1_CIDR         = optional(string)
        Zc_SN2_CIDR         = optional(string)
        Zc_SN3_CIDR         = optional(string)
    })
    default = null
}

variable "SGs" {
    type = list(object({
        NAME = string
        INGRESS = list(object({
            from_port   = string
            to_port     = string
            protocol    = string
            cidr_blocks = list(string)
            description = optional(string)
        }))
        EGRESS = list(object({
            from_port   = string
            to_port     = string
            protocol    = string
            cidr_blocks = list(string)
            description = optional(string)
        }))
    }))
    default = []
}

variable "RTBs" {
    type = list(object({
        NAME = string
        SN_ID = string
        ROUTE = list(object({
            cidr_block                  = optional(string)
            ipv6_cidr_block             = optional(string)
            egress_only_gateway_id      = optional(string)
            gateway_id                  = optional(string)
            nat_gateway_id              = optional(string)
            network_interface_id        = optional(string)
            transit_gateway_id          = optional(string)
            vpc_endpoint_id             = optional(string)
            vpc_peering_connection_id   = optional(string)
            SN_ID                       = optional(string)
        }))
    }))
    default = []
}