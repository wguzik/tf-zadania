variable "environment" {
  type    = string
  default = "dev"
}

variable "owner" {
  type = string
}

variable "rg_name" {
  type = string
}

variable "subnet_appgw_id" {
  type = string
}

variable "webapp_fqdn" {
  type = string
}
