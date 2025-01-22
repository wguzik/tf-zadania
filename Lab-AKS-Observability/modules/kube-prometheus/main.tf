resource "helm_release" "kube-prometheus" {
  name       = "kube-prometheus-stack"
  repository = "https://prometheus-community.github.io/helm-charts"
  namespace  = var.namespace
  version    = var.stack_version
  chart      = "kube-prometheus-stack"
}