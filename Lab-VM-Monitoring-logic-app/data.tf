data "azurerm_subscription" "current" {}

locals {
  postfix = "${var.project}-${var.environment}-${var.location}"
}
