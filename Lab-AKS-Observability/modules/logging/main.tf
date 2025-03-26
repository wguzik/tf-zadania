resource "helm_release" "fluent_bit" {
  name       = "fluent-bit"
  repository = "https://fluent.github.io/helm-charts"
  chart      = "fluent-bit"
  namespace  = var.namespace
  version    = var.fluent_bit_version

  values = [
    templatefile("${path.module}/values/fluent-bit-values.yaml", {
      fluentd_service_name = var.fluentd_service_name
    })
  ]
}

resource "helm_release" "fluentd" {
  name       = "fluentd"
  repository = "https://fluent.github.io/helm-charts"
  chart      = "fluentd"
  namespace  = var.namespace
  version    = var.fluentd_version

  force_update    = true
  cleanup_on_fail = true
  replace         = true

  values = [
    templatefile("${path.module}/values/fluentd-values.yaml", {
      environment            = var.environment
      elasticsearch_user     = var.elasticsearch_user
      elasticsearch_password = var.elasticsearch_password
    })
  ]

  depends_on = [helm_release.fluent_bit]
}