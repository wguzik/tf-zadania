locals {
  postfix        = "${var.project}-${var.environment}-${var.location}"
  postfix_shared = "${var.project}-shared-${var.location}"
}


module "rg_shared" {
  source = "./modules/rg"

  postfix     = local.postfix_shared
  project     = var.project
  environment = var.environment
  location    = var.location
}

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

module "kv" {
  source = "./modules/kv"

  rg_name = module.rg_shared.rg_name
  postfix = local.postfix

  depends_on = [
    module.rg_shared
  ]
}

module "monitoring" {
  source = "./modules/monitoring"

  rg_name = module.rg_shared.rg_name
  postfix = local.postfix

  depends_on = [
    module.rg_shared
  ]
}

module "vm" {
  source = "./modules/vm"

  rg_name        = module.rg.rg_name
  rg_name_shared = module.rg_shared.rg_name
  postfix        = local.postfix
  prefix         = "vm01"
  vnet_name      = module.vnet.vnet_name
  subnet_name    = module.vnet.subnet_name
  kv_name        = module.kv.kv_name
  law_id         = module.monitoring.law_id
  law_key        = module.monitoring.law_key

  //monitor_data_collection_rule_name = module.monitoring.monitor_data_collection_rule_name

  depends_on = [
    module.vnet
  ]
}
