# Ćwiczenia PromQL w Prometheusie

***W budowie!***

## Przygotowanie środowiska testowego

Aby lepiej zrozumieć działanie Prometheusa, wdrożymy przykładową aplikację, która będzie generować obciążenie CPU:

a) stwórz za pomocą gotowego pliku:

```bash
kubectl apply -f helpers/cpu-loader.yaml
```

lub

b) wklej do wiersza poleceń:

```bash
# Utworzenie namespace
kubectl create namespace app1

# Wdrożenie poda generującego obciążenie CPU
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: cpu-loader
  namespace: app1
  labels:
    app: cpu-loader
    monitoring: "true"
spec:
  replicas: 1
  selector:
    matchLabels:
      app: cpu-loader
  template:
    metadata:
      labels:
        app: cpu-loader
      annotations:
        prometheus.io/scrape: "true"
        prometheus.io/port: "9090"
        prometheus.io/path: "/metrics"
    spec:
      containers:
      - name: cpu-loader
        image: prom/prometheus:latest  # Obraz aplikacji, który posiada eksporter metryk
        command: ["/bin/sh"]
        args: ["-c", "while true; do echo 'Lets burn some CPU...'; dd if=/dev/zero of=/dev/null bs=1M count=1000; done"]
        ports:
        - containerPort: 9090
          name: metrics
        resources:
          requests:
            cpu: "200m"
            memory: "64Mi"
          limits:
            cpu: "500m"
            memory: "128Mi"
---
apiVersion: v1
kind: Service
metadata:
  name: cpu-loader
  namespace: app1
  labels:
    app: cpu-loader
spec:
  ports:
  - port: 9090
    targetPort: metrics
    name: metrics
  selector:
    app: cpu-loader
EOF
```

Ten deployment:
- Tworzy pod w namespace `app1`
- Używa obrazu Prometheusa, który ma wbudowany eksporter metryk
- Generuje stałe obciążenie CPU poprzez operację `dd`
- Ma ustawione limity zasobów (500m CPU = 0.5 rdzenia)
- Zawiera odpowiednie adnotacje dla auto-discovery Prometheusa
- Tworzy Service dla dostępu do metryk

Możesz sprawdzić status deploymentu:
```bash
kubectl -n app1-cpu get pods
kubectl -n app1-cpu get svc
kubectl -n app1-cpu top pods  # wymaga metrics-server
```

Sprawdź, czy Prometheus wykrył twój pod:
```bash
# W interfejsie Prometheusa przejdź do:
# Status -> Targets
# Powinieneś zobaczyć endpoint cpu-loader
```

## Typy danych w Prometheus

### Serie czasowe (Time series)

Podstawowy typ danych w Prometheus. Składa się z:
- Nazwy metryki
- Zestawu etykiet (labels) w formie par klucz-wartość
- Wartości liczbowej
- Znacznika czasu (timestamp)

### Typy metryk
- **Counter** - Licznik, który może tylko rosnąć (np. liczba requestów HTTP)
  - Przykład: `http_requests_total`
  - Najczęściej używane z funkcją `rate()` lub `increase()`

- **Gauge** - Wartość, która może rosnąć i maleć (np. temperatura, zużycie pamięci)
  - Przykład: `node_memory_usage_bytes`
  - Można używać bezpośrednio lub z `avg_over_time()`

- **Histogram** - Zlicza obserwacje w przedziałach (np. czasy odpowiedzi)
  - Przykład: `http_request_duration_seconds`
  - Dostarcza dodatkowe metryki: `_bucket`, `_sum`, `_count`

## Podstawowe funkcje PromQL

### Funkcje agregujące
- `sum()` - Sumuje wartości
- `avg()` - Oblicza średnią
- `max()` - Znajduje maksymalną wartość
- `min()` - Znajduje minimalną wartość
- `count()` - Zlicza serie

### Funkcje czasowe
- `rate()` - Oblicza średnią szybkość wzrostu na sekundę
- `irate()` - Oblicza chwilową szybkość wzrostu
- `increase()` - Całkowity wzrost wartości w danym okresie
- `avg_over_time()` - Średnia w przedziale czasu

### Operatory
- `by` - Grupuje wyniki według etykiet
- `without` - Wyklucza etykiety z grupowania
- `offset` - Przesuwa zakres czasu wstecz

### Selektory
- `{label="value"}` - Filtruje według etykiet
- `=~` - Dopasowanie wyrażenia regularnego
- `!~` - Negacja wyrażenia regularnego

## Ćwiczenie 1 - Podstawowe metryki kontenerów

Sprawdź zużycie CPU przez kontenery w klastrze:

```promql
# Pokazuje użycie CPU przez każdy kontener w ostatniej minucie
rate(container_cpu_usage_seconds_total{container!=""}[1m])
```

Spróbuj odpowiedzieć na pytania:
- Które kontenery zużywają najwięcej CPU?
- Jak zmienia się zużycie w czasie?

## Ćwiczenie 2 - Metryki pamięci

Sprawdź wykorzystanie pamięci przez pody:

```promql
# Pokazuje aktualnie używaną pamięć przez każdy pod (w bytes)
sum(container_memory_working_set_bytes{container!=""}) by (pod)

# To samo w bardziej czytelnej formie (w MB)
sum(container_memory_working_set_bytes{container!=""}) by (pod) / 1024 / 1024
```

Spróbuj odpowiedzieć na pytania:
- Które pody używają najwięcej pamięci?
- Czy któryś pod zbliża się do limitu pamięci?

## Wskazówki
- Użyj przycisku "Execute" aby wykonać zapytanie
- Wypróbuj różne zakresy czasowe
- Eksperymentuj z różnymi etykietami w klamrach
- Używaj funkcji `rate()` dla liczników i `avg_over_time()` dla gauge'ów
