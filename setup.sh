#!/bin/bash

echo "Przygotowywanie srodowiska Observability Lab..."

# Tworzenie struktury katalogow przy uzyciu sudo
echo "Tworzenie struktury katalogow..."
sudo mkdir -p ./data/grafana ./data/prometheus ./data/postgres

# Ustawianie uprawnien (Grafana ID: 472, Prometheus ID: 65534, Postgres ID: 999)
echo "Ustawianie uprawnien zapisu dla kontenerow..."
sudo chown -R 472:472 ./data/grafana
sudo chown -R 65534:65534 ./data/prometheus
sudo chown -R 999:999 ./data/postgres

# Opcjonalne: upewnienie sie, ze foldery maja odpowiednie tryby zapisu
sudo chmod -R 775 ./data/grafana ./data/prometheus ./data/postgres

echo "Gotowe!"
echo "Uruchom projekt: docker compose up -d"
