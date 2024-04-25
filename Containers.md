#This file has simple container creation commands and instructions.
LAtest Matomo
`````bash
docker run --name matomo-db -e MYSQL_ROOT_PASSWORD=my-secret-pw -e MYSQL_DATABASE=matomo -e MYSQL_USER=matomo -e MYSQL_PASSWORD=matomo_pw -e TZ=Europe/Helsinki -v /home/sam/Stuff/db:/var/lib/mysql:z -d mariadb
#TODO certificate and config volumes and CIS stuff
docker run --name matomo-app --link matomo-db:db -p 8080:80 -v /home/sam/Stuff/matomo:/var/www/html:z -e TZ=Europe/Helsinki -d matomo

docker run -d \
  --name mariadb \
  -e MARIADB_ROOT_PASSWORD=foobar123 \
  -e MARIADB_DATABASE=matomodb \
  -e MARIADB_USER=matomo_usr \
  -e MARIADB_PASSWORD=l0ser123 \
  -p 3306:3306 \
  -v /home/sam/Stuff/matomo:/var/www/html:z \
  -v /home/sam/Stuff/matomo:/var/www/html:z \
  -e TZ=Europe/Helsinki \
  mariadb:latest

#alias mysql='docker exec -it mariadb mariadb'
FIXME
mkdir -p /path/to/your/certificates
mkdir -p /path/to/your/config

#Docker-compose.yml
version: '3.8'

services:
  matomo:
    image: matomo:latest
    restart: always
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - matomo_data:/var/www/html
      - /path/to/your/certificates:/etc/ssl/certs:ro
      - /path/to/your/config:/var/www/html/config:rw
    environment:
      MATOMO_DATABASE_HOST: db
      MATOMO_DATABASE_USERNAME: matomo
      MATOMO_DATABASE_PASSWORD: matomo_password
      MATOMO_DATABASE_DBNAME: matomo

  db:
    image: mariadb:latest
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: root_password
      MYSQL_DATABASE: matomo
      MYSQL_USER: matomo
      MYSQL_PASSWORD: matomo_password
    volumes:
      - db_data:/var/lib/mysql:z

volumes:
  matomo_data:
  db_data:

#alias mysql='docker-compose exec -T mariadb' 

#some Podman testing
podman run -d --pod lamp-pod --name mariadb \
    -e MYSQL_ROOT_PASSWORD=your_root_password \
    -v mariadb_data:/var/lib/mysql \
    --restart always \
    mariadb:latest


podman run -d --pod lamp-pod --name apache-php \
    -v apache_config:/etc/apache2 \
    -v apache_ssl:/etc/apache2/ssl \
    -v /path/to/your/app:/var/www/html \
    --restart always \
    php:latest

podman exec -it mariadb bash
podman exec -it apache-php bash

podman pod start lamp-pod
podman pod stop lamp-pod
podman pod restart lamp-pod



podman exec -it apache-php a2enmod ssl
podman exec -it apache-php a2enmod rewrite
podman exec -it apache-php a2enmod headers
podman exec -it apache-php service apache2 restart
<VirtualHost *:443>
    ServerName yourdomain.com
    ServerAlias www.yourdomain.com
    DocumentRoot /var/www/html/your_website_directory

    SSLEngine on
    SSLCertificateFile /etc/apache2/ssl/server.crt
    SSLCertificateKeyFile /etc/apache2/ssl/server.key

    <Directory /var/www/html/your_website_directory>
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog ${APACHE_LOG_DIR}/yourdomain_error.log
    CustomLog ${APACHE_LOG_DIR}/yourdomain_access.log combined
</VirtualHost>

podman exec -it apache-php a2ensite yourdomain.conf
podman exec -it apache-php service apache2 restart


<VirtualHost *:80>
    ServerName yourdomain.com
    ServerAlias www.yourdomain.com
    Redirect permanent / https://yourdomain.com/
</VirtualHost>



















`````
