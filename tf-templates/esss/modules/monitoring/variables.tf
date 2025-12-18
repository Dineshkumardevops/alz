variable "name_prefix" {
  description = "Environment prefix (e.g., esss-dev, esss-uat)"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "retention_in_days" {
  description = "Log Analytics retention in days"
  type        = number
  default     = 30
}
