locals {
  default_alert_rules = [
    {
      alert = "ContainerHighCPUUsage"
      expr  = "sum(rate(container_cpu_usage_seconds_total{container!=\"\"}[5m])) by (pod, container, namespace) * 100 > 30"
      for   = "5m"
      labels = {
        severity = "warning"
      }
      annotations = {
        summary     = "Container High CPU Usage"
        description = "Container {{ $labels.container }} in pod {{ $labels.pod }} in namespace {{ $labels.namespace }} has CPU usage above 80% for 5 minutes"
      }
    },
    {
      alert = "NodeHighCPUUsage"
      expr  = "100 - (avg by(instance) (rate(node_cpu_seconds_total{mode=\"idle\"}[5m])) * 100) > 80"
      for   = "5m"
      labels = {
        severity = "warning"
      }
      annotations = {
        summary     = "Node High CPU usage detected"
        description = "CPU usage on node {{ $labels.instance }} is above 80% for 5 minutes"
      }
    },
    {
      alert = "HighMemoryUsage"
      expr  = "(node_memory_MemTotal_bytes - node_memory_MemAvailable_bytes) / node_memory_MemTotal_bytes * 100 > 80"
      for   = "5m"
      labels = {
        severity = "warning"
      }
      annotations = {
        summary     = "High memory usage detected"
        description = "Memory usage is above 80% for 5 minutes"
      }
    }
  ]
}
