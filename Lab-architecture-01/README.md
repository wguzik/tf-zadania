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
  cd tf-zadania/Lab-modules-01
  ```

- zainicjalizuj Terraform
  ```bash
  terraform init
  ```

### Krok 3 - Upewnij się, że kod jest poprawny

```bash
terraform fmt
terraform validate
terraform plan
```

### Krok 3 - Zweryfikuj kod

Znajdź fragmenty opisane zaczynające się od `##` i uzupełnij brakujący kod.

Odkomentuj zaczytanie modułu `vm`.

### Krok 4 - Stwórz zasoby

```bash
terraform apply
```

Coś poszło nie tak?

Sprawdź zasoby w portalu, które powstały. Spróbuj ponowić - czy Terraform będzie chciał zamienić wszystko?

Jaką tym razem napotkałeś/aś przeszkodę?

Zmień rozmiar maszyny na `Standard_B1ls` w kodzie i ponów próbę wdrożenia.

Okazuje się, że zdefiniowany obraz nie jest odpowiedni. Skąd wziąć właściwe informacje?

Uruchom:
```bash
az vm image list --all --publisher="Canonical" --sku="20_04-lts"
```

i w pliku [modules/vm/main.tf](Lab04\modules\vm\main.tf) umieść odpowiednie informacje:

```hcl
resource "azurerm_linux_virtual_machine" "tfvm01" {
  ##

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "20.04.202302070"
  }
}
```

### Krok 5 - Usuń zasoby

```bash
terraform destroy
```

## Zadanie domowe

Dodaj moduł do tworzenia zasobu `KeyVault` i zapisz w nim hasło maszyny wirtualnej w taki sposób, żeby hasło było generowane jako obiekt terraforma, zapisywane do KeyVaulta i żeby było ono pobierane właśnie z KeyVaulta.

## Zadanie domowe 2

Dodaj drugi subnet i drugą maszynę wirtualną, która będzie go używać.
Upewnij się, że maszyny mogą się pingować. Jaka usługa odpowiada za kontrolę ruchu na poziomie subnetu?