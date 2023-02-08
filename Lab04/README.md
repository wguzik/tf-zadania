# Lab04 - Moduły

## Wymagania
Aktywna subskrypcja w Azure i dostęp do portalu.

## Wstęp
### Cel
Podział projektu na moduły.

Czas trwania: 30 minut

### Organizacja plików

Kod może być podzielony na moduły, tak aby odseparować zasoby od siebie.

Nie oznacza to, że można nimi zarządzać w pełni oddzielnie, niemniej ułatwia to pracę i pozwala łatwiej zapanować nad zależnościami, takimi jak np. maszyny wirtualne, które w trakcie tworzenia muszą być podłączone do sieci wirtualnej.

Odpowiednio wykorzystane obiekty `output` pozwalają udostępnić niezbędne informacje dalej.

Typ obiektu `data` pozwala się odwołać do istniejącego obiektu.

Przykładowa organizacja projektu z wykorzystaniem modułów:
```
infrastructure/
├─ infra.tf
├─ variables.tf
├─ providers.tf
├─ outputs.tf
├─ modules
│  ├─ rg/
│  │  ├─ main.tf
│  │  ├─ variables.tf
│  │  ├─ outputs.tf
│  │  ├─ provider.tf
│  ├─ vnet/
│  │  ├─ main.tf
│  │  ├─ variables.tf
│  │  ├─ outputs.tf
│  │  ├─ provider.tf
│  ├─ vm/
│  │  ├─ main.tf
│  │  ├─ variables.tf
│  │  ├─ outputs.tf
│  │  ├─ provider.tf
```

### Krok 0 - Uruchom Cloud Shell w Azure i sklonuj kod ćwiczeń
Nawiguj w przeglądarce do [portal.azure.com](https://portal.azure.com), uruchom "Cloud Shell" i wybierz `Bash`.

Oficjalna dokumentacja: [Cloud Shell Quickstart](https://github.com/MicrosoftDocs/azure-docs/blob/main/articles/cloud-shell/quickstart.md).

```bash
git clone https://github.com/wguzik/tf-zadania.git
```

> Poniższe kroki realizuje się za pomocą Cloud Shell

### Krok 1 - Zainicjalizuj Terraform
- nawiguj do katalogu z repozytorium i Lab04
  ```bash
  cd tf-zadania/Lab04
  ```

- zainicjalizuj Terraform
  ```bash
  terraform init
  ```

### Krok 2 - Ukryj zmienne w pliku

W katalogu z plikami *.tf stwórz plik `terraform.tfvars` o treści:

```
owner= "<Twojenicjaly>
env= "dev"
```

Terraform automatycznie zaczyta jego zawartość.

### Krok 3 - Upewnij się, że kod jest poprawny

```bash
terraform fmt
terraform validate
terraform plan
```

### Krok 3 - Przejrzyj kod, zwróć uwagę, że jest nieuporządkowany



### Krok 4 - Zaplanuj stworzenie zasobów

```bash
terraform plan
```

Spróbuj ponownie podając parametr:

```bash
terraform plan -var="owner=<TwojeInicjaly>"
```

Skorzystaj z oficjalnej dokumentacji providera `Azure_RM` oraz zasobu typu `azurerm_storage_account`, żeby upewnić się co do wymagań stawianych nazwie zasobu.

Stwórz zasoby.

### Krok 5 - Stwórz zasoby

```bash
terraform apply -var="owner=<TwojeInicjaly>"
```

### Krok 6 - Ukryj zmienne w pliku

W katalogu z plikami *.tf stwórz plik `terraform.tfvars` i umieść w nim `owner=<TwojeInicjaly>`.

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

## Zadanie domowe
Dodaj moduł do KeyVaulta i zapisz w nim hasło maszyny wirtualnej w taki sposób, żeby hasło było generowane uprzednio, zapisywane do KeyVaulta i żeby maszyna pobierała je z niego.