#This file has simple container creation commands and instructions.
LAtest Matomo
`````bash
docker run --name matomo-db -e MYSQL_ROOT_PASSWORD=my-secret-pw -e MYSQL_DATABASE=matomo -e MYSQL_USER=matomo -e MYSQL_PASSWORD=matomo_pw -e TZ=Europe/Helsinki -v /home/sam/Stuff/db:/var/lib/mysql:z -d mariadb
docker run --name matomo-app --link matomo-db:db -p 8080:80 -v /home/sam/Stuff/matomo:/var/www/html:z -e TZ=Europe/Helsinki -d matomo

`````
