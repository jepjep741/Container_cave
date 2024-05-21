#!/bin/bash

# Variables
IMAGE_NAME="ubuntu:latest"
CONTAINER_NAME="apache_php_container"
NEW_IMAGE_NAME="apache_php_image"
HOST_PORT_HTTP=8080
WEB_DATA_DIR="/opt/webdata"
LOG_DATA_DIR="/opt/logdata"
TIMEZONE="Europe/Helsinki"

# Create directories for web data and logs on the host
mkdir -p $WEB_DATA_DIR
mkdir -p $LOG_DATA_DIR

# Set SELinux context for the web data and log directories
echo "Setting SELinux context for the web data and log directories..."
sudo chcon -Rt svirt_sandbox_file_t $WEB_DATA_DIR
sudo chcon -Rt svirt_sandbox_file_t $LOG_DATA_DIR

# Pull the latest Ubuntu image
echo "Pulling the latest Ubuntu image..."
podman pull $IMAGE_NAME

# Create and start a new container
echo "Creating and starting a new container..."
podman run -it --name $CONTAINER_NAME -v $WEB_DATA_DIR:/var/www/html:Z -v $LOG_DATA_DIR:/var/log/apache2:Z $IMAGE_NAME /bin/bash -c "
    # Update package list
    apt-get update  

    # Install Apache and PHP
    apt-get install -y apache2 php libapache2-mod-php
  

    # Secure Apache by hiding server information and disabling directory listing
    echo 'ServerName $SERVER_NAME' >> /etc/apache2/apache2.conf
    sed -i 's/ServerTokens OS/ServerTokens Prod/' /etc/apache2/conf-available/security.conf
    sed -i 's/ServerSignature On/ServerSignature Off/' /etc/apache2/conf-available/security.conf
    echo 'Options -Indexes' >> /etc/apache2/apache2.conf

    # Apply CIS Benchmark for Apache
    a2dismod autoindex -f
    chown -R root:root /etc/apache2
    chmod -R 755 /etc/apache2

    # For PHP
    sed -i 's/expose_php = On/expose_php = Off/' /etc/php/*/apache2/php.ini

    # Restart Apache to apply changes
    service apache2 restart

    # Create a PHP info file
    echo '<?php phpinfo(); ?>' > /var/www/html/info.php

    # Keep the container running
    tail -f /dev/null
"
# post tasks define and variables again-->
# Commit the container to a new image
echo "Committing the container to a new image..."
podman commit $CONTAINER_NAME $NEW_IMAGE_NAME

# Stop the container
echo "Stopping the container..."
podman stop $CONTAINER_NAME

# Remove the initial container
echo "Removing the initial container..."
podman rm $CONTAINER_NAME

# Run the container with port mapping and volume mounts
echo "Running the container with port mapping and volume mounts..."
podman run -d -p $HOST_PORT_HTTP:80 --name $CONTAINER_NAME -v $WEB_DATA_DIR:/var/www/html:Z -v $LOG_DATA_DIR:/var/log/apache2:Z $NEW_IMAGE_NAME

# Output completion message
echo "Apache and PHP setup in Podman container with host volumes is complete."
echo "Access Apache at http://localhost:$HOST_PORT_HTTP"
echo "Web data directory: $WEB_DATA_DIR"
echo "Apache log directory: $LOG_DATA_DIR"
