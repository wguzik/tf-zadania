locals {
  postfix = "${var.project}-${var.environment}-${var.location}"
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
