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

Workflow w Logic App jest obecnie placeholderem i oczekuje na implementację rzeczywistej logiki zarządzania VM.

### Krok 5 - Konfiguracja Action Group z integracją Logic App

Aby skonfigurować Action Group, która będzie wywoływać Logic App:

1. **Otwórz Azure Portal** i przejdź do **Monitor**

2. **Utwórz Action Group:**
   - W menu wybierz **Alerts** → **Action groups**
   - Kliknij **+ Create**
   - Wybierz Resource Group (np. ten sam co Logic App)
   - Podaj nazwę Action Group (np. `ag-vm-manager`) lub wybierz isniejącą
   - Podaj Display name (np. `VM Manager Actions`)

3. **Dodaj akcję Logic App:**
   - W sekcji **Actions** kliknij **+ Add action**
   - Action type: wybierz **Logic App**
   - Name: podaj nazwę akcji (np. `Trigger-VM-Manager`)
   - Logic App: wybierz utworzoną Logic App (`logic-vm-manager-<postfix>`)
   - Enable common alert schema: zaznacz (rekomendowane)

4. **Zapisz Action Group:**
   - Kliknij **Review + create**
   - Kliknij **Create**

5. **Testowanie:**
   - Po utworzeniu Action Group możesz ją przetestować klikając **Test action group**
   - Wybierz Sample type (np. `Metric alert`)
   - Sprawdź w Logic App **Runs history** czy workflow został uruchomiony

**Uwaga:** Logic App musi posiadać trigger typu HTTP Request, aby mogła być wywoływana przez Action Group.

### Krok 6 - Czyszczenie zasobów

Po zakończeniu ćwiczenia usuń utworzone zasoby:

```bash
terraform destroy
```

## Notatki

- Logic App używa planu Consumption (brak integracji sieciowej)
- System-assigned identity posiada uprawnienia VM Contributor na poziomie subskrypcji
- Definicja workflow znajduje się w pliku `modules/logic_app/workflows/vm-manager.json`
- Workflow można zaktualizować podmieniając zawartość pliku `vm-manager.json` i wykonując `terraform apply`
