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

```bash
az create group --location 'westeurope' --name 'tfstate'

az create storage account
```


- nawiguj do katalogu z repozytorium i katalogu `Lab-basics-03`
```bash
cd tf-zadania/Lab-basics-03
```

- utwórz pliki i przenieś odpowiednie bloki to odpowiednich plików
```bash
touch providers.tf
touch versions.tf
touch outputs.tf
```

### Krok 2 - Zweryfikuj poprawność kodu

```bash
terraform fmt
terraform validate
terraform plan
```

### Krok 3 - Ukryj zmienne w pliku

W katalogu z plikami *.tf stwórz plik `terraform.tfvars` i umieść w nim `owner= "<TwojeInicjaly>"`.

Terraform automatycznie zaczyta jego zawartość.


### Krok 4 - Stwórz zasoby

```bash
terraform apply
```

### Krok 5 - Podejrzyj hasło w KeyVault w portalu

### Krok 6 - Podejrzyj plik stanu

```bash
ls -a
cat terraform.tfstate
```

Przejrzyj uważnie plik i poszukaj frazy `result`, porównaj wartość z tą, którą odczytałeś/aś z KeyVault.

Plik stanu w Terraformie przechowuje wiele informacji, w tym hasła w postaci zwykłego tekstu. Plik stanu jest kluczowy nie tylko ze względu na terraform jako taki, ale również przez fakt, że są w nim Twoje hasła.

### Krok 8 - Usuń zasoby

```
terraform destroy
```

## Zadanie domowe

Stwórz Storage Account ręcznie, a następnie zaimportuj go do stanu.
> Podpowiedź: warto wcześniej napisać w terraformie. `terraform plan` Twoim przyjacielem.