FROM postgres:13

# Update the package lists for upgrades and new packages
RUN apt-get update

# Install repmgr
RUN apt-get install -y postgresql-13-repmgr

# Clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /var/lib/postgresql

# Expose the PostgreSQL port
EXPOSE 5432

# Run the rest of the commands as the ``postgres`` user created by the ``postgres-13`` package when it was ``apt-get installed``
USER postgres

# Run the PostgreSQL server in the foreground
CMD ["postgres", "-D", "/var/lib/postgresql/data"]
