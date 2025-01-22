resource "helm_release" "elasticsearch" {
  name       = "elasticsearch"
  repository = "https://helm.elastic.co"
  chart      = "elasticsearch"
  namespace  = var.namespace
  version    = var.elasticsearch_version

  set {
    name  = "replicas"
    value = var.elasticsearch_replicas
  }

  set {
    name  = "minimumMasterNodes"
    value = var.elasticsearch_master_nodes
  }
}

resource "helm_release" "kibana" {
  name       = "kibana"
  repository = "https://helm.elastic.co"
  chart      = "kibana"
  namespace  = var.namespace
  version    = var.kibana_version

  set {
    name  = "elasticsearchHosts"
    value = "http://elasticsearch-master:9200"
  }

  depends_on = [helm_release.elasticsearch]
}
