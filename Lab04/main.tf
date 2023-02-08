module "rg" {
  source = "./modules/rg"

  owner = var.owner # var.owner to zmienna istniejąca dla nadrzędnego modułu - tego, natomiast 'owner' to zmienna istniejąca wewnątrz modułu 'rg'
  environment = var.environment
  location = var.location
}

module "vnet" {
  source = "./modules/vnet"

  owner = var.owner
  environment = var.environment

  rg_name = module.rg.rg_name # Składnia 'module.rg.rg_name' to jest odwołanie do obiektu 'output' o nazwie 'rg_name' w module 'rg'

  depends_on = [      # Dzięki tej sekcji Terraform poczeka z uruchomieniem tworzenia tego zasobu do momentu, w którym z modułu 'rg' zostanie zwrócona wartość 'rg_name'
    module.rg.rg_name
  ]
}

#module "vm" {
#  source = "./modules/vm"
#
#  ## Uzupełnij brakującą zmienną
#  environment = var.environment
#
#  rg_name   = module.rg.rg_name
#  subnet_id = module.vnet.subnet_id
#
#  ## Napisz zależność od modułu vnet od obiektu subnet_id
#}