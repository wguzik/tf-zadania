variable "rg_name" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "id" {
  type = number
  default = 0
}

variable "owner" {
  type = string
}