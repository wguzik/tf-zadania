# Ćwiczenia z Elasticsearch i Kibana

## Przygotowanie środowiska testowego

Aby lepiej zrozumieć działanie Elasticsearch i Kibany, wdrożymy przykładową aplikację, która będzie generować logi:

```bash
# Utworzenie namespace
kubectl create namespace app1

# Wdrożenie poda generującego logi
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: log-generator
  namespace: app1
  labels:
    app: log-generator
spec:
  replicas: 1
  selector:
    matchLabels:
      app: log-generator
  template:
    metadata:
      labels:
        app: log-generator
    spec:
      containers:
      - name: log-generator
        image: busybox
        command: ["/bin/sh"]
        args: ["-c", "while true; do echo \"$(date) - INFO - User $(shuf -i 1000-9999 -n 1) logged in from $(shuf -i 1-255 -n 1).$(shuf -i 1-255 -n 1).$(shuf -i 1-255 -n 1).$(shuf -i 1-255 -n 1)\"; sleep 1; done"]
EOF
```

Ten deployment:
- Tworzy pod w namespace `app1`
- Generuje przykładowe logi logowania użytkowników
- Każdy log zawiera timestamp, poziom logowania, ID użytkownika i IP

## Podstawowe pojęcia Elasticsearch

### Indeks (Index)
- Kontener przechowujący dokumenty o podobnej charakterystyce
- Analogiczny do tabeli w bazie danych
- Przykład: `logs-2024.03.20`

### Dokument (Document)
- Podstawowa jednostka informacji w Elasticsearch
- Zapisany w formacie JSON
- Zawiera pola (fields) i wartości
- Przykład:
```json
{
    "@timestamp": "2024-03-20T10:15:30Z",
    "level": "INFO",
    "message": "User 1234 logged in",
    "user_id": 1234,
    "ip": "192.168.1.1"
}
```

### Mapping
- Schema dokumentów w indeksie
- Definiuje typy pól (text, keyword, date, numeric, etc.)
- Przykład:
```json
{
    "properties": {
        "@timestamp": { "type": "date" },
        "level": { "type": "keyword" },
        "message": { "type": "text" },
        "user_id": { "type": "integer" },
        "ip": { "type": "ip" }
    }
}
```

## Podstawowe zapytania Elasticsearch (Kibana Query Language - KQL)

### Operatory logiczne
- `AND` - wszystkie warunki muszą być spełnione
- `OR` - przynajmniej jeden warunek musi być spełniony
- `NOT` - negacja warunku

### Przykłady podstawowych zapytań

```kql
# Wyszukiwanie po dokładnej wartości pola
level: "ERROR"

# Łączenie warunków
level: "ERROR" AND user_id: 1234

# Wyszukiwanie w zakresie dat
@timestamp >= "2024-03-20T00:00:00" AND @timestamp < "2024-03-21T00:00:00"

# Wyszukiwanie po fragmencie tekstu
message: *login*

# Wyszukiwanie po wielu wartościach
level: ("ERROR" OR "WARN")

# Wyszukiwanie po zakresie numerycznym
user_id >= 1000 and user_id < 2000
```

## Ćwiczenie 1 - Analiza logów błędów

Znajdź wszystkie błędy z ostatniej godziny:

```kql
# Podstawowe wyszukiwanie błędów
level: "ERROR"

# Błędy z konkretnego poda
level: "ERROR" AND kubernetes.pod.name: "log-generator-*"

# Błędy pogrupowane według typu
level: "ERROR" AND message: *
```

## Ćwiczenie 2 - Analiza aktywności użytkowników

Zbadaj aktywność logowania użytkowników:

```kql
# Wszystkie logowania
message: *"logged in"*

# Logowania z konkretnego zakresu IP
message: *"logged in"* AND ip: "192.168.*"

# Logowania konkretnego użytkownika
user_id: 1234
```

## Ćwiczenie 3 - Wizualizacje w Kibanie

1. Utwórz wykres liczby logowań w czasie:
   - Visualization type: Line
   - Y-axis: Count of logs
   - X-axis: @timestamp
   - Filter: message: *"logged in"*

2. Utwórz wykres kołowy poziomów logowania:
   - Visualization type: Pie
   - Slice by: level
   - Size by: Count

## Wskazówki
- Używaj zakładki "Discover" do eksploracji logów
- Korzystaj z filtrów czasowych do zawężania wyników
- Zapisuj często używane zapytania jako "Saved Queries"
- Twórz dashboardy łączące różne wizualizacje
- Używaj agregacji do analizy trendów

## Przydatne funkcje agregacji

### Metryki
- `count()` - liczba dokumentów
- `cardinality()` - liczba unikalnych wartości
- `avg()` - średnia wartość
- `max()` / `min()` - wartość maksymalna/minimalna

### Bucketing
- `date_histogram` - grupowanie po czasie
- `terms` - grupowanie po wartościach pola
- `range` - grupowanie po zakresach wartości 