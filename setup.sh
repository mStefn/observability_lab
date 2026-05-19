#!/bin/bash

echo "Przygotowywanie srodowiska Observability Lab..."

# Tworzenie struktury katalogow przy uzyciu sudo
echo "Tworzenie struktury katalogow (Grafana, Prometheus, Loki)..."
sudo mkdir -p ./data/grafana ./data/prometheus ./data/loki

# Ustawianie uprawnien
echo "Ustawianie uprawnien zapisu dla kontenerow..."
# Grafana ID: 472
sudo chown -R 472:472 ./data/grafana
# Prometheus ID: 65534 (nobody)
sudo chown -R 65534:65534 ./data/prometheus
# Loki ID: 10001
sudo chown -R 10001:10001 ./data/loki

# Opcjonalne: upewnienie sie, ze foldery maja odpowiednie tryby zapisu
sudo chmod -R 775 ./data/grafana ./data/prometheus ./data/loki

echo "Gotowe!"
echo "Ważne: upewnij się, że masz też nadane uprawnienia do socketu:"
echo "sudo chmod 666 /var/run/docker.sock"
echo ""
echo "Uruchom projekt: docker compose up -d"
