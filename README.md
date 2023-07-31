# PG HA

docker-compose exec db1 bash
$ repmgr -f /etc/postgresql/repmgr.conf primary register
$ repmgr -f /etc/postgresql/repmgr.conf cluster show

docker-compose exec db2 bash
$ PGPASSWORD=repmgr repmgr -h db1 -U repmgr -d repmgr -f /etc/postgresql/repmgr.conf standby clone
$ pg_ctl -D /var/lib/postgresql/data/ start
$ PGPASSWORD=repmgr repmgr -h db1 -U repmgr -d repmgr -f /etc/postgresql/repmgr.conf standby register

docker-compose exec db1 bash
$ repmgrd -f /etc/postgresql/repmgr.conf -d

docker-compose exec db2 bash
$ repmgrd -f /etc/postgresql/repmgr.conf -d
