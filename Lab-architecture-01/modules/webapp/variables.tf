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

variable "subnet_pe_id" {
  type = string
}

variable "subnet_webfarm_id" {
  type = string
}

variable "subnet_appgw_id" {
  type = string
}

variable "postfix" {
  type = string
}

variable "lb_ip" {
  type = string
}


