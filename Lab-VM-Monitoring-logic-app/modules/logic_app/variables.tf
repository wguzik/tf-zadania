variable "rg_name" {
  type        = string
  description = "Resource group name"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "postfix" {
  type        = string
  description = "Postfix for resource naming"
}

variable "subscription_id" {
  type        = string
  description = "Azure subscription ID for role assignment"
}
