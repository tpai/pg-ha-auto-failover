#!/bin/bash

docker-compose up db1 -d
docker-compose up db2 -d

while true; do
    echo "Connecting db1:5432..."
    output=$(docker-compose exec db2 nc -vz db1 5432  2>&1)
    if [ $? -eq 0 ]; then
        echo "done"
        docker-compose exec db1 ./repmgr_init.sh
        docker-compose exec db2 ./repmgr_init.sh
        break
    fi
    sleep 1
done

docker-compose exec -d db1 repmgrd -f /etc/postgresql/repmgr.conf --daemonize=false
docker-compose exec -d db2 repmgrd -f /etc/postgresql/repmgr.conf --daemonize=false