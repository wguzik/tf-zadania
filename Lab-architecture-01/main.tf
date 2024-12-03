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
  rg_name     = module.rg.rg_name

  depends_on = [
    module.rg.rg_name
  ]
}

// #1
//module "dns" {
//  source = "./modules/dns"
//
//  rg_name     = module.rg.rg_name
//  environment = var.environment
//  owner       = var.owner
//  vnet_id     = module.vnet.vnet_id
//
//  depends_on = [
//    module.rg
//  ]
//}

// #1
//module "kv" {
//  source = "./modules/kv"
//
//  rg_name        = module.rg.rg_name
//  environment    = var.environment
//  owner          = var.owner
//  subnet_back_id = module.vnet.subnet_id_back
//  dns_name       = module.dns.dns_kv_name
//  dns_id         = module.dns.dns_kv_id
//
//  depends_on = [
//    module.rg,
//    module.vnet,
//    module.dns
//  ]
//}

// Krok #4
//module "vm1" {
//  source = "./modules/vm"
//
//  environment = var.environment
//
//  postfix   = "1"
//  rg_name   = module.rg.rg_name
//  subnet_id = module.vnet.subnet_id_back
//  owner     = var.owner
//
//  kv_id = module.kv.kv_id
//
//  depends_on = [
//    module.vnet,
//    module.kv
//  ]
//}

// # Krok #4
//module "webapp1" {
//  source = "./modules/webapp"
//
//  environment       = var.environment
//  postfix           = "1"
//  rg_name           = module.rg.rg_name
//  subnet_pe_id      = module.vnet.subnet_id_front
//  subnet_webfarm_id = module.vnet.subnet_id_webfarm
//  owner             = var.owner
//  subnet_appgw_id   = module.vnet.subnet_id_appgw
//  depends_on = [
//    module.vnet,
//    module.dns
//  ]
//}

# Krok #5 Stwórz ręcznie load balancer

//// 
////module "lb" {
////  source = "./modules/lb"
////
////  rg_name        = module.rg.rg_name
////  environment    = var.environment
////  subnet_back_id = module.vnet.subnet_id_back
////  owner          = var.owner
////  vm1_nic        = module.vm1.vm_nic
////
////  depends_on = [
////    module.rg,
////    module.vm1
////  ]
////}
//
//// #3
////module "sql1" {
////  source = "./modules/sql"
////
////  environment = var.environment
////  postfix     = "1"
////  rg_name     = module.rg.rg_name
////
////  vnet_id        = module.vnet.vnet_id
////  subnet_back_id = module.vnet.subnet_id_back
////  dns_name       = module.dns.dns_sql_name
////  dns_id         = module.dns.dns_sql_id
////  kv_id          = module.kv.kv_id
////
////  owner = var.owner
////
////  depends_on = [
////    module.vnet,
////    module.dns,
////    module.kv
////  ]
////}
//
//// #4 skip
////module "appgw" {
////  source = "./modules/appgw"
////
////  rg_name = module.rg.rg_name
////
////  environment     = var.environment
////  subnet_appgw_id = module.vnet.subnet_id_appgw
////  owner           = var.owner
////
////  webapp_fqdn = module.webapp1.webapp_fqdn
////
////  depends_on = [
////    module.rg,
////    module.vnet,
////    module.webapp1
////  ]
////}
////
