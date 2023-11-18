module "rg" {
  source = "./modules/rg"

  owner       = var.owner # var.owner to zmienna istniejąca dla nadrzędnego modułu - tego, natomiast 'owner' to zmienna istniejąca wewnątrz modułu 'rg'
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

module "dns" {
  source = "./modules/dns"

  rg_name = module.rg.rg_name

  environment = var.environment

  owner = "wg"

  vnet_id = module.vnet.vnet_id

  depends_on = [module.rg]

}

//module "kv" {
//  source = "./modules/kv"
//
//  rg_name = module.rg.rg_name
//
//  environment = var.environment
//
//  owner          = "wg"
//  subnet_back_id = module.vnet.subnet_id_back
//
//  dns_name = module.dns.dns_kv_name
//
//  dns_id = module.dns.dns_kv_id
//
//  depends_on = [
//    module.rg,
//    module.vnet,
//    module.module.dns
//  ]
//}


module "vm1" {
  source = "./modules/vm"

  environment = var.environment

  postfix   = "1"
  rg_name   = module.rg.rg_name
  subnet_id = module.vnet.subnet_id_back
  owner     = "wg"

  depends_on = [
    module.vnet
  ]
}

module "webapp1" {
  source = "./modules/webapp"

  environment       = var.environment
  postfix           = "1"
  rg_name           = module.rg.rg_name
  subnet_pe_id      = module.vnet.subnet_id_front
  subnet_webfarm_id = module.vnet.subnet_id_webfarm
  owner             = "wg"
  subnet_appgw_id   = module.vnet.subnet_id_appgw

  lb_ip = module.lb.lb_ip

  depends_on = [
    module.vnet,
    module.dns
  ]
}

module "sql1" {
  source = "./modules/sql"

  environment = var.environment
  postfix     = "1"
  rg_name     = module.rg.rg_name

  vnet_id        = module.vnet.vnet_id
  subnet_back_id = module.vnet.subnet_id_back

  dns_name = module.dns.dns_sql_name

  dns_id = module.dns.dns_sql_id

  owner = "wg"

  depends_on = [
    module.vnet,
    module.dns
  ]
}

module "appgw" {
  source = "./modules/appgw"

  rg_name = module.rg.rg_name

  environment     = var.environment
  subnet_appgw_id = module.vnet.subnet_id_appgw
  owner           = "wg"

  webapp_fqdn = module.webapp1.webapp_fqdn

  depends_on = [
    module.rg,
    module.vnet,
    module.webapp1
  ]
}

module "lb" {
  source = "./modules/lb"

  rg_name = module.rg.rg_name

  environment    = var.environment
  subnet_back_id = module.vnet.subnet_id_back
  owner          = "wg"

  vm1_nic = module.vm1.vm_nic

  depends_on = [module.rg, module.vm1]
}