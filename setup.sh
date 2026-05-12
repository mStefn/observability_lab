#!/bin/bash

echo "Przygotowywanie srodowiska Observability Lab..."


echo "Tworzenie struktury katalogow..."
sudo mkdir -p ./data/grafana ./data/prometheus ./data/postgres ./data/loki


echo "Ustawianie uprawnien zapisu dla kontenerow..."
sudo chown -R 472:472 ./data/grafana
sudo chown -R 65534:65534 ./data/prometheus
sudo chown -R 999:999 ./data/postgres
sudo chown -R 10001:10001 ./data/loki  


sudo chmod -R 775 ./data/grafana ./data/prometheus ./data/postgres ./data/loki

echo "Gotowe! Teraz Loki powinien wstac bez problemu."