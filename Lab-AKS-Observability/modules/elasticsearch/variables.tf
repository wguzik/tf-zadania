variable "namespace" {
  type    = string
  default = "logging"
}

variable "elasticsearch_version" {
  type    = string
  default = "7.17.3"
}

variable "kibana_version" {
  type    = string
  default = "7.17.3"
}

variable "elasticsearch_replicas" {
  type    = number
  default = 1
}

variable "elasticsearch_master_nodes" {
  type    = number
  default = 1
} 