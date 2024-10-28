# Lab - Zewnętrzny plik stanu i różne środowiska

## Wymagania

Aktywna subskrypcja w Azure i dostęp do portalu.

## Wstęp

### Cel

Użycie zewnętrznego pliku stanu oraz prosta organizacja konfiguracji dla kilku środowisk.

> Jest możliwe migrowanie stanu z lokalnego i zewnętrznego repozytorium, ale nie jest to tematem tego zadania.

Czas trwania: 30 minut

### Plik stanu

Plik stanu to wciąż plik tekstowy, który musi być gdzieś przechowany. Terraform używa konceptu `backendu`, który wskazuje gdzie plik jest przechowywany. Domyślny typ `backendu` to `local`, co oznacza, że plik jest znajduje się w tej samej lokalizacji, w której jest uruchamiany Terraform.

Jednym z możliwych backendów do użycia jest `Storage Account`.
Powstaje problem natury co było pierwsze: jajko czy kura, ponieważ musimy stworzyć w jakiś sposób `Storage Account`, w którym będziemy trzymać pliki stanu.

W praktyce stosuje się rozdzielenie zasobów, np. utworzenie dedykowanej `Resource group` i `Storage Account` tamże z bardzo restrykcyjnymi zasadmi dostępu, lub całkowite wyniesenie tych zasobów do innej subskrypcji. Owe zasoby niekoniecznie są "trzymane" z pomocą IaC, być może powstały za pomocą skrytpów i są "nienaruszalne". To oczywiście niesie ze sobą pewne ryzyka i wrażliwym punktem dla stabilności rozwiązania.  
Popularnym rozwiązaniem jest zdelegowanie zarządzania stanem do dedykowanych usług takich jak Terraform Cloud lub SpaceLift.

Więcej w [oficjalnej dokumentacji](https://developer.hashicorp.com/terraform/language/settings/backends/configuration).

### Krok 0 - Uruchom Cloud Shell w Azure i sklonuj kod ćwiczeń

Nawiguj w przeglądarce do [portal.azure.com](https://portal.azure.com), uruchom "Cloud Shell" i wybierz `Bash`.

Oficjalna dokumentacja: [Cloud Shell Quickstart](https://github.com/MicrosoftDocs/azure-docs/blob/main/articles/cloud-shell/quickstart.md).

```bash
git clone https://github.com/wguzik/tf-zadania.git
```

> Poniższe kroki realizuje się za pomocą Cloud Shell

### Krok 1 - utwórz dedykowaną Resource Group i Storage Account na potrzeby backendu

- nawiguj do katalogu z repozytorium i katalogu `Lab-basics-03` i uruchom skryp do tworzenia podstawowych zasobów
```bash
cd tf-zadania/Lab-basics-03/scripts
chmod +x createInfra.sh
./createInfra.sh
```

### Krok 2 - Skonfiguruj backend

- nawiguj do katalogu z repozytorium i katalogu `Lab-basics-03`
```bash
cd tf-zadania/Lab-basics-03/infra
```

- uruchom edytor VS Code
```bash
code .
```

- dodaj blok do obsługi backendu wewnątrz bloku `terraform` w pliku `providers.tf` i umieść właściwie wartości

```hcl
terraform {
  backend "azurerm" {
    resource_group_name  = "<remote_backend_rg>"
    storage_account_name = "<remote_backend_storage_account>"
    container_name       = "dev" #dev one
    key                  = "terraform.tfstate"
  }
 //...
}
```

> Używamy uproszczonej konfiguracji, która wymaga, że użytkownik jest zalogowany. Jest to mało praktyczne, zazwyczaj używa się klucza/SAS tokenu, ale w celu uproszczenia przykładu ten frament pominąłem.

- zainicjalizuj konfigurację

```bash
terraform init
# poczekaj na output
```

- podejrzyj plik - nawiguj do odpowiedniego Storage Account w Azure i znajdź plik stanu w kontenerze `dev`

```bash
# opcjonalnie skorzytaj z wiersza poleceń
az storage blob list --account-name $SANAME --container-name dev -o table
```

### Krok 3 - Ukryj zmienne w pliku

W katalogu z plikami *.tf zweryfikuj zawartość `envs/dev.tfvars` i upewnij się, że dane są właście: inicjały i nazwa środowiska.

### Krok 4 - Zweryfikuj poprawność kodu i utwórz zasoby

```bash
terraform fmt -recursive
terraform validate
terraform plan -var-file='envs/dev.tfvars'

terraform apply -var-file='envs/dev.tfvars'
```

### Krok 5 - Utwórz plik konfiguracyjny dla backendu dla środowiska prod

- skopiuj plik `env.backend.hcl.example` i zmień mu nazwę

```bash
cp env.backend.hcl.example prod.backend.hcl
```

- uzupełnij dane `Storage account` podobnie jak w pliku `providers.tf`, wskaż `container` o nazwie `prod` (został uprzednio utworzony przez skrypt)

```hcl
resource_group_name  = "<>"
storage_account_name = "<>"
container_name       = "prod"
key                  = "terraform.tfstate"
```

### Krok 6 - Zainicuj konfigurację

```bash
terraform init -backend-config='prod.backend.hcl' -reconfigure
```

### Krok 7 - Ukryj zmienne w pliku

W katalogu z plikami *.tf zweryfikuj zawartość `envs/prod.tfvars` i upewnij się, że dane są właście: inicjały i nazwa środowiska.

### Krok 8 - Stwórz zasoby

```bash
terraform apply -var-file='envs/prod.tfvars'
```

### Krok 9 - Spróbuj 'omyłkowo' użyć złego pliku ze zmiennymi

```bash
terraform apply -var-file='envs/dev.tfvars'
```

### Krok 10 - Powróć do backendu środowiska dev

```bash
terraform init -reconfigure
# działa bez parametru, ponieważ wartości są wpisane do pliku providers.tf
```

### Krok 11 - Usuń plik stanu ze Storage Account

- usuń plik stanu ze `Storage Account` z kontenera `dev`

- upewnij się, że zasoby istnieją

- uruchom plan

```bash
terraform plan
```

### Krok 12 - Usuń zasoby

- terraform

```bash
terraform destroy -var=owner=wg
# pamiętaj o przełączeniu backendu, środowisko dev musisz usunąć częściowo ręcznie
```

- `Resource group` i `Storage Account` do przetrzymywania stanu musisz usunąć ręcznie

## Uwagi
To podejście wymaga sporej uwagi, a ryzyko błędu jest duże.
Ciekawsze rozwiązanie to `workspaces` z Terraform Cloud lub SpaceLift.

Zarządzanie dostępem i kopiami bezpieczeństwa to dodatkowe problemy, które leżą teraz na Twoich barkach.

## Zadanie domowe
Dodaj kolejne środowisko, np. test.
Poeksperymentuj usuwaniem i dodawaniem obiektów do pliku stanu, np. `terraform state rm`.