variable "namespace" {
  type    = string
  default = "logging"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "fluent_bit_version" {
  type    = string
  default = "0.39.0"
}

variable "fluentd_version" {
  type    = string
  default = "0.5.0"
}

variable "fluentd_service_name" {
  type    = string
  default = "fluentd"
}

variable "elasticsearch_user" {
  description = "Username for Elasticsearch authentication"
  default       = "elastic"
  type        = string
}

variable "elasticsearch_password" {
  description = "Password for Elasticsearch authentication"
  type        = string
  default     = "password"
  sensitive   = true
}
