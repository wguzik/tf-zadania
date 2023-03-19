locals {
  postfix        = "${var.project}-${var.environment}-${var.location}"
  postfix_shared = "${var.project}-shared-${var.location}"
}