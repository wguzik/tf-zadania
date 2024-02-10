# Lab - AKS, Prometheus, Grafana

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

- nawiguj do katalogu z repozytorium i katalogu `Lab-AKS-Prometheus-Grafana`

  ```bash
  cd tf-zadania/Lab-AKS-Prometheus-Grafana
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
### Krok 4 - Skonfiguruj namespace

Zaloguj się do AKS używając polecenia z terraform output:

```bash
terraform output
az aks get-credentials --name <clusterName> --resource-group <resourceGroupName>
```

### Krok 5 - Stwórz namespace

Zasoby w kubernetes powinny być podzielone według funkcji lub środowiska. Podstawowym rozwiązaniem są `namespace`.

Odkomentuj `#Sekcja-namespace` w pliku `main.tf`, a następnie zainicjalizuj ponownie terraform aby zaczytać nowy moduł i wdróż zmiany:

```bash
terraform init

terraform apply
```

### Krok 6 - Wdróż kube-prometheus stack

Prometheus, Grafana i AlertManager zazwyczaj chodzą w trio (albo większej grupie), dlatego dobrym pomysłem jest użyć helm chart, który dostarcza niezbędne komponenty i łączy je ze sobą.

Odkomentuj `#Sekcja-monitoring` w pliku `main.tf`, a następnie zainicjalizuj ponownie terraform aby zaczytać nowy moduł i wdróż zmiany:

```bash
terraform init

terraform apply
```

### Krok 7 - podejrzyj dostępne usługi

Sprawdź dostępne services:

```bash
kubectl --namespace monitoring get svc
```

Zrób forward usług na lokalną maszynę użyj przeglądarki by przejrzeć podstawowe metryki [http://localhost:4000](http://localhost:4000):

```bash
kubectl --namespace monitoring port-forward svc/kube-prometheus-stack-prometheus 4000:9090
```

Zrób forward usług na lokalną maszynę użyj przeglądarki by przejrzeć wykresy [http://localhost:4001](http://localhost:4001):

```bash
kubectl --namespace monitoring port-forward svc/kube-prometheus-stack-grafana 4001:80
#creds: admin/prom-operator
```