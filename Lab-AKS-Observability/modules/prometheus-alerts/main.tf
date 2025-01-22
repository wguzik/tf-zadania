

resource "kubernetes_manifest" "prometheus_rule" {
  manifest = {
    apiVersion = "monitoring.coreos.com/v1"
    kind       = "PrometheusRule"
    metadata = {
      name      = var.rule_name
      namespace = var.namespace
      labels = {
        release = "kube-prometheus-stack"
      }
    }
    spec = {
      groups = [
        {
          name  = "custom.rules"
          rules = var.custom_alert_rules != null ? var.custom_alert_rules : local.default_alert_rules
        }
      ]
    }
  }
} 