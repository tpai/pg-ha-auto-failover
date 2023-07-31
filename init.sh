#!/bin/bash

set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE USER repmgr;
    CREATE DATABASE repmgr OWNER repmgr;
EOSQL

echo "host replication repmgr all trust" >> "$PGDATA/pg_hba.conf"
echo "host all repmgr all trust" >> "$PGDATA/pg_hba.conf"
