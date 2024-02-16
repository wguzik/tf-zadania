# Lab-upgrade-provider - Aktualizacja providera

## Wymagania
Aktywna subskrypcja w Azure i dostęp do portalu.

## Wstęp
### Cel
Cykl życia providera, różnice w wersjach i aktualizacja.

Czas trwania: 45 minut

### Provider 
Provider to dodatek/biblioteka/rozszerzenie pozwalające na komunikowanie się Terraforma np. z chmurą Azure.

Providery do popularnych usług są na bieżąco rozwijane, ponieważ te usługi same w sobie się zmieniają i Terraform musi 'umieć' obsłużyć nowe fuunkcjonalności.

> Uwaga! To ćwiczenie polega w dużej mierze na rozwiązywaniu problemów. Ono z zasady nie działa od razu. Nie krępuj się zmieniać kod, próbować, psuć i naprawiać.

### Krok 0 - Uruchom Cloud Shell w Azure i sklonuj kod ćwiczeń

Nawiguj w przeglądarce do [portal.azure.com](https://portal.azure.com), uruchom "Cloud Shell" i wybierz `Bash`.

Oficjalna dokumentacja: [Cloud Shell Quickstart](https://github.com/MicrosoftDocs/azure-docs/blob/main/articles/cloud-shell/quickstart.md).

```bash
git clone https://github.com/wguzik/tf-zadania.git
```

> Poniższe kroki realizuje się za pomocą Cloud Shell

### Krok 1 - Zainicjalizuj Terraform

- nawiguj do katalogu z repozytorium i Lab03
  ```bash
  cd tf-zadania/Lab-upgrade-provider-01
  ```

- zainicjalizuj Terraform
  ```bash
  terraform init
  ```

### Krok 2 - Zweryfikuj kod

```bash
terraform fmt
terraform validate
terraform plan
```

### Krok 3 - Stwórz serwer PostgreSQL

```bash
terraform apply -var="owner=<yourinitials>"
```

Popraw błędy, jeżeli jakieś występują.

> Azure odmawia stworzenia zasobu? Spróbuj w innym regionie.

### Krok 4 - Zmień wersję serwera

```hcl
resource "azurerm_postgresql_flexible_server" "tfpsql" {
  version                = 11 #-> 14
  # ...
  zone                   = "1"
}
```

```bash
terraform apply -var="owner=<yourinitials>"
```

Jaki komunikat dostajesz? Popraw błędy, jeżeli występują.

### Krok 5 - Zweryfikuj wersję użytego providera i użyj nowszego w kodzie

- znajdź najnowszą wersję providera i zweryfikuj dostępne wersje servera PostgreSQL: [postgresql_flexible_server](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server)
  ```hcl
  terraform {
    required_providers {
      azurerm = {
        source  = "hashicorp/azurerm"
        version = "~>x.x.x" # sprawdź jakie możliwości we wskazywaniu wersji proponuje Terraform
      }
    }
  }
  ```
- zmiana wersji wymaga ponowego zainicjalizowania Terraforma
  ```bash
  terraform init -upgrade
  ```

### Krok 6 - Zaktualizuj wersję serwera

```bash
terraform apply -var="owner=<yourinitials>"
```

Prześledź dokładnie informację - okazuje się, że terraform chce zniszczyć obecny serwer i zastąpić go nowym.
To jest jedna z tych sytuacji, kiedy ani Terraform, ani provider nie mają możliwości zrobienia tego w inny sposób. To ograniczenie pochodzi od samego dostawcy chmury [Upgrade PostgreSQL](https://learn.microsoft.com/en-us/azure/postgresql/single-server/how-to-upgrade-using-dump-and-restore).

### Krok 7 - Zmień hasło

Zmień hasło w kodzie i spróbuj zaaplikować konfigurację.

```bash
terraform apply -var="owner=<yourinitials>"
```

### Krok 8 - Usuń zasoby

```
terraform destroy
```
