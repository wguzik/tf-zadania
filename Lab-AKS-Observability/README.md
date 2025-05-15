# Lab - AKS, Prometheus, Grafana

***W budowe!***

## Wymagania
Aktywna subskrypcja w Azure i dostęp do portalu.

## Wstęp

### Cel
Podział projektu na moduły.

Czas trwania: 90 minut

### Krok 0 - Uruchom Cloud Shell w Azure i sklonuj kod ćwiczeń

Nawiguj w przeglądarce do [portal.azure.com](https://portal.azure.com), uruchom "Cloud Shell" i wybierz `Bash`.

Oficjalna dokumentacja: [Cloud Shell Quickstart](https://github.com/MicrosoftDocs/azure-docs/blob/main/articles/cloud-shell/quickstart.md).

```bash
git clone https://github.com/wguzik/tf-zadania.git
```

> Poniższe kroki realizuje się za pomocą Cloud Shell.

Podstawowym narzędziem do edycji kodu jest wbudowany w `VS Code` w Cloud Shell, który można uruchomić za pomocą polecenia `code`.

### Krok 1 - Nawiguj do katalogu z projektem

- nawiguj do katalogu z repozytorium i katalogu `Lab-AKS-Observability`

```bash
cd tf-zadania/Lab-AKS-Observability
```

### Krok 2 - Ukryj zmienne w pliku

- w katalogu z plikami `*.tf` stwórz plik przez skopiowanie `terraform.tfvars.example` i zmianę nazwy na `terraform.tfvars`,

```bash
cp terraform.tfvars.example terraform.tfvars
```

- podaj subskrypcję

```bash
subscription_id=$(az account show --query="id")
sed -i "s/YourSubscriptionID/$subscription_id/g" terraform.tfvars
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
### Krok 4 - Skonfiguruj namespace

"Zaloguj" się do AKS używając polecenia z terraform output:

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
Wykorzystasz [https://prometheus-community.github.io/helm-charts](https://prometheus-community.github.io/helm-charts), który wdroży wszystko co trzeba.

Odkomentuj `#Sekcja-metryki` w pliku `main.tf` oraz w `providers.tf`, a następnie zainicjalizuj ponownie terraform aby zaczytać nowy moduł i wdróż zmiany:

```bash
terraform init

terraform apply
```

> Dostałeś/aś błąd `Error: could not download chart: no cached repo found.`? Skorzystaj z podpowiedzi i wykonaj dodatkowo `helm repo update`.

### Krok 7 - podejrzyj dostępne usługi

> Krok nie jest wymagany, do jego wykonania potrzebne jest `kubectl` lokalne.

Sprawdź dostępne services:

```bash
kubectl --namespace metrics get svc
```

Zrób forward usług na lokalną maszynę użyj przeglądarki by przejrzeć podstawowe metryki [http://localhost:4000](http://localhost:4000):

```bash
kubectl --namespace metrics port-forward svc/kube-prometheus-stack-prometheus 4000:9090
```

Zrób forward usług na lokalną maszynę użyj przeglądarki by przejrzeć wykresy [http://localhost:4001](http://localhost:4001):

```bash
kubectl --namespace metrics port-forward svc/kube-prometheus-stack-grafana 4001:80
#creds: admin/prom-operator
```

### Krok 8 - Zmień typ service na taki z publicznym dostępem

> Krok nie jest wymagany, pod warunkiem, że masz zainstalowane `kubectl` lokalnie.
> Można go pominąć i przejść do Kroku 9.

Edytuj ręcznie konfigurację service:

```bash
kubectl --namespace metrics edit service kube-prometheus-stack-prometheus
```

Zamień typ `ClusterIp` na `LoadBalancer`:

```yaml
spec:
#
  type: LoadBalancer #Zamiast ClusterIP
```

> Uwaga, domyślny edytor to vi, poruszaj się za pomocą `j k l m`.
> Aby usunąć znaki użyj klawisza `x`.
> Aby wprowadzić tekst najpierw wciśnij `i`, a później pisz normalnie.
> Aby zapisać zmianę wciśnij `ESC` i wpisz `:wq!` (dwukropek, w, q, wykrzyknik).

Ponownie wyświetl dostępne services:

```bash
kubectl --namespace metrics get svc
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

W związku z tym w takich przypadkach korzysta się zazwyczaj z funkcjonalności ingress, której omówienie wykracza poza to ćwiczenie.

### Krok 9 - Dodawanie alertów do Prometheusa

Aby przetestować alert na zużycie CPU, możesz uruchomić pod który będzie generował obciążenie:

[README-prometheus.md](README-prometheus.md)

Odkomentuj zawartość pliku `modules/kube-prometheus/service_monitor.tf`.

Odkomentuj `#Sekcja-alerty` w pliku `main.tf`:

```bash
terraform init
terraform apply
```

Po wdrożeniu, zostały utworzone następujące alerty:
- `ContainerHighCPUUsage` - alert gdy kontener zużywa ponad 80% CPU przez 5 minut
- `NodeHighCPUUsage` - alert gdy node zużywa ponad 80% CPU przez 5 minut
- `HighMemoryUsage` - alert gdy zużycie pamięci na node przekracza 80% przez 5 minut

Możesz sprawdzić skonfigurowane reguły alertów:

```bash
kubectl get prometheusrules -n metrics
kubectl describe prometheusrule custom-alerts -n metrics
```

Aby zobaczyć aktywne alerty, przejdź do interfejsu AlertManagera:

```bash
kubectl port-forward -n metrics svc/kube-prometheus-stack-alertmanager 4002:9093
```

Otwórz w przeglądarce [http://localhost:4002](http://localhost:4002) i przejdź do zakładki "Alerts".

Możesz również zobaczyć status alertów w Prometheusie:

```bash
kubectl port-forward -n metrics svc/kube-prometheus-stack-prometheus 4000:9090
```

Otwórz w przeglądarce [http://localhost:4000](http://localhost:4000) i przejdź do zakładki "Alerts".

Po kilku minutach powinieneś zobaczyć alert w AlertManagerze.

Krok, który nie został wykonany to wysłanie alertu na email/Slack/Teams. To wymaga dodatkowej integracji.

### Krok 10 - Składowanie logów z ElasticSearch

Jest wiele sposobów na zbieranie logów z kubernetes. Wykorzystasz Fluentd, Fluentbit do zbierania logów oraz oraz lokalną instancję Elasticsearch do ich przechowywania.


Odkomentuj `#Sekcja-logging-elasticsearch` w pliku `main.tf` oraz zaktualizuj repozytoria helm:

```bash
helm repo add elastic https://helm.elastic.co
helm repo update
terraform init
terraform apply
```

Aby uzyskać dostęp do Kibany, wykonaj port-forward:

```bash
kubectl port-forward -n logging svc/kibana-kibana 5601:5601

#http://localhost:5601
```

Wybierz "Try sample data" - > "Sample web logs".

### Krok 11 - Logi z Fluentd i Fluentd 

> ! NIE DZIAŁA !

Odkomentuj `#Sekcja-logging` w pliku `main.tf` oraz zaktualizuj repozytoria helm:

```bash
helm repo add fluent https://fluent.github.io/helm-charts
helm repo update
terraform init
terraform apply
```

Sprawdź status operatora i podów Fluentd:

```bash
kubectl get pods -n logging -l app.kubernetes.io/name=fluentd-operator
kubectl get fluentdconfig -n logging
kubectl get pods -n logging -l app=fluentd
```

Po poprawnej instalacji, operator FluentD automatycznie skonfiguruje zbieranie logów ze wszystkich podów w klastrze i będzie je przesyłał do Elasticsearch. 

Aby sprawdzić konfigurację Fluentd:

```bash
kubectl get fluentdconfig cluster-logging -n logging -o yaml
```

Po instalacji, index pattern `fluentd-*` zostanie automatycznie utworzony w Kibanie. Aby wyświetlić logi:

1. Zaloguj się do Kibany
2. Stwórz index pattern'`fluentd-*`
   
```bash
# Uzyskaj dostęp do Kibany przez port-forward
kubectl port-forward -n logging svc/kibana-kibana 5601:5601

# Otwórz w przeglądarce http://localhost:5601
# Przejdź do Stack Management -> Index Patterns -> Create index pattern
# Wprowadź "fluentd-*" jako pattern
# Wybierz "@timestamp" jako pole czasowe
``` 

2. Przejdź do menu "Discover"
3. Wybierz odpowiedni zakres czasowy w prawym górnym rogu
4. Możesz teraz przeglądać i filtrować logi z klastra

### Krok 12

Pamiętaj aby usunąć zasoby!

```bash
terraform destroy
```
