variable "project" {
  type    = string
  default = "wg"
}

variable "environment" {
  type = string
  validation {
    condition = contains(
      ["dev", "test", "prod"],
      var.environment
    )
    error_message = "Environment is not: dev, test or prod."
  }
  default = "dev"
}

variable "location" {
  type = string
  validation {
    condition = contains(
      ["westeurope", "northeurope"],
      var.location
    )
    error_message = "Location is not: westeurope or northeurope."
  }
  default = "westeurope"
}
