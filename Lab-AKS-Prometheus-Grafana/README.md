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

Odkomentuj `#Sekcja-namespace` w pliku `main.tf` oraz w `providers.tf`, a następnie zainicjalizuj ponownie terraform aby zaczytać nowy moduł i wdróż zmiany:

```bash
terraform init

terraform apply
```

### Krok 6 - Wdróż kube-prometheus stack

Prometheus, Grafana i AlertManager zazwyczaj chodzą jako trio (albo w większej grupie), dlatego dobrym pomysłem jest użyć helm chart, który dostarcza niezbędne komponenty i łączy je ze sobą.
Wykorzystasz [https://prometheus-community.github.io/helm-charts](https://prometheus-community.github.io/helm-charts), wdroży wszystko co trzeba.

Odkomentuj `#Sekcja-monitoring` w pliku `main.tf` oraz w `providers.tf`, a następnie zainicjalizuj ponownie terraform aby zaczytać nowy moduł i wdróż zmiany:

```bash
terraform init

terraform apply
```

> Dostałeś/aś błąd `Error: could not download chart: no cached repo found.`? Skorzystaj z podpowiedzi i wykonaj dodatkowo `helm repo update`.

### Krok 7 - podejrzyj dostępne usługi
> Możesz pominąć ten krok i przejść prosto do Kroku 8.

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

### Krok 8 - Zmień typ service na taki z publicznym dostępem

Edytuj ręcznie konfigurację service:

```bash
kubectl --namespace monitoring edit service kube-prometheus-stack-prometheus
```

Zamień typ `ClusterIp` na `LoadBalancer`.
```yaml
spec:
#
  type: LoadBalancer #Zamiast ClusterIP
```

> Uwaga, domyślny edytor to VI, poruszaj się za pomocą `j k l m`.
> Aby usunąć znaki użyj klawisza `x`.
> Aby wprowadzić tekst najpierw wciśnij `i`, a później pisz normalnie.
> Aby zapisać zmianę wciśnij `ESC` i wpisz `:wq!` (dwukropek, w, q, wykrzyknik).

Ponownie wyświetl dostępne services:

```bash
kubectl --namespace monitoring get svc
```

I zauważ, że w kolumnie "EXTERNAL-IP" znajduje się publiczny adres IP. 
```bash
> NAME                                             TYPE           CLUSTER-IP     EXTERNAL-IP     PORT(S)                         AGE
> alertmanager-operated                            ClusterIP      None           <none>          9093/TCP,9094/TCP,9094/UDP      5m20s
> kube-prometheus-stack-alertmanager               ClusterIP      10.0.169.38    <none>          9093/TCP,8080/TCP               5m27s
> kube-prometheus-stack-grafana                    ClusterIP      10.0.151.62    <none>          80/TCP                          5m27s
> kube-prometheus-stack-kube-state-metrics         ClusterIP      10.0.158.181   <none>          8080/TCP                        5m27s
> kube-prometheus-stack-operator                   ClusterIP      10.0.56.9      <none>          443/TCP                         5m27s
> kube-prometheus-stack-prometheus                 LoadBalancer   10.0.80.145    20.31.229.153   9090:32492/TCP,8080:32014/TCP   5m27s
```

Skopiuj go do przeklądarki w formie `http://20.31.229.153:9090` i zauważ, że dostałeś się do Prometheusa.

Otwórz portal Azure i w wyszukiwarce wpisz "Load Balancer". Na liście pojawi się jeden o nazwie `kubernetes`. Jest to dodatkowy obiekt w Azure (dodatkowo płatny), który pozwala na wpuszczenie ruchu publicznego do naszego klastra.
Sprawdź rozmaite opcje konfiguracyjne, m.in. `Backend pools` aby podejrzeć sposów w jaki kubernetes "dostaje" ruch.

> W ramach treningu udostępnij w ten sposób Grafanę i Alert Managera.

Rozwiązanie w tej formie jest bardzo niebezpieczne, ponieważ nie posiada włączonego TLS-a oraz nie obsługuje domen w łatwy sposób, nie wspominając już o dostępie bez poświadczeń (np. użytkownik/hasło).

W związku z tym w takich przypadkach korzysta się zazwyczaj z funkcjonalności ingress, której omówienie wykracza po za ten lab.