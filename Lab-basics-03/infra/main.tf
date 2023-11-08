module "rg" {
  source = "./modules/rg"

  owner       = var.owner
  environment = var.environment
  location    = var.location
}

module "vnet" {
  source = "./modules/vnet"

  owner       = var.owner
  environment = var.environment

  rg_name = module.rg.rg_name

  depends_on = [
    module.rg.rg_name
  ]
}
