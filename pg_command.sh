#!/bin/bash

set -e

if [ ! -f "$PGDATA/pg_hba.conf" ]; then
  if [ "$1" = "primary" ]; then
    exec docker-entrypoint.sh postgres -D /var/lib/postgresql/data -c config_file=/etc/postgresql/postgresql.conf
  fi
  if [ "$1" = "secondary" ]; then
    tail -f /dev/null
  fi
else
  pg_ctl -w -D /var/lib/postgresql/data -o '-c config_file=/etc/postgresql/postgresql.conf' restart
  repmgrd -f /etc/postgresql/repmgr.conf --daemonize=false --no-pid-file
fi
