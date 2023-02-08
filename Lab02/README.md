# Lab02 - Organizacja plików i stan

## Wymagania
Aktywna subskrypcja w Azure i dostęp do portalu.

## Wstęp
### Cel
Organizacja plików w terraform oraz pliki stanu.

Czas trwania: 30 minut

### Organizacja plików
Terraform pozwala na dzielenie konfiguracji na kilka różnych plików. 

Kod może być podzielony również na moduły, tak aby odseparować obiekty od siebie, ten temat będzie poruszony w innym miejscu.

W trakcie uruchomienia Terraform łączy podzielone pliki w jeden.

Przykładowa organizacja projektu o płaskiej strukturze:

```
resource/
├─ main.tf
├─ variables.tf
├─ outputs.tf
├─ providers.tf

```

### Plik stanu
Terraform w *uproszczeniu* korzysta z trzech źródeł do określenia tego:
- co potrzebuje stworzyć - pliki *.tf. Pliki tworzysz Ty, wybierasz zasoby, które chcesz stworzyć, jak je nazwać i jakie mają mieć parametry.
- co jest - API chmury (innego obiektu, który chcemy skonfigurować) - dzięki providerowi Terraform wie jak rozmawiać z danym dostawcą i może się dowiedzieć, czy dane zasoby istnieją, czy możne je skonfigurować w wybrany sposób
- co uważa, że powinno być - plik stanu - w trakcie tworzenia zasobów Terraform tworzy plik stanu **.tfstate*, jest to jeden z kluczowych elementów sukcesu terraforma. Dzięki plikowi stanu wiemy czym terraform zarządza i m.in. jakie zmiany wydarzyły się od ostatniego uruchomienia (zarówno w kodzie jak i w chmurze). Tymczasowo plik stanu będzie przechowywany u Ciebie, ale docelowo będziesz go hostować gdzie indziej.


### Krok 0 - Uruchom Cloud Shell w Azure i sklonuj kod ćwiczeń
Nawiguj w przeglądarce do [portal.azure.com](https://portal.azure.com), uruchom "Cloud Shell" i wybierz `Bash`.

Oficjalna dokumentacja: [Cloud Shell Quickstart](https://github.com/MicrosoftDocs/azure-docs/blob/main/articles/cloud-shell/quickstart.md).

```bash
git clone https://github.com/wguzik/tf-zadania.git
```

> Poniższe kroki realizuje się za pomocą Cloud Shell

### Krok 1 - utwórz właścwie pliki i zreorganizuj obiekty
- nawiguj do katalogu z repozytorium i katalogu Lab02
```bash
cd tf-zadania/Lab02
```

- utwórz pliki i przenieś odpowiednie bloki to odpowiednich plików
```bash
touch providers.tf
touch versions.tf
touch outputs.tf
```

### Krok 2 - Zweryfikuj poprawność kodu

```bash
terraform fmt
terraform validate
terraform plan
```

### Krok 3 - Ukryj zmienne w pliku

W katalogu z plikami *.tf stwórz plik `terraform.tfvars` i umieść w nim `owner= "<TwojeInicjaly>"`.

Terraform automatycznie zaczyta jego zawartość.


### Krok 4 - Stwórz zasoby

```bash
terraform apply
```

### Krok 5 - Podejrzyj hasło w KeyVault w portalu

### Krok 6 - Podejrzyj plik stanu

```bash
ls -a
cat terraform.tfstate
```

Przejrzyj uważnie plik i poszukaj frazy `result`, porównaj wartość z tą, którą odczytałeś/aś z KeyVault.

Plik stanu w Terraformie przechowuje wiele informacji, w tym hasła w postaci zwykłego tekstu. Plik stanu jest kluczowy nie tylko ze względu na terraform jako taki, ale również przez fakt, że są w nim Twoje hasła.

### Krok 8 - Usuń zasoby

```
terraform destroy
```

## Zadanie domowe
Stwórz Storage Account ręcznie, a następnie zaimportuj go do stanu.
> Podpowiedź: warto wcześniej napisać w terraformie. `terraform plan` Twoim przyjacielem.