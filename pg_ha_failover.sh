#!/bin/bash

docker-compose exec db1 repmgr -f /etc/postgresql/repmgr.conf cluster show
docker-compose stop db1

echo "Sleep 20s until db1 fail"
sleep 20

docker-compose exec db2 repmgr -f /etc/postgresql/repmgr.conf cluster show
docker-compose up db1 -d

echo "Sleep 3s until failover"
sleep 3

docker-compose exec db2 repmgr -f /etc/postgresql/repmgr.conf cluster show