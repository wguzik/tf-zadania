variable "rg_name" {
  type = string
}

variable "postfix" {
  type    = string
  default = "wg-dev-westeurope"
}

variable "vnet_name" {
  type    = string
  default = "vnet-wg-dev-westeurope"
}

variable "subnet_default_name" {
  type    = string
  default = "snet-wg-dev-westeurope"
}

