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
- Backend: dwie maszyny wirtualne na linuksie, bez dostępu z publicznego internetu
- WIP: Baza danych: MS SQL jako PaaS, zaintegrowany z siecią

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

- otwórz edytor

  ```bash
  code .
  ```

- skopiuj plik `terraform.tfvars.example` do `terraform.tfvars` i wypełnij odpowiednimi wartościami

  ```bash
  cp terraform.tfvars.example terraform.tfvars
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

W pliku `main.tf` odkomentowuj bloki z modułami rozmaitych zasobów po kolei i rób `terraform init` i `terraform apply` za każdą zmianą. Obserwuj zmiany w portalu i zidentifikuj wdrożone ustawienia, np. znajdź gdzie jest skonfigurowany Private Enpoint/Private Link.
Znajdz DNS zonę itd.

### Krok 4 - Dodaj zasoby compute

Dodaj drugą maszynę wirtualną przez skopiowanie wywołania modułu `vm1` w pliku `main.tf`, zrób podobnie z `webapp1`.
Czy bieżąca konfiguracja jest wystarczają, żeby Application Gateway i Load Balancer "załapały" nowe zasoby?

### Krok 5 - Skonfiguruj ręcznie backend pool w load balancerze

Stwórz ręcznie load balancer:
- internal (wewnętrzny)
- w backend pool wybierz maszynę wirtualną

Dokumentacja: [https://learn.microsoft.com/en-us/azure/load-balancer/quickstart-load-balancer-standard-public-portal#create-load-balancer](https://learn.microsoft.com/en-us/azure/load-balancer/quickstart-load-balancer-standard-public-portal#create-load-balancer)


### Krok 6 - zweryfikuj sieć

Przygotuj:
- publiczny adres IP maszyny wirtualnej
- prywatny adres IP maszyny wirtualnej
- adres web appki

Otwórz web appkę w przeglądarce i sprawdź, czy jest dostępna. Edytuj adres w pasku przeglądarki i dodaj `scm`, następnie wybierz shell.

```bash 
# https://app-dev-gw-1.azurewebsites.net -> https://app-dev-gw-1.scm.azurewebsites.net
```

W konsoli (nazywa się Kudu) zarządzania web appki. Wpisz:

```bash
curl http://<publiczny-adres-ip-maszyny-wirtualnej>
```

```bash
curl http://<prywatny-adres-ip-maszyny-wirtualnej>
```

Adres prywatny nie powinien być osiągalny, ponieważ Web Appka nie ma integracji z siecią lokalną.

### Krok 7 - dodaj private endpoint

W pliku `modules/webapp/main.tf` odkomentuj sekcję opisaną Krok #7 i zrób `apply`.

Sprawdź w portalu, czy pojawił się private endpoint.

### Krok 8 - zweryfikuj sieć

```bash
curl http://<publiczny-adres-ip-maszyny-wirtualnej>
```

```bash
curl http://<prywatny-adres-ip-maszyny-wirtualnej>
```

Bonus:
podłącz się do VMki po SSH i spróbuj wykonać ćwiczenie w drugą stronę - czy jest "prywatna" siec dla web app?

### Krok -1 - Usuń zasoby

```bash
terraform destroy
```

> Uwaga! Load balancer trzeba usunąć ręcznie w portalu.
