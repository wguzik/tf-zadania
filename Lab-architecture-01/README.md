# Lab - Architecture - multitier

## Wymagania
Aktywna subskrypcja w Azure i dostęp do portalu.

## Wstęp

### Cel

Podział projektu na moduły.

Czas trwania: 45 minut

## Multitier

`Multitier` albo `n-tier` to podział infrastruktury według funkcji, który pozwala na lepszą separację zasobów i odpowiednie stosowanie zarówno zasad skalowania jak i bezpieczeństwa.

Architektura:
- Frontend: dwie web appki, wymóg integracji z siecią
- Backend: dwie maszyny wirtualne na linuxie, bez dostępu z publicznego internetu
- Baza danych: MS SQL jako PaaS, zaintegrowany z siecią

### Krok 0 - Uruchom Cloud Shell w Azure i sklonuj kod ćwiczeń

Nawiguj w przeglądarce do [portal.azure.com](https://portal.azure.com), uruchom "Cloud Shell" i wybierz `Bash`.

Oficjalna dokumentacja: [Cloud Shell Quickstart](https://github.com/MicrosoftDocs/azure-docs/blob/main/articles/cloud-shell/quickstart.md).

```bash
git clone https://github.com/wguzik/tf-zadania.git
```

> Poniższe kroki realizuje się za pomocą Cloud Shell

### Krok 1 - Zainicjalizuj Terraform

- nawiguj do katalogu z repozytorium i katalogu `Lab-modules-01`
  ```bash
  cd tf-zadania/Lab-architecture-01
  ```

- skopiuj plik `terraform.tfvars.example` do `terraform.tfvars` i wypełnij odpowiednimi wartościami

  ```bash
  cp terraform.tfvars.example terraform.tfvars

  code terraform.tfvars
  ```

- zainicjalizuj Terraform
  ```bash
  terraform init
  ```

### Krok 2 - Upewnij się, że kod jest poprawny

```bash
terraform fmt
terraform validate
terraform plan
```

### Krok 3 - Dodawaj po kolei zasoby

W pliku `main.tf` odkomentowuj bloki z modułami rozmaitych zasobów po kolei (najpierw `vnet`) i rób `apply` za każdą zmianą. Obserwuj zmiany w portalu i zidentifikuj wdrożone ustawienia, np. znajdź gdzie jest skonfigurowany Private Enpoint/Private Link.
Znajdz DNS zonę itd.

W przypadku modułu `webapp1` odkomentuj `lb_ip` dopiero po stworzeniu Load Balancera. Sprawdź kod w module i upewnij się, że będzie użyty. 

### Krok 4 - Dodaj nowe zasoby

Dodaj drugą maszynę wirtualną przez skopiowanie wywołania modułu `vm1` w pliku `main.tf`, zrób podobnie z `webapp1`.
Czy bieżąca konfiguracja jest wystarczają, żeby Application Gateway i Load Balancer "załapały" nowe zasoby?

### Krok 5 - Skonfiguruj ręcznie backend pool w load balancerze

[https://learn.microsoft.com/en-us/azure/load-balancer/quickstart-load-balancer-standard-public-portal#create-load-balancer](https://learn.microsoft.com/en-us/azure/load-balancer/quickstart-load-balancer-standard-public-portal#create-load-balancer)

Jakie zmiany widzi terraform, a jakich nie?

```bash
terraform plan
```

Zaimportuj brakujące zasoby i dopisz konfigurację do pliku `modules/lb/main.tf`.

### Krok -1 - Usuń zasoby

```bash
terraform destroy
```