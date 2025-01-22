module "rg" {
  source = "./modules/rg"

  postfix     = local.postfix
  project     = var.project
  environment = var.environment
  location    = var.location
}

module "vnet" {
  source = "./modules/vnet"

  rg_name = module.rg.rg_name
  postfix = local.postfix

  depends_on = [
    module.rg
  ]
}

module "aks_infra" {
  source = "./modules/aks_infra"

  rg_name             = module.rg.rg_name
  postfix             = local.postfix
  vnet_name           = module.vnet.vnet_name
  subnet_default_name = module.vnet.subnet_default_name

  depends_on = [
    module.vnet
  ]
}

##Sekcja-namespace
#module "aks_config" {
#  source = "./modules/aks_config"
#
#  namespaces = toset(local.namespaces)
#
#  rg_name = module.rg.rg_name
#
#  depends_on = [
#    module.aks_infra
#  ]
#}

##Sekcja-metryki
#module "kube-prometheus" {
#  source        = "./modules/kube-prometheus"
#  stack_version = local.kube_prometheus_stack_version
#
#  depends_on = [
#    module.aks_config
#  ]
#}

##Sekcja-logging-elasticsearch
#module "elasticsearch" {
#  source = "./modules/elasticsearch"
#  
#  elasticsearch_version = local.elasticsearch_version
#  kibana_version       = local.kibana_version
#  
#  depends_on = [
#    module.aks_config
#  ]
#}

##Sekcja-logging
#module "logging" {
#  source = "./modules/logging"
#  
#  fluent_bit_version = local.fluent_bit_version
#  fluentd_version    = local.fluentd_version
#  environment        = var.environment
#  
#  depends_on = [
#    module.elasticsearch
#  ]
#}

##Sekcja-alerty
#module "prometheus_alerts" {
#  source = "./modules/prometheus-alerts"
#  
#  rule_name = "custom-alerts"
#  namespace = "metrics"
#}