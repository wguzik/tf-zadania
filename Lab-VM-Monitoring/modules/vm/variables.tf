variable "rg_name" {
  type    = string
  default = "wg"
}

variable "rg_name_shared" {
  type    = string
  default = "wg"
}

variable "postfix" {
  type    = string
  default = "wg-dev-westeurope"
}

variable "vnet_name" {
  type    = string
  default = "vnet-wg-dev-westeurope"
}

variable "subnet_name" {
  type    = string
  default = "snet-wg-dev-westeurope"
}

variable "prefix" {
  type    = string
  default = "vm"
}

variable "kv_name" {
  type    = string
  default = "kv"
}

variable "law_id" {
  type = string
}

variable "law_key" {
  type = string
}