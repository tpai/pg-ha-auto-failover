# Postgres High Availability (HA) Auto Failover

This project sets up a Postgres High Availability (HA) cluster with automatic failover using Docker and repmgr.

## Prerequisites

- Docker
- Docker Compose

## Usage

1. Initialize the Postgres HA cluster:

```bash
./pg_ha_init.sh
```

2. Test the failover:

```bash
./pg_ha_failover.sh
```

3. Cleanup the resources:

```bash
docker-compose down --remove-orphans -v
```

## FAQ

Q: How can I use a shell script to launch the Postgres database?

A: You can use the following command in your shell script to launch the Postgres database:
```sh
exec docker-entrypoint.sh postgres -D /var/lib/postgresql/data -c config_file=/etc/postgresql/postgresql.conf
```
> Ref: https://github.com/docker-library/mongo/issues/249#issuecomment-381786889

Q: Why does the sequence ID become discontinuous after failover?

A: Changes to sequences are logged to the Write-Ahead Log (WAL) to allow recovery from a backup or after a crash. However, to optimize performance, not every call to `nextval` is logged to the WAL. This means that after recovering from a crash, the sequence may have skipped some values, resulting in gaps in the sequence.
> Ref: https://stackoverflow.com/a/70958356
