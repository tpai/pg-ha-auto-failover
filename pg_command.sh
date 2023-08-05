#!/bin/bash

set -e

if [ ! -f "$PGDATA/pg_hba.conf" ]; then
  if [ "$1" = "master" ]; then
    exec docker-entrypoint.sh postgres -D /var/lib/postgresql/data -c config_file=/etc/postgresql/postgresql.conf
  fi
  if [ "$1" = "slave" ]; then
    tail -f /dev/null
  fi
else
  if [ "$1" = "master" ]; then
    PGPASSWORD=repmgr repmgr -h db2 -U repmgr -d repmgr -f /etc/postgresql/repmgr.conf node rejoin
    pg_ctl -w -D /var/lib/postgresql/data -o '-c config_file=/etc/postgresql/postgresql.conf' restart
    repmgrd -f /etc/postgresql/repmgr.conf --daemonize=false --no-pid-file
  fi
  if [ "$1" = "slave" ]; then
    pg_ctl -w -D /var/lib/postgresql/data -o '-c config_file=/etc/postgresql/postgresql.conf' restart
    repmgrd -f /etc/postgresql/repmgr.conf --daemonize=false --no-pid-file
  fi
fi