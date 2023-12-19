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

Q: How can I use `docker-entrypoint.sh` to launch the Postgres database?

A: You can use the following command:
```sh
exec docker-entrypoint.sh postgres -D /var/lib/postgresql/data -c config_file=/etc/postgresql/postgresql.conf
```
> Ref: https://github.com/docker-library/mongo/issues/249#issuecomment-381786889

Q: Why does the sequence ID become discontinuous after failover?

A: Changes to sequences are logged to the Write-Ahead Log (WAL) to allow recovery from a backup or after a crash. However, to optimize performance, not every call to `nextval` is logged to the WAL. This means that after recovering from a crash, the sequence may have skipped some values, resulting in gaps in the sequence.
> Ref: https://stackoverflow.com/a/70958356

Q: What will happen if I don't specify the `wal_keep_size` in postgresql.conf?

A: It means the system will not preserve any extra WAL files for standby purposes. You may encounter a WAL file missing error during the `--force-rewind` process. It is better to specify a value based on the downtime period. `128MB` should be enough for a short period of downtime.
> Ref: https://www.postgresql.org/docs/13/release-13.html
