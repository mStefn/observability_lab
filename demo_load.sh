#!/bin/bash

# ==========================================================
# LAB OBSERVABILITY - STRESS TEST & SECURITY LOG GENERATOR
# ==========================================================

echo "🚀 Starting advanced stress test..."

# 1. GENERATING VARIOUS FATAL ERRORS (For Loki)
echo "--- 1/3: Generating multiple types of FATAL errors ---"

# Type A: Non-existent users (Role errors)
for i in {1..3}; do
  echo "Simulating unauthorized user: intruder_$i"
  docker exec lab-postgres psql -U intruder_$i -d lab_db > /dev/null 2>&1
  sleep 0.5
done

# Type B: Non-existent database
echo "Simulating access to wrong database: secret_vault"
docker exec lab-postgres psql -U user -d secret_vault > /dev/null 2>&1
sleep 0.5

# Type C: Authentication failures (Wrong password via network)
# We use -h localhost to force password check via TCP
echo "Simulating password brute-force attempt..."
for i in {1..3}; do
  docker exec -e PGPASSWORD="wrong_password_$i" lab-postgres psql -h localhost -U user -d lab_db -c "SELECT 1;" > /dev/null 2>&1
  sleep 0.5
done

echo "✅ FATAL logs generated. Check your 'Security' panel."

# 2. HEAVY DATABASE LOAD (For Prometheus & cAdvisor)
echo "--- 2/3: Generating heavy system load (pgbench) ---"

# Re-initializing with larger scale to make it work longer
docker exec lab-postgres pgbench -i -s 10 lab_db -U user > /dev/null 2>&1

# Running intensive test: 10 clients, 4 threads, 2000 transactions each
# This will cause a visible spike in CPU and Memory Usage
docker exec lab-postgres pgbench -c 10 -j 4 -t 2000 lab_db -U user

echo "✅ System load generated. Look for CPU/Network spikes in Grafana."

# 3. LATENCY & SLOW QUERIES (For pg_stat_statements)
echo "--- 3/3: Generating slow queries and noise ---"
for i in {1..5}; do
  # Sleep 1.5 seconds per query to show high latency
  docker exec lab-postgres psql -U user -d lab_db -c "SELECT pg_sleep(1.5); SELECT count(*) FROM pg_class a, pg_class b;" > /dev/null 2>&1
done

echo "🏁 All tests completed! System should be 'glowing' in Grafana."