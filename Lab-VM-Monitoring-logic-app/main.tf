module "rg" {
  source = "./modules/rg"

  postfix     = local.postfix
  project     = var.project
  environment = var.environment
  location    = var.location
}

module "logic_app" {
  source = "./modules/logic_app"

  rg_name         = module.rg.rg_name
  location        = var.location
  postfix         = local.postfix
  subscription_id = data.azurerm_subscription.current.subscription_id

  depends_on = [
    module.rg
  ]
}
