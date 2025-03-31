# Lab - Architecture - multitier

## Wymagania
Aktywna subskrypcja w Azure i dostęp do portalu.

## Wstęp

### Cel

Podział projektu na moduły.

Czas trwania: 45 minut

## Multitier

`Multitier` albo `n-tier` to podział infrastruktury według:
- funkcji
- zasad skalowania
- dostępów
- ...

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

- w katalogu z plikami `*.tf` stwórz plik przez skopiowanie `terraform.tfvars.example` i zmianę nazwy na `terraform.tfvars`,

```bash
cp terraform.tfvars.example terraform.tfvars
```

- podaj subskrypcję

```bash
subscription_id=$(az account show --query="id")
sed -i "s/YourSubscriptionID/$subscription_id/g" terraform.tfvars
```

- otwórz edytor

```bash
code .
```

i zamień wartość `owner` na np. swój inicjał:

```bash
owner = "wg"
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

W pliku `main.tf` odkomentowuj bloki z modułami rozmaitych zasobów po kolei i wykonuj `terraform init` i `terraform apply` za każdą zmianą. Obserwuj zmiany w portalu i zidentifikuj wdrożone ustawienia, np. znajdź gdzie jest skonfigurowany `Private Enpoint`.
Znajdz DNS zonę itd.

### Krok 4 - Dodaj zasoby compute

Dodaj drugą maszynę wirtualną przez skopiowanie wywołania modułu `vm1` w pliku `main.tf`, zrób podobnie z `webapp1`.
Jak dostać się do zasobów?

### Krok 5 - Skonfiguruj ręcznie backend pool w load balancerze

Stwórz ręcznie load balancer:
- internal (wewnętrzny)
- w backend pool wybierz maszynę wirtualną

Upewnij się, że masz skonfigurowane:
- load balcing rules
- health probe

Dokumentacja: [https://learn.microsoft.com/en-us/azure/load-balancer/quickstart-load-balancer-standard-public-portal#create-load-balancer](https://learn.microsoft.com/en-us/azure/load-balancer/quickstart-load-balancer-standard-public-portal#create-load-balancer)

### Krok 6 - zweryfikuj sieć

Przygotuj:
- publiczny adres IP maszyny wirtualnej
- prywatny adres IP maszyny wirtualnej
- adres web appki
- adres prywatny load balancera

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

```bash
curl http://<prywatny-adres-ip-load-balancera>
```

Wszystkie adresy są osiągalne, ponieważ Web Appka posiada integrację z siecią lokalną "na wyjściu".

```bash
nslookup http://<adres keyvaulta>
```

### Krok 7 - dodaj private endpoint do web appki

W tym kroku dodajemy private endpoint do web appki. Obecnie web appka nie ma integracji z siecią lokalną na wejściu, czyli jeżeli są zasoby wewnątrz VNet bez dostępu do publicznego internetu, to nie mają dostępu do web appki.

Upewnij się, czy web app jest dalej dostępna publicznie (poszukaj w dokumentacji).

W pliku `modules/webapp/main.tf` odkomentuj sekcję opisaną Krok #7 i zrób `apply`.

Sprawdź w portalu, czy pojawił się private endpoint.

### Krok 8 - zweryfikuj sieć z VMki

Podłącz się do VMki po SSH i spróbuj wykonać ćwiczenie w drugą stronę - czy jest "prywatna" siec dla web app?

```bash
nslookup <adres-web-appki>
```

```bash
curl https://<adres-web-appki>
```

### Krok 9 - Wpis DNS dla maszyny wirtualnej

Spróbuj wykorzystać bieżącą konfigurację.

Zobacz jak można to zrobić: [https://learn.microsoft.com/en-us/azure/dns/dns-private-zone-terraform?tabs=azure-cli](https://learn.microsoft.com/en-us/azure/dns/dns-private-zone-terraform?tabs=azure-cli).

### Krok -1 - Usuń zasoby

```bash
terraform destroy
```

> Uwaga! Load balancer trzeba usunąć ręcznie w portalu.
