#!/bin/bash

docker-compose up -d -- db1
docker-compose up -d -- db2

while true; do
    echo "Connecting db1:5432..."
    output=$(docker-compose exec db2 nc -vz db1 5432  2>&1)
    if [ $? -eq 0 ]; then
        echo "done"
        docker-compose exec db1 repmgr -f /etc/postgresql/repmgr.conf primary register
        docker-compose exec db1 repmgr -f /etc/postgresql/repmgr.conf cluster show
        docker-compose exec -e PGPASSWORD=repmgr db2 repmgr -h db1 -U repmgr -d repmgr -f /etc/postgresql/repmgr.conf standby clone
        docker-compose exec db2 pg_ctl -D /var/lib/postgresql/data -o '-c config_file=/etc/postgresql/postgresql.conf' start
        docker-compose exec -e PGPASSWORD=repmgr db2 repmgr -h db1 -U repmgr -d repmgr -f /etc/postgresql/repmgr.conf standby register
        docker-compose exec -e PGPASSWORD=repmgr db2 repmgr -h db1 -U repmgr -d repmgr -f /etc/postgresql/repmgr.conf cluster show
        break
    fi
    sleep 1
done

docker-compose exec -d db1 repmgrd -f /etc/postgresql/repmgr.conf --daemonize=false
docker-compose exec -d db2 repmgrd -f /etc/postgresql/repmgr.conf --daemonize=false

docker-compose up -d -- pgpool
