#!/bin/bash

echo "🚀 Running load tests for the lab..."

# 1. LOG GENERATION (Failed logins)
echo "--- 1/3: Generating log errors (Loki) ---"
for i in {1..5}; do
  # Simulating failed login attempts to trigger 'FATAL' logs in Postgres
  docker exec lab-postgres PGPASSWORD=wrong_password psql -U user -d lab_db -c "SELECT 1;" > /dev/null 2>&1
  sleep 1
done
echo "✅ Generated 5 failed login attempts (look for 'FATAL' in logs)."

# 2. DB LOAD GENERATION (pgbench)
echo "--- 2/3: Generating transactions (Postgres Exporter) ---"
# Initializing pgbench schema and then running a high-concurrency stress test
docker exec lab-postgres pgbench -i -s 1 lab_db -U user > /dev/null 2>&1
docker exec lab-postgres pgbench -c 10 -j 2 -t 1000 lab_db -U user
echo "✅ Database performance test finished (check for TPS spikes)."

# 3. GENERATING SLOW QUERIES
echo "--- 3/3: Generating slow queries ---"
# Executing an intentional sleep and a heavy cross-join to simulate a slow query
docker exec lab-postgres psql -U user -d lab_db -c "SELECT pg_sleep(5); SELECT count(*) FROM pg_catalog.pg_class a, pg_catalog.pg_class b, pg_catalog.pg_class c;" > /dev/null 2>&1
echo "✅ Slow queries sent (check the DB Dashboard for latency)."

echo "🏁 Test finished. Check Grafana!"
