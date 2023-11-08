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

### Krok 4 - Skonfiguruj prometheus za pomocą helm chart

Zaloguj się do AKS używając polecenia z terraform output:

```bash
az aks get-credentials --name <clusterName> --resource-group <resourceGroupName>
```

Dodaje namespace dla monitoringu:

```bash
kubectl create namespace monitoring
```

Dodaj helm repo:
```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
```

Zainstaluj prometheus i grafane:

```bash
helm install prometheus \
  prometheus-community/kube-prometheus-stack \
  --namespace monitoring
```

Zrób forward usług na lokalną maszynę użyj przeglądarki by przejrzeć wykresy (localhost:4000):
```bash
kubectl port-forward svc/prometheus-grafana --namespace monitoring 4000:80
//creds: admin/prom-operator
```

```bash
kubectl port-forward svc/prometheus-kube-prometheus-prometheus --namespace monitoring 4001:9090
```

