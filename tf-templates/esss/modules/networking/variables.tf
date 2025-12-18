variable "name_prefix" {
  description = "Environment prefix (esss-dev, esss-uat)"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "vnet_address_prefix" {
  description = "VNet CIDR block"
  type        = string
}

variable "subnets" {
  description = "List of subnets"
  type = list(object({
    name   = string
    prefix = string
  }))
}

variable "log_analytics_id" {
  description = "Log Analytics Workspace ID for diagnostics"
  type        = string
}
