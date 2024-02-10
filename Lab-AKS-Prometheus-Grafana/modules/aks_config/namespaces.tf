resource "kubernetes_namespace" "namespace_monitoring" {
  for_each = var.namespaces

  metadata {
    name = each.value
  }
}