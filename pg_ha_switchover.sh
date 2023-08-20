#!/bin/bash

echo "################### Switchover(db1) ###################-"

docker-compose exec db1 repmgr -f /etc/postgresql/repmgr.conf cluster show

echo ">>> create table at db1"
docker-compose exec db1 psql -c " \
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Department VARCHAR(50)
);"

echo ">>> stop db1 instance"
docker-compose stop db1

echo ">>> sleep 20s until db1 fail"
sleep 20

docker-compose exec db2 repmgr -f /etc/postgresql/repmgr.conf cluster show

echo ">>>> insert value at db2"
docker-compose exec db2 psql -c " \
INSERT INTO Employees (EmployeeID, FirstName, LastName, Department)
VALUES (1, 'John', 'Doe', 'Sales');"

echo ">>> start db1 instance and rejoin to repmgr"
docker-compose up -d -- db1

while true; do
    echo "Connecting db1:5432..."
    output=$(docker-compose exec db1 nc -vz db1 5432  2>&1)
    if [ $? -eq 0 ]; then
        echo "done"
        docker-compose exec db1 pg_ctl -w -D /var/lib/postgresql/data -o '-c config_file=/etc/postgresql/postgresql.conf' stop
        docker-compose exec -e PGPASSWORD=repmgr db1 repmgr -W -h db2 -U repmgr -d repmgr -f /etc/postgresql/repmgr.conf node rejoin --force-rewind --verbose
        docker-compose exec db1 pg_ctl -w -D /var/lib/postgresql/data -o '-c config_file=/etc/postgresql/postgresql.conf' restart
        break
    fi
    sleep 1
done

docker-compose exec db2 repmgr -f /etc/postgresql/repmgr.conf cluster show

echo ">>>> select value from db1"
docker-compose exec db1 psql -c " \
SELECT * FROM Employees;"

read -p "Press any key to switch back..."

echo "################### Switchover(db2) ###################-"

docker-compose exec db2 repmgr -f /etc/postgresql/repmgr.conf cluster show

echo ">>> stop db2 instance"
docker-compose stop db2

echo ">>> sleep 20s until db2 fail"
sleep 20

docker-compose exec db1 repmgr -f /etc/postgresql/repmgr.conf cluster show

echo ">>>> insert value at db1"
docker-compose exec db1 psql -c " \
INSERT INTO Employees (EmployeeID, FirstName, LastName, Department)
VALUES (2, 'Jane', 'Smith', 'Marketing');"

echo ">>> start db2 instance and rejoin to repmgr"
docker-compose up -d -- db2

while true; do
    echo "Connecting db2:5432..."
    output=$(docker-compose exec db2 nc -vz db2 5432  2>&1)
    if [ $? -eq 0 ]; then
        echo "done"
        docker-compose exec db2 pg_ctl -w -D /var/lib/postgresql/data -o '-c config_file=/etc/postgresql/postgresql.conf' stop
        docker-compose exec -e PGPASSWORD=repmgr db2 repmgr -W -h db1 -U repmgr -d repmgr -f /etc/postgresql/repmgr.conf node rejoin --force-rewind --verbose
        docker-compose exec db2 pg_ctl -w -D /var/lib/postgresql/data -o '-c config_file=/etc/postgresql/postgresql.conf' restart
        break
    fi
    sleep 1
done

docker-compose exec db1 repmgr -f /etc/postgresql/repmgr.conf cluster show

echo ">>>> select value from db2"
docker-compose exec db2 psql -c " \
SELECT * FROM Employees;"
