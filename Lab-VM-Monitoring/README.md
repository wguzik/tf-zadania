# Lab - VM, Monitoring

***W budowe!***

## Wymagania
Aktywna subskrypcja w Azure i dostęp do portalu.

## Wstęp
### Cel
Podział projektu na moduły.

Czas trwania: 45 minut


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
  cd tf-zadania/Lab-VM-Monitoring
  ```

- zainicjalizuj Terraform
  ```bash
  terraform init
  ```

### Krok 2 - Ukryj zmienne w pliku

W katalogu z plikami *.tf stwórz plik `terraform.tfvars` o treści:

```bash
project="<Twojenicjaly>"
environment="dev"
location="westeurope"
```

Terraform automatycznie zaczyta jego zawartość.

### Krok 3 - Upewnij się, że kod jest poprawny i stwórz infrastrukturę

```bash
terraform fmt
terraform validate
terraform plan
terraform apply
```

### Krok 4 - Zweryfikuj ustawienia monitoringu
