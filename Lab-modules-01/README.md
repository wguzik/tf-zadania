# Lab - Wstęp do modułów

## Wymagania
Aktywna subskrypcja w Azure i dostęp do portalu.

## Wstęp

### Cel

Podział projektu na moduły i wielokrotne wykorzystanie.

Czas trwania: 45 minut

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
│  │  `- provider.tf
│  ├─ vnet/
│  │  ├─ main.tf
│  │  ├─ variables.tf
│  │  ├─ outputs.tf
│  │  `- provider.tf
│  ├─ vm/
│  │  ├─ main.tf
│  │  ├─ variables.tf
│  │  ├─ outputs.tf
│  │  `- provider.tf
```

> Uwaga! To ćwiczenie polega w dużej mierze na rozwiązywaniu problemów. Ono z zasady nie działa od razu. Nie krępuj się zmieniać kod, próbować, psuć i naprawiać.

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

### Krok 2 - Ukryj zmienne w pliku

W katalogu z plikami `*.tf` stwórz plik `terraform.tfvars` o treści:

```bash
owner="<Twojenicjaly>"
env="dev"
```

Terraform automatycznie zaczyta jego zawartość.

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

### Krok 5 - Stwórz kolejną maszynę wirtualną

W pliku `main.tf` skopiuj wywołanie modułu "vm" (sekcję `module "vm"`)

### Krok -1 - Usuń zasoby

```bash
terraform destroy
```

## Zadanie domowe

Dodaj moduł do tworzenia zasobu `KeyVault` i zapisz w nim hasło maszyny wirtualnej w taki sposób, żeby hasło było generowane jako obiekt terraforma, zapisywane do KeyVaulta i żeby było ono pobierane właśnie z KeyVaulta.

## Zadanie domowe 2

Dodaj drugi subnet i drugą maszynę wirtualną, która będzie go używać.
Upewnij się, że maszyny mogą się pingować. Jaka usługa odpowiada za kontrolę ruchu na poziomie subnetu?