locals {
  postfix                       = "${var.project}-${var.environment}-${var.location}"
  namespaces                    = ["metrics", "nginx", "logging"]
  kube_prometheus_stack_version = "68.3.0"
  elasticsearch_version         = "7.17.3"
  kibana_version                = "7.17.3"
  fluent_bit_version            = "0.48.5"
  fluentd_version               = "0.5.2"
}