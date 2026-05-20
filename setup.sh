#!/bin/bash

# Zatrzymanie skryptu w przypadku jakiegokolwiek błędu
set -e

echo "🚀 Przygotowywanie środowiska Observability Lab (Wersja Multiplatformowa)..."

# Sprawdzenie czy Docker jest uruchomiony
if ! docker info > /dev/null 2>&1; then
    echo "❌ Błąd: Docker nie jest uruchomiony! Uruchom Docker Desktop (Windows) lub usługę docker (Linux)."
    exit 1
fi

echo "🧹 Czyszczenie starych kontenerów (jeśli istnieją)..."
docker compose down --volumes --remove-orphans > /dev/null 2>&1 || true

echo "✅ Środowisko jest gotowe do uruchomienia!"
echo "------------------------------------------------"
echo "Uruchom teraz laboratorium wpisując w terminalu:"
echo "docker compose up -d"
echo "------------------------------------------------"