#! /bin/sh
#
if [ "$1" = --clean ]; then
        docker kill mysql influxdb ftps nginx wordpress phpmyadmin grafana
        docker rm -v mysql influxdb ftps nginx wordpress phpmyadmin grafana
        sudo rm -rf data
		exit
fi
#
USER=user
PASSWORD=password
DATABASE=db
DB_USER=arsene
DB_USER_PASSWORD=password
DB_ROOT_PASSWORD=password
IP=localhost
#
# Build images
#	Build my Alpine image with the common installations
docker build -t myalpine -f srcs/Dockerfile_myalpine srcs/
#	Mysql
docker build -t mysql_image --build-arg ROOT_PASSWORD=$DB_ROOT_PASSWORD \
		--build-arg DATABASE=$DATABASE --build-arg HOST=localhost \
		--build-arg ADMIN=$DB_USER --build-arg ADMIN_PW=$DB_USER_PASSWORD \
		-f srcs/mysql/Dockerfile srcs/mysql
#
#	InfluxDB
docker build -t influxdb_image --build-arg USER=$DB_USER \
		--build-arg PASS=$DB_USER_PASSWORD --build-arg DATABASE=$DATABASE \
		-f srcs/influxdb/Dockerfile srcs/influxdb
#	Ftps
docker build --build-arg USER=$USER --build-arg PASSWORD=$PASSWORD \
		-t ftps_image -f srcs/ftps/Dockerfile srcs/ftps
#	Nginx
docker build -t nginx_image -f srcs/nginx/Dockerfile srcs/nginx
#	Wordpress
docker build -t wordpress_image --build-arg DB_USER=$DB_USER \
		--build-arg HOSTNAME=mysql --build-arg DATABASE=$DATABASE \
		--build-arg DB_PASSWORD=$DB_USER_PASSWORD \
		-f srcs/wordpress/Dockerfile srcs/wordpress
#	phpMyAdmin
docker build -t phpmyadmin_image --build-arg HOSTNAME=mysql \
		-f srcs/phpmyadmin/Dockerfile srcs/phpmyadmin
#	Grafana
docker build -t grafana_image --build-arg GRAF_USER=$DB_USER \
		--build-arg GRAF_PASS=$DB_USER_PASSWORD \
		-f srcs/grafana/Dockerfile srcs/grafana
#
if [ "$1" = --build ]; then
		exit
fi
#
# Run containers
#	Spin up a container to create a key and a certificate in the master node
docker run --rm --restart unless-stopped -v $PWD/srcs/certs:/certs myalpine \
		sh /ssl_key_crt_gen.sh -d=/certs -n=cert -i=$IP
#	Mysql container
docker run -d --name mysql -p 3306:3306 \
		-v $PWD/data/mysql:/var/lib/mysql mysql_image
#	InfluxDB container
docker run -d --name influxdb -p 8086:8086 -v $PWD/srcs/certs:/certs \
		-v $PWD/data/influxdb:/var/lib/influxdb influxdb_image
docker exec -d influxdb sh /database.sh 
#	Ftps container
docker run -d --name ftps -p 21:21 -v $PWD/srcs/certs:/certs \
		-v $PWD/data/ftps:/home/$USER ftps_image
#	Nginx container
docker run -d --name nginx -p 80:80 -p 22:22 -p 443:443 \
		-v $PWD/srcs/certs:/certs nginx_image
#	Wordpress container
docker run -d --name wordpress -p 5050:5050 -v $PWD/srcs/certs:/certs \
		-v $PWD/data/mysql:/var/lib/mysql --link mysql:mysql wordpress_image
#	phpMyAdmin container
docker run -d --name phpmyadmin -p 5000:5000 -v $PWD/srcs/certs:/certs \
		-v $PWD/data/mysql:/var/lib/mysql --link mysql:mysql phpmyadmin_image
#	Grafana container
docker run --name grafana -d -p 3000:3000 -v $PWD/srcs/certs:/certs \
		-v $PWD/data/grafana:/var/lib/grafana grafana_image
