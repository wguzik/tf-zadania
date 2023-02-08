# Lab04 - Moduły

## Wymagania
Aktywna subskrypcja w Azure i dostęp do portalu.

## Wstęp
### Cel
Organizacja plików w terraform oraz pliki stanu.

Czas trwania: 30 minut

### Organizacja plików
Terraform pozwala na dzielenie konfiguracji na kilka różnych plików. 

Kod może być podzielony również na moduły, tak aby odseparować obiekty od siebie, ten temat będzie poruszony w innym miejscu.

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

Popraw błędy i ponów.

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

Stwórz zasoby.

### Krok 5 - Stwórz zasoby

```bash
terraform apply -var="owner=<TwojeNazwisko>"
```

### Krok 6 - Ukryj zmienne w pliku

W katalogu z plikami *.tf stwórz plik `terraform.tfvars` i umieść w nim `owner=<TwojeNazwisko>`.

Terraform automatycznie zaczyta jego zawartość.

```bash
terraform apply
```

### Krok 7 - Usuń ręcznie Storage Account i odtwórz go za pomocą Terraforma

W Portalu Azure znajdź Storage Account, którzy utworzyłeś/aś i usuń go ręcznie.

Uruchom `terraform plan`, aby zweryfikować propozycję zmian, następnie odtwórz zasób.


### Krok 8 - Usuń zasoby

```
terraform destroy
```