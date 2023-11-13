# Lab - Wykorzystanie publicznie dostępnych modułów

## Wymagania
Aktywna subskrypcja w Azure i dostęp do portalu.

## Wstęp

### Cel

Wykorzystanie publicznie dostępnych modułów do szybkiego prototypowania

Czas trwania: 45 minut

### Użycie modułów

Terraform umożliwia pisanie własnych modułów i odwoływanie się do nich m.in. z publicznego repozytorium.

W dużych projektach powszechną praktyką jest posiadanie wspólnych modułów do popularnych elementów infrastruktury takich jak sieć czy maszyny wirtualne. Terraform umożliwia korzystanie z prywatnych repozytoriów dla modułów.

W poniższym zadaniu wykorzystasz gotowe moduły z publicznego repozytorium terraform do stworzenia bazowej infratruktury dla projektu wykorzystującego Azure Kubernetes Services, który jest zintegrowany z siecią.

Niezbędne obiekty infrastruktury:
- Resource Group
- Virtual Network, minimum 2 subnety
- Azure Kubernetes Services i dodatkowa pula workerów

> Poniższe ćwiczenie zakłada szybkie prototypowanie, wobec czego wiele dobrych praktyk będzie celowo łamanych.

### Publicznie dostępne moduły

Dostępne moduły znadziesz w oficjalnym repozytorium [https://registry.terraform.io/browse/modules](https://registry.terraform.io/browse/modules). Po otwarciu strony wybierz chmurę "Azure" z menu po lewej.  
Zauważ, że istnieje przełącznik, który pozwala odfiltrować tylko te moduły, które są dostarczone przez partnerów.

Przejrzyj dostępne moduły pod kątem niezbędnych zasobów. Czy jest ich wystarczająca liczba? Czy posiadają wystarczającą dokumentację, żeby można ich użyć bez większego problemu?

### Krok 0 - Uruchom Cloud Shell w Azure i sklonuj kod ćwiczeń

Nawiguj w przeglądarce do [portal.azure.com](https://portal.azure.com), uruchom "Cloud Shell" i wybierz `Bash`.

Oficjalna dokumentacja: [Cloud Shell Quickstart](https://github.com/MicrosoftDocs/azure-docs/blob/main/articles/cloud-shell/quickstart.md).

```bash
git clone https://github.com/wguzik/tf-zadania.git
```

> Poniższe kroki realizuje się za pomocą Cloud Shell

### Krok 1 - Zainicjalizuj Terraform

- nawiguj do katalogu z repozytorium i katalogu `Lab-modules-02`
  ```bash
  cd tf-zadania/Lab-modules-02
  ```

- uruchom VS Code w bieżącym katalogu

  ```bash
  code .
  ```

- stwórz plik `main.tf` i zapisz w nim zmienne:

  ```bash
  touch main.tf
  ```

  ```hcl
  variable "prefix" {
  type    = string
  default = "wglabdev" # użyj własnego prefixu, sugeruję inicjały i np. 'lab'
  }
  ```

- zainicjalizuj terraform
  ```bash
  terraform init
  ```

### Krok 2 - Wykorzystaj moduł do generowania nazw i stwórz Resource group

- **dopisz** konfigurację modułu [naming](https://registry.terraform.io/modules/Azure/naming/azurerm/latest), skopiuj przykład z sekcji "Usage"

  ```hcl
  variable "prefix" {
    #
  }

  module "naming" {
    source  = "Azure/naming/azurerm" # nie ma tutaj pełnej ścieżki, ponieważ terraform "dopowiada" sobie oficjalne repozytorium 
    suffix = ["${var.prefix}"]
  }
  
  resource "azurerm_resource_group" "example" {
    name     = module.naming.resource_group.name
    location = "West Europe"
  }
  ```
  
- dostosuj przykład do scenariusza

  ```hcl
  module "naming" {
    source  = "Azure/naming/azurerm" # 
    suffix = [ "${var.environment}" ] # użyj zmiennej dla środowiska
  }
  ```
  
  W ten sposób gotowy moduł wygeneruje nazwę zgodną z wymaganiami terraforma i Azure.

- zainicjalizuj ponownie konfigurację (niezbędny krok po dodaniu modułu), uporządkuj kod i sprawdź efekt

  ```bash
  terraform init
  terraform fmt
  terraform validate
  ```

Przyjrzyj się zawartości katalogu, zauważ, że moduł został ściągnięty z zewnętrznego repozytorium.

  ```bash
  ls ./terraform/modules/naming
  ```

 - dodaj brakującą konfigurację do providera dla Azure

  ```bash
  terraform plan

  > Error: Insufficient features blocks
  ``` 
  Na samej górze konfiguracji dopisz:

  ```hcl
  #main.tf
  
  provider "azurerm" {
    features {}
  }
  
  var "environment {
    #
  }
  ```

- stwórz Resource group

  ```bash
  terraform apply
  ```

### Krok 3 - Wykorzystaj moduł do stworzenia sieci

- **dopisz** konfigurajcę do virtual network za pomocą modułu [network](https://registry.terraform.io/modules/Azure/network/azurerm/latest)

```hcl
module "network" {
  source              = "Azure/network/azurerm"
  resource_group_name = azurerm_resource_group.example.name
  address_spaces      = ["10.0.0.0/16", "10.2.0.0/16"]
  subnet_prefixes     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  subnet_names        = ["subnet1", "subnet2", "subnet3"]

  subnet_service_endpoints = {
    "subnet1" : ["Microsoft.Sql"],
    "subnet2" : ["Microsoft.Sql"],
    "subnet3" : ["Microsoft.Sql"]
  }
  use_for_each = true
  tags = {
    environment = "dev" # dev
    costcenter  = "it"
  }
}
```

- usuń niepotrzebne zasoby i dostosuj kod

```hcl
module "network" {
  vnet_name           = module.naming.virtual_network.name # dodaj nazwę z 'generatora'
  source              = "Azure/network/azurerm"
  resource_group_name = azurerm_resource_group.example.name
  address_spaces      = ["10.52.0.0/16"] # użyj tylko jednego zakresu
  subnet_prefixes     = ["10.52.0.0/24","10.52.1.0/24"] # użyj dwóch subnetów, upewnij się, że maski pasują do zakresu
  subnet_names        = ["subnet1" ] #użyj dwóch subnetów,

  subnet_service_endpoints = {
    "subnet1" : ["Microsoft.Sql"] # pozostaw jeden subnet
  }
  use_for_each = true
  tags = {
    environment = "dev"
    costcenter  = "it" # usuń tag
  }

  depends_on = [azurerm_resource_group.example] # upewnij się, że odnosisz się do właściwego zasobu
}
```

- zainicjalizuj ponownie konfigurację (niezbędny krok po dodaniu modułu), uporządkuj kod i sprawdź efekt

  ```bash
  terraform init
  terraform fmt
  terraform validate
  terraform plan
  ```

- zweryfikuj dostępne [zmienne wejściowe](https://registry.terraform.io/modules/Azure/network/azurerm/latest?tab=inputs) w module i dodaj parametr dla nazwy

```hcl
module "network" {
  vnet_name = module.naming.virtual_network.name
  source              = "Azure/network/azurerm"
  resource_group_name = azurerm_resource_group.example.name
  
  # ...
}
```

- stwórz VNet

  ```bash
  terraform apply
  ```

### Krok 4 - Wykorzystaj moduł do stworzenia klastra Azure Kubernetes Services

- **dopisz** konfigurajcę do virtual network za pomocą modułu [aks](https://registry.terraform.io/modules/Azure/aks/azurerm/latest)

> Część modułów ma [przykłady](https://github.com/Azure/terraform-azurerm-aks/blob/7.4.0/examples/multiple_node_pools/main.tf), jeżeli nie wiesz jak go użyć, skorzystaj z nich i zmodyfikuj do potrzeb.

> Użycie modułów wymaga podstawowej znajomości docelowego zasobu, niektóre ze zmiennych wejściowych mogą być nieoczywiste lub nieobsługiwane, co może spowodować konflikty.

```hcl
locals { # zmienne lokalne 
  nodes = {
    for i in range(2) : "worker${i}" => { # pętla foreach, która pozwala tworzyć kilka zasobów
      name           = "worker${i}"
      vm_size        = "Standard_D2s_v3"
      node_count     = 1
      vnet_subnet_id = module.network.vnet_subnets[0] # użyj subnetu
    }
  }
}

module "aks" {
  source              = "Azure/aks/azurerm"
  version             = "7.4.0"

  prefix                        = "${var.prefix}"
  resource_group_name           = azurerm_resource_group.example.name # użyj Resource Group
  os_disk_size_gb               = 60
  public_network_access_enabled = false
  sku_tier                      = "Free" # Free pozwala oszczedzić kilka groszy, ale nie jest za darmo
  rbac_aad                      = false
  vnet_subnet_id                = module.network.vnet_subnets[0] # użyj subnetu
  node_pools                    = local.nodes

  log_analytics_workspace_enabled = false #  nie twórz zasobów do logów (LAW)

    depends_on = [ azurerm_resource_group.example,
    module.network
    ] # upewnij się, że AKS nie będzie tworzony zanim powstanie RG i VNet
}
```

- zainicjalizuj ponownie konfigurację (niezbędny krok po dodaniu modułu), uporządkuj kod i sprawdź efekt

  ```bash
  terraform init
  terraform fmt
  terraform validate
  terraform plan
  ```

## Usuń zasoby

```bash
terraform destroy
```