# Lab01 - tworzenie zasobów w terraform

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



### Organizacja plików
Terraform pozwala na dzielenie konfiguracji na kilka różnych plików. 

Kod może być podzielony również na moduły, tak aby odseparować obiekty od siebie, ten temat będzie poruszony w innym labie.

W trakcie uruchomienia Terraform łączy podzielone pliki w jeden.

Przykładowa organizacja projektu o płaskiej strukturze:

```
rg/
├─ rg.tf
├─ variables.tf
├─ outputs.tf
├─ provider.tf

```

Na potrzeby separacji zasobów lub domen można podzielić projekt na moduły:

Przykładowa organizacja projektu z wykorzystaniem modułów:
```
infrastructure/
├─ infra.tf
├─ variables.tf
├─ providers.tf
├─ outputs.tf
├─ modules
│  ├─ rg/
│  │  ├─ rg.tf
│  │  ├─ variables.tf
│  │  ├─ outputs.tf
│  │  ├─ provider.tf
│  ├─ sa/
│  │  ├─ sa.tf
│  │  ├─ variables.tf
│  │  ├─ outputs.tf
│  │  ├─ provider.tf
```

### Krok 0 - Uruchom Cloud Shell w Azure i sklonuj kod ćwiczeń
Nawiguj w przeglądarce do [portal.azure.com](https://portal.azure.com), uruchom "Cloud Shell" i wybierz `Bash`.

Oficjalna dokumentacja: [Cloud Shell Quickstart](https://github.com/MicrosoftDocs/azure-docs/blob/main/articles/cloud-shell/quickstart.md).

```
git clone <>
```

> Poniższe kroki realizuje się za pomocą Cloud Shell

### Krok 1 - Zainicjalizuj Terraform
- nawiguj do katalogu z repozytorium i Lab01
```bash
cd <nazwarepo>/Lab01
```

- zainicjalizuj Terraform
```bash
terraform init
```

Jakie informacje pojawiły się na ekranie?

### Krok 2 - Upewnij się, że kod jest poprawny

```bash
terraform validate
```

Skorzystaj z oficjalnej dokumentacji providera `Azure_RM` oraz zasobu typu `azurerm_resource_group`, żeby sprawdzić listę niezbędnych parametrów.

Popraw błędy i ponów za pomocą wbudowanego edytora.

### Krok 3 - Przejrzyj kod, zwróć uwagę, że jest nieuporządkowany

```bash
terraform fmt
```

### Krok 4 - Zaplanuj stworzenie zasobów

```bash
terraform plan
```

Spróbuj ponownie podając parametr:

```bash
terraform plan -var="owner=<TwojeNazwisko>"
```

Skorzystaj z oficjalnej dokumentacji providera `Azure_RM` oraz zasobu typu `azurerm_storage_account`, żeby upewnić się co do wymagań stawianych nazwie zasobu.
Wprowadź niezbędne poprawki.

Stwórz zasoby.

### Krok 5 - Stwórz zasoby

```bash
terraform apply -var="owner=<TwojeNazwisko>"
```

### Krok 6 - Ukryj zmienne w pliku

W katalogu z plikami *.tf stwórz plik `terraform.tfvars` i umieść w nim `owner= "<TwojeNazwisko>"`.

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
zamień na 
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


### Krok 8 - Usuń zasoby

```
terraform destroy
```