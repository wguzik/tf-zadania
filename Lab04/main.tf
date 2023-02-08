module "rg" {
  source = "./modules/rg"

  owner = var.owner
  environment = var.environment

  location = "westeurope"
}

module "vnet" {
  source = "./modules/vnet"

  owner = var.owner
  environment = var.environment

  rg_name = module.rg.rg_name

  depends_on = [
    module.rg.rg_name
  ]
}

module "vm" {
  source = "./modules/vm"

  owner = var.owner
  environment = var.environment

  rg_name   = module.rg.rg_name
  subnet_id = module.vnet.subnet_id

  depends_on = [
    module.vnet.subnet_id
  ]
}