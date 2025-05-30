# Lab - Podstawy tworzenienia zasobów w Terraform

## Wymagania

Aktywna subskrypcja w Azure i dostęp do portalu.

## Wstęp

### Cel

Podstawy organizacji plików, korzystania z `terraform CLI` oraz tworzenia zasobów w chmurze.

Czas trwania: 30 minut

### Typy obiektów

Terraform pozwala na tworzenie obiektów:
- `resource` - zasób, te obiekty będą odpowiedzialne za tworzenie m.in. zasobów w chmurze
- `variable` - parametry wejścia, które pozwalają m.in. na wielokrotne użycie tego samego kodu oraz używanie własnych nazw zasobów
- `data` - pozwalają 'zaczytanie' istniejących obiektów
- `output` - dzięki nim można przekazać dalej np. adres IP serwera albo inną istotną informację
- `provider` - trzyma informację o providerze, czyli dodatku pozwalającemu terraformowi komunikować się z np. z chmurą

### Polecenia konsoli

Polecenie `terraform` pozwala na uruchomienie Terraforma w wierszu poleceń. W praktyce jest to całe środowisko pozwalające na sprawdzanie, tworzenie i zarządzanie zasobami (terraformowymi, nie cloudowymi).

Przydatne polecenia na początek:
```bash
terraform validate # Sprawdza poprawność składni
terraform fmt      # Formatuje kod
terraform plan     # "Na sucho" sprawdza efekt wykonania
terraform apply    # Wprowadza zmiany
terraform destroy  # Usuwa zdefiniowane zasoby
```

### Krok 0 - Uruchom Cloud Shell w Azure i sklonuj kod ćwiczeń

Nawiguj w przeglądarce do [portal.azure.com](https://portal.azure.com), uruchom "Cloud Shell" i wybierz `Bash`.

Oficjalna dokumentacja: [Cloud Shell Quickstart](https://github.com/MicrosoftDocs/azure-docs/blob/main/articles/cloud-shell/quickstart.md).

```bash
git clone https://github.com/wguzik/tf-zadania.git
```

> Poniższe kroki realizuje się za pomocą Cloud Shell.

### Krok 1 - podaj subskrypcję jako zmienną

- nawiguj do katalogu z repozytorium i katalogu `Lab-basics-01`

```bash
cd tf-zadania/Lab-basics-01
```

- w katalogu z plikami `*.tf` stwórz plik przez skopiowanie `terraform.tfvars.example` i zmianę nazwy na `terraform.tfvars`,

```bash
cp terraform.tfvars.example terraform.tfvars
```

- podaj subskrypcję

```bash
subscription_id=$(az account show --query="id")
sed -i "s/YourSubscriptionID/$subscription_id/g" terraform.tfvars
```

### Krok 2 - Zainicjalizuj Terraform

- zainicjalizuj Terraform

```bash
terraform init
```

Jakie informacje pojawiły się na ekranie?

### Krok 3 - Zweryfikuj poprawność kodu

```bash
terraform validate
```

Skorzystaj z oficjalnej dokumentacji providera `Azure_RM` oraz zasobu typu `azurerm_resource_group`, żeby sprawdzić listę niezbędnych parametrów.

Popraw błędy i ponów za pomocą wbudowanego edytora:

```
code .
```

### Krok 4 - Uporządkuj kod

```bash
terraform fmt
```

### Krok 5 - Zaplanuj stworzenie zasobów

```bash
terraform plan
```

Spróbuj ponownie podając parametr:

```bash
terraform plan -var="owner=<TwojeInicjaly>"
```

Skorzystaj z oficjalnej dokumentacji providera `Azure_RM` oraz zasobu typu `azurerm_storage_account`, żeby upewnić się co do wymagań stawianych nazwie zasobu.
Wprowadź niezbędne poprawki.

Stwórz zasoby.

### Krok 5 - Stwórz zasoby

```bash
terraform apply -var="owner=<TwojeInicjaly>"
```

### Krok 6 - Ukryj zmienne w pliku

W katalogu z plikami *.tf stwórz plik `terraform.tfvars` i umieść w nim `owner="<TwojeInicjaly>"`.

Terraform automatycznie zaczyta jego zawartość.

```bash
terraform apply
```

### Krok 7 - Popraw konfigurację tak, aby używała taga środwiska z parametru

Storage Account posiada wpisane na sztywno środowisko, jest ono niepoprawne.

```hcl
resource "azurerm_storage_account" "tfsa" {
  #
  tags = {
    environment = "test" #tutaj użyj parametru
  }
}
```
zamień na:

```hcl
resource "azurerm_storage_account" "tfsa" {
  #
  tags = {
    environment = "${var.environment}" 
  }
}
```

Zaaplikuj zmiany.
Jak wygląda komunikat terraforma w sprawie zmian?

### Krok 7 - Usuń ręcznie Storage Account i odtwórz go za pomocą Terraforma

W Portalu Azure znajdź Storage Account, którzy utworzyłeś/aś i usuń go ręcznie.

Uruchom `terraform plan`, aby zweryfikować propozycję zmian, następnie odtwórz zasób.


### Krok -1 - Usuń zasoby

```
terraform destroy
```

## Zadanie dodatkowe
Dodaj więcej do zmiennej `environment` ograniczenie dotyczące możliwych wartości, np 'dev', 'test', 'prod'.