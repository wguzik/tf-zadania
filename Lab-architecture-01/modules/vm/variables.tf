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

variable "subnet_id" {
  type = string
}

variable "postfix" {
  type = string
}

variable "kv_id" {
  type = string
}