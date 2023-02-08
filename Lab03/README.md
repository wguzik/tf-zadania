# Lab03 - Aktualizacja providera

## Wymagania
Aktywna subskrypcja w Azure i dostęp do portalu.

## Wstęp
### Cel
Organizacja plików w terraform oraz pliki stanu.

Czas trwania: 30 minut

### Provider 
Provider to dodatek/biblioteka/rozszerzenie pozwalające na komunikowanie się Terraforma np. z chmurą Azure.

Providery do popularnych usług są na bieżąco rozwijane, ponieważ te usługi same w sobie się zmieniają i Terraform musi 'umieć' obsłużyć nowe fuunkcjonalności.


### Krok 0 - Uruchom Cloud Shell w Azure i sklonuj kod ćwiczeń
Nawiguj w przeglądarce do [portal.azure.com](https://portal.azure.com), uruchom "Cloud Shell" i wybierz `Bash`.

Oficjalna dokumentacja: [Cloud Shell Quickstart](https://github.com/MicrosoftDocs/azure-docs/blob/main/articles/cloud-shell/quickstart.md).

```bash
git clone https://github.com/wguzik/tf-zadania.git
```

> Poniższe kroki realizuje się za pomocą Cloud Shell

### Krok 1 - Zainicjalizuj Terraform
- nawiguj do katalogu z repozytorium i Lab01
  ```bash
  cd tf-zadania/Lab03
  ```

- zainicjalizuj Terraform
  ```bash
  terraform init
  ```

Jakie informacje pojawiły się na ekranie?

### Krok 2 - Zweryfikuj kod

```bash
terraform fmt
terraform validate
terraform plan
```

### Krok 3 - stwórz serwer PostgreSQL

```bash
terraform apply -var="owner=<yourinitials>"
```

### Krok 4 - Zmień wersję

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