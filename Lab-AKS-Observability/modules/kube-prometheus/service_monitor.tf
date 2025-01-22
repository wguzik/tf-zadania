#resource "kubernetes_manifest" "default_service_monitor" {
#  manifest = {
#    apiVersion = "monitoring.coreos.com/v1"
#    kind       = "ServiceMonitor"
#    metadata = {
#      name      = "metrics-monitor"
#      namespace = "metrics"
#      labels = {
#        app = "metrics"
#      }
#    }
#    spec = {
#      selector = {
#        matchExpressions = [
#            {
#          key = "app"
#          operator = "Exists"
#        }
#        ]
#      }
#      endpoints = [
#        {
#          port   = "metrics"
#          path   = "/metrics"
#          scheme = "http"
#          interval = "15s"
#        }
#      ]
#      namespaceSelector = {
#        any = true
#      }
#    }
#  }
#
#  depends_on = [helm_release.kube-prometheus]
#}
