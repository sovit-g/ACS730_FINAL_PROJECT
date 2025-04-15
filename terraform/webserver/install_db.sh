#!/bin/bash

# Update the system
sudo yum update -y

# Install PostgreSQL 13
sudo amazon-linux-extras enable postgresql13
sudo yum install -y postgresql postgresql-server

# Initialize PostgreSQL database
sudo postgresql-setup initdb

# Start PostgreSQL and enable it to start on boot
sudo systemctl start postgresql
sudo systemctl enable postgresql

# Set a password for the 'postgres' user
sudo -u postgres psql -c "ALTER USER postgres PASSWORD 'postgres';"

# Allow PostgreSQL to listen on all IP addresses
sudo sed -i "s/^#listen_addresses = 'localhost'/listen_addresses = '*'/" /var/lib/pgsql/data/postgresql.conf

# Allow connections from your VPC range (adjust if needed)
sudo sed -i "/^# IPv4 local connections:/a host    all             all             10.1.0.0/16            md5" /var/lib/pgsql/data/pg_hba.conf

# Restart PostgreSQL to apply changes
sudo systemctl restart postgresql
