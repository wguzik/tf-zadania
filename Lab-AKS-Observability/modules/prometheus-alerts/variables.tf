variable "namespace" {
  description = "Kubernetes namespace where to create the alert rules"
  type        = string
  default     = "metrics"
}

variable "rule_name" {
  description = "Name of the PrometheusRule resource"
  type        = string
}

variable "custom_alert_rules" {
  description = "List of custom Prometheus alert rules. If not provided, default rules will be used"
  type        = list(any)
  default     = null
} 