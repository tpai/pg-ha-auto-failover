#!/bin/bash

set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE USER repmgr WITH PASSWORD 'repmgr' SUPERUSER;
    CREATE DATABASE repmgr OWNER repmgr;
EOSQL

echo "local   replication   repmgr                              trust" >> "$PGDATA/pg_hba.conf"
echo "host    replication   repmgr      127.0.0.1/32            trust" >> "$PGDATA/pg_hba.conf"
echo "host    replication   repmgr      192.168.0.0/16          trust" >> "$PGDATA/pg_hba.conf"
echo "local   repmgr        repmgr                              trust" >> "$PGDATA/pg_hba.conf"
echo "host    repmgr        repmgr      127.0.0.1/32            trust" >> "$PGDATA/pg_hba.conf"
echo "host    repmgr        repmgr      192.168.0.0/16          trust" >> "$PGDATA/pg_hba.conf"
