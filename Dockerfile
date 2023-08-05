FROM postgres:13

WORKDIR /var/lib/postgresql

RUN apt-get update && apt-get install -y postgresql-13-repmgr net-tools procps netcat-openbsd

RUN apt-get clean && rm -rf /var/lib/apt/lists/*

EXPOSE 5432

USER postgres
