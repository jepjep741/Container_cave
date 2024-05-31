#!/bin/bash

# Variables
DB_ROOT_PASSWORD="myrootpassword"
DB_NAME="matomo"
DB_USER="matomo"
DB_PASSWORD="matomopassword"
DB_CONTAINER_NAME="mariadb"
MATOMO_CONTAINER_NAME="matomo"
NETWORK_NAME="matomo-network"
HOST_MARIADB_DATA_DIR="/var/lib/mariadb/data"
HOST_MATOMO_CONFIG_DIR="/var/lib/matomo/config"
HOST_MATOMO_DATA_DIR="/var/lib/matomo/data"
HOST_MATOMO_LOGS_DIR="/var/lib/matomo/logs"
TIMEZONE="Europe/Helsinki"

# Create data directories
sudo mkdir -p $HOST_MARIADB_DATA_DIR
sudo mkdir -p $HOST_MATOMO_CONFIG_DIR
sudo mkdir -p $HOST_MATOMO_DATA_DIR
sudo mkdir -p $HOST_MATOMO_LOGS_DIR

# Set permissions
sudo chown -R 999:999 $HOST_MARIADB_DATA_DIR
sudo chcon -Rt svirt_sandbox_file_t $HOST_MARIADB_DATA_DIR
sudo chown -R 1000:1000 $HOST_MATOMO_CONFIG_DIR $HOST_MATOMO_DATA_DIR $HOST_MATOMO_LOGS_DIR
sudo chcon -Rt svirt_sandbox_file_t $HOST_MATOMO_CONFIG_DIR $HOST_MATOMO_DATA_DIR $HOST_MATOMO_LOGS_DIR

# Create a user-defined network
podman network create $NETWORK_NAME

# Run MariaDB container
podman run -d \
  --name $DB_CONTAINER_NAME \
  --network $NETWORK_NAME \
  -e MYSQL_ROOT_PASSWORD=$DB_ROOT_PASSWORD \
  -e MYSQL_DATABASE=$DB_NAME \
  -e MYSQL_USER=$DB_USER \
  -e MYSQL_PASSWORD=$DB_PASSWORD \
  -v $HOST_MARIADB_DATA_DIR:/var/lib/mysql:Z \
  -e TZ=$TIMEZONE \
  mariadb:latest

# Run Matomo container
podman run -d \
  --name $MATOMO_CONTAINER_NAME \
  --network $NETWORK_NAME \
  -e MATOMO_DATABASE_HOST=$DB_CONTAINER_NAME \
  -e MATOMO_DATABASE_ADAPTER=mysql \
  -e MATOMO_DATABASE_TABLES_PREFIX=matomo_ \
  -e MATOMO_DATABASE_USERNAME=$DB_USER \
  -e MATOMO_DATABASE_PASSWORD=$DB_PASSWORD \
  -e MATOMO_DATABASE_DBNAME=$DB_NAME \
  -v $HOST_MATOMO_CONFIG_DIR:/var/www/html/config:Z \
  -v $HOST_MATOMO_DATA_DIR:/var/www/html/misc:Z \
  -v $HOST_MATOMO_LOGS_DIR:/var/www/html/tmp:Z \
  -e TZ=$TIMEZONE \
  -p 8080:80 \
  matomo:latest

# Verify containers are running
podman ps
