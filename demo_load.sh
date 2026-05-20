#!/bin/bash

# ==========================================================
# LAB OBSERVABILITY - THE ULTIMATE DEMO GENERATOR
# ==========================================================

# --- CONFIGURATION & COLORS ---
CONTAINER="lab-postgres"
DB_USER="user"
DB_NAME="lab_db"

C_RED='\033[1;31m'
C_GREEN='\033[1;32m'
C_YELLOW='\033[1;33m'
C_BLUE='\033[1;36m'
C_PURPLE='\033[1;35m'
C_NC='\033[0m' # No Color

# --- HELPER FUNCTIONS ---
print_header() {
  echo -e "\n${C_BLUE}================================================================${C_NC}"
  echo -e "${C_BLUE} 🚀 $1 ${C_NC}"
  echo -e "${C_BLUE}================================================================${C_NC}\n"
}

pause_for_audience() {
  echo -e "${C_YELLOW}👉 Przygotuj Grafanę! Naciśnij [ENTER], aby odpalić ten test...${C_NC}"
  read -r
}

# --- PRE-FLIGHT CHECK ---
clear
print_header "OBSERVABILITY LAB - LIVE DEMO INITIALIZATION"

echo -e "[ SYSTEM ] Checking if $CONTAINER is running..."
if ! docker ps | grep -q $CONTAINER; then
  echo -e "${C_RED}[ ERROR ] Container '$CONTAINER' is NOT running! Start your environment first.${C_NC}"
  exit 1
fi
echo -e "${C_GREEN}[ OK ] Target locked and running.${C_NC}\n"

# ==========================================================
# PHASE 1: SECURITY & AUTHENTICATION (Loki Dashboard)
# ==========================================================
print_header "PHASE 1: CYBER ATTACK SIMULATION (Security Logs)"
echo -e "Ta faza wygeneruje logi FATAL (błędne hasła, nieznani użytkownicy)."
pause_for_audience

echo -e "${C_RED}[ ATTACK ]${C_NC} Simulating unauthorized roles..."
for i in {1..3}; do
  docker exec $CONTAINER psql -U intruder_bot_$i -d $DB_NAME > /dev/null 2>&1
  echo -n "."
  sleep 0.3
done
echo ""

echo -e "${C_RED}[ ATTACK ]${C_NC} Probing for hidden databases (secret_vault)..."
docker exec $CONTAINER psql -U $DB_USER -d secret_vault > /dev/null 2>&1
sleep 0.5

echo -e "${C_RED}[ ATTACK ]${C_NC} Initiating TCP Brute-Force on user '$DB_USER'..."
for i in {1..5}; do
  docker exec -e PGPASSWORD="hacked_$i" $CONTAINER psql -h localhost -U $DB_USER -d $DB_NAME -c "SELECT 1;" > /dev/null 2>&1
  echo -n "!"
  sleep 0.2
done
echo -e "\n${C_GREEN}[ SUCCESS ] Security breaches generated. Check Loki/Security panels.${C_NC}"


# ==========================================================
# PHASE 2: INFRASTRUCTURE STRESS (Prometheus & cAdvisor)
# ==========================================================
print_header "PHASE 2: HEAVY INFRASTRUCTURE LOAD (CPU & RAM Spike)"
echo -e "Ta faza maksymalnie obciąży procesor, pamięć i I/O dysku."
pause_for_audience

echo -e "${C_PURPLE}[ INIT ]${C_NC} Preparing pgbench scale 10 (Creating test tables)..."
docker exec $CONTAINER pgbench -i -s 10 $DB_NAME -U $DB_USER > /dev/null 2>&1

echo -e "${C_PURPLE}[ LOAD ]${C_NC} Launching 15 concurrent clients / 5000 transactions each..."
echo -e "${C_PURPLE}[ LOAD ]${C_NC} (This will take about 10-20 seconds. Watch the CPU graph climb!)"
# We let some summary output show up to make terminal look busy
docker exec $CONTAINER pgbench -c 15 -j 4 -t 5000 $DB_NAME -U $DB_USER | grep -E "tps =|latency average"

echo -e "${C_GREEN}[ SUCCESS ] Massive load test completed. Check Prometheus CPU panels.${C_NC}"


# ==========================================================
# PHASE 3: APPLICATION PERFORMANCE (pg_stat_statements)
# ==========================================================
print_header "PHASE 3: BAD CODE / SLOW QUERIES SIMULATION"
echo -e "Ta faza symuluje beznadziejnie napisany kod (Cross Joins & Sleep)."
pause_for_audience

echo -e "${C_YELLOW}[ SLOW ]${C_NC} Executing inefficient queries with random latencies..."
for i in {1..6}; do
  # Random delay between 0.5s and 2.5s for realistic scatter plot
  DELAY=$(awk -v min=0.5 -v max=2.5 'BEGIN{srand(); print min+rand()*(max-min)}')
  echo -e "         -> Triggering query with ${DELAY}s latency..."
  
  docker exec $CONTAINER psql -U $DB_USER -d $DB_NAME -c "SELECT pg_sleep($DELAY); SELECT count(*) FROM pg_class a, pg_class b;" > /dev/null 2>&1
done

echo -e "\n${C_GREEN}[ SUCCESS ] Slow queries injected. Check App Performance dashboard.${C_NC}"

# ==========================================================
# END OF DEMO
# ==========================================================
print_header "DEMO COMPLETED SUCCESSFULLY! 🎉"
echo -e "Odśwież Grafanę (ostatnie 5 minut), aby zobaczyć pełny obraz zniszczeń."