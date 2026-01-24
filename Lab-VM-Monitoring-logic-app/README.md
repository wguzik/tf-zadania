# Lab - VM, Logic App

***W budowie!***

## Wymagania
Aktywna subskrypcja w Azure i dostęp do portalu.
Rola "Owner" na subskrypcji lub inna równoważna pozwalająca przypiswać role.

## Wstęp

### Cel
Utworzenie Logic App z planem Consumption, która będzie zarządzać maszynami wirtualnymi w Azure.
Logic App będzie posiadać system-assigned managed identity z rolą "Virtual Machine Contributor" na poziomie subskrypcji.

Czas trwania: 30 minut


### Krok 0 - Uruchom Cloud Shell w Azure i sklonuj kod ćwiczeń

Nawiguj w przeglądarce do [portal.azure.com](https://portal.azure.com), uruchom "Cloud Shell" i wybierz `Bash`.

Oficjalna dokumentacja: [Cloud Shell Quickstart](https://github.com/MicrosoftDocs/azure-docs/blob/main/articles/cloud-shell/quickstart.md).

```bash
git clone https://github.com/wguzik/tf-zadania.git
```

> Poniższe kroki realizuje się za pomocą Cloud Shell

### Krok 1 - Nawiguj do katalogu z projektem

- nawiguj do katalogu z repozytorium i katalogu `Lab-VM-Monitoring-logic-app`

```bash
cd tf-zadania/Lab-VM-Monitoring-logic-app
```

### Krok 2 - Ukryj zmienne w pliku

- w katalogu z plikami `*.tf` stwórz plik przez skopiowanie `terraform.tfvars.example` i zmianę nazwy na `terraform.tfvars`,

```bash
cp terraform.tfvars.example terraform.tfvars
```

- podaj subskrypcję

```bash
subscription_id=$(az account show --query="id")
sed -i "s/YOUR_SUBSCRIPTION_ID_HERE/$subscription_id/g" terraform.tfvars
```

- następnie zmień zawartość:

```bash
project="<Twojenicjaly>"
environment="dev"
location="westeurope"
```

Terraform automatycznie zaczyta jego zawartość.

- zainicjalizuj Terraform

```bash
terraform init
```

### Krok 3 - Upewnij się, że kod jest poprawny i stwórz infrastrukturę

```bash
terraform fmt
terraform validate
terraform plan
terraform apply
```

### Krok 4 - Zweryfikuj utworzone zasoby

Po zakończeniu wdrożenia, sprawdź utworzone zasoby:

- Resource Group: `rg-<project>-<environment>-<location>`
- Logic App: `logic-vm-manager-<project>-<environment>-<location>`
- Managed Identity: System-assigned identity z rolą "Virtual Machine Contributor"
- Action Group: `ag-vm-manager-<project>-<environment>-<location>` - już skonfigurowana z integracją Logic App

Workflow w Logic App jest obecnie placeholderem i oczekuje na implementację rzeczywistej logiki zarządzania VM.

### Krok 5 - Użycie Action Group w alertach

Action Group została automatycznie utworzona i połączona z Logic App. Możesz teraz użyć jej w alertach Azure Monitor:

1. **Otwórz Azure Portal** i przejdź do **Monitor**

2. **Utwórz Alert Rule:**
   - W menu wybierz **Alerts** → **Alert rules** → **+ Create**
   - Wybierz zasób do monitorowania (np. VM)
   - Skonfiguruj warunki alertu
   - W sekcji **Actions** wybierz istniejącą Action Group: `ag-vm-manager-<postfix>`

3. **Testowanie:**
   - Po utworzeniu reguły alertu, możesz przetestować Action Group klikając **Test action group** w **Monitor** → **Alerts** → **Action groups**
   - Wybierz Sample type (np. `Metric alert`)
   - Sprawdź w Logic App **Runs history** czy workflow został uruchomiony

**Uwaga:** Jeśli chcesz dodać Action Group do istniejącego alertu, edytuj regułę alertu i dodaj Action Group z listy.

### Krok 6 - (Opcjonalnie) Dodaj dodatkowe receivery do Action Group

Możesz ręcznie rozszerzyć Action Group o dodatkowe akcje (np. email, SMS) przez portal:

1. W Azure Portal przejdź do **Monitor** → **Alerts** → **Action groups**
2. Wybierz `ag-vm-manager-<postfix>`
3. Kliknij **Edit**
4. Dodaj dodatkowe akcje w sekcji **Actions** (np. email receiver)

**Uwaga:** Action Group została utworzona przez Terraform. Zmiany ręczne mogą zostać nadpisane przy kolejnym `terraform apply`.

### Krok 7 - Czyszczenie zasobów

Po zakończeniu ćwiczenia usuń utworzone zasoby:

```bash
terraform destroy
```

## Notatki

- Logic App używa planu Consumption (brak integracji sieciowej)
- System-assigned identity posiada uprawnienia VM Contributor na poziomie subskrypcji
- Definicja workflow znajduje się w pliku `modules/logic_app/workflows/vm-manager.json`
- Workflow można zaktualizować podmieniając zawartość pliku `vm-manager.json` i wykonując `terraform apply`
