# Latest Matomo

## Add Networks and Volumes


````bash
podman network create matomo-net
podman volume create matomo-data
podman volume create matomo-config
podman volume create matomo-html
podman run -d --name matomo-db --network matomo-net -v matomo-data:/var/lib/mysql  mariadb
podman run -d --name matomo --network matomo-net -p 8080:80 -v matomo-html:/var/www/html:z -v matomo-logs:/var/log/apache2:z -e TZ=Europe/Helsinki -v matomo-config:/var/www/html/config:z analytics

````




## Custom or existing Matomo

**Copy the latest Matomo to directory matomo.**

Then add volumes and networks
````bash
podman network create matomo-net
podman volume create matomo-data
podman volume create matomo-config
podman volume create matomo-html
mkdir matomo-html matomo-logs matomo-config matomo-data
podman build -t analytics .
podman  run -d  --name mariadb --network matomo-net -p 3306:3306 -e MARIADB_ROOT_PASSWORD=foobar123 -e MARIADB_DATABASE=matomodb -e MARIADB_USER=matomo_usr -e MARIADB_PASSWORD=l0ser123 -p 3306:3306 -e TZ=Europe/Helsinki -v matomo-data:/var/lib/mysql:z mariadb:latest
podman run -d --name matomo --network matomo-net -p 8080:80 -v matomo-html:/var/www/html:z -v matomo-logs:/var/log/apache2:z -v matomo-config:/var/www/html/config:z analytics

#you can also:

podman run -d --name matomo --network matomo-net -p 8080:80 \
    -e MATOMO_DATABASE_HOST=192.168.245.131\
    -e MATOMO_DATABASE_ADAPTER="PDO\MYSQL" \
    -e MATOMO_DATABASE_TABLES_PREFIX=matomo_ \
    -e MATOMO_DATABASE_USERNAME=matomo_usr \
    -e MATOMO_DATABASE_PASSWORD=l0ser123 \
    -e MATOMO_DATABASE_DBNAME=matomodb \
    -v matomo-html:/var/www/html:z \
    -v matomo-logs:/var/log/apache2:z \
    -v matomo-config:/var/www/html/config:z \
    analytics


and then:
cd /etc/systemd/systemd
podman generate systemd


echo "alias mysql='podman exec -it mariadb mariadb'" >> ~/.bashrc
````

