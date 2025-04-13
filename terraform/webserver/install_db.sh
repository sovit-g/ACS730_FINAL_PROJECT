#!/bin/bash

# Define file paths
PG_HBA_CONF="/var/lib/pgsql/data/pg_hba.conf"
POSTGRESQL_CONF="/var/lib/pgsql/data/postgresql.conf"

# Update the system
sudo yum update -y

# Install PostgreSQL 15
sudo amazon-linux-extras enable postgresql15
sudo yum install -y postgresql15-server postgresql15

# Initialize PostgreSQL
sudo /usr/pgsql-15/bin/postgresql-15-setup initdb

# Start and enable PostgreSQL service
sudo systemctl start postgresql-15
sudo systemctl enable postgresql-15

# Set password for postgres user
sudo -u postgres psql -c "ALTER USER postgres PASSWORD 'postgres';"

# Configure PostgreSQL to accept connections from 10.1.0.0/16 subnet (your VPC range)
sudo sed -i "/^# IPv4 local connections:/a host    all             all             10.1.0.0/16            md5" $PG_HBA_CONF

# Allow listening on all IP addresses
sudo sed -i "s/^#listen_addresses = 'localhost'/listen_addresses = '*'/" $POSTGRESQL_CONF

# Restart PostgreSQL
sudo systemctl restart postgresql-15
