#!/bin/bash

PGPASSWORD=repmgr repmgr -h db1 -U repmgr -d repmgr -f /etc/postgresql/repmgr.conf standby clone
pg_ctl -D /var/lib/postgresql/data -o '-c config_file=/etc/postgresql/postgresql.conf' start
PGPASSWORD=repmgr repmgr -h db1 -U repmgr -d repmgr -f /etc/postgresql/repmgr.conf standby register
PGPASSWORD=repmgr repmgr -h db1 -U repmgr -d repmgr -f /etc/postgresql/repmgr.conf cluster show