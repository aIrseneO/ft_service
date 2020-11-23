#! /bin/sh
#
if [ "$1" = --clean ]; then
        docker kill mysql influxdb ftps nginx wordpress phpmyadmin grafana
        docker rm -v mysql influxdb ftps nginx wordpress phpmyadmin grafana
        sudo rm -rf data srcs/certs
		exit
fi
#
USER=user42
PASS=user42
IP=127.0.0.1
DATABASE=mydatabase
#
echo Build images............................................................
echo	Build my Alpine image with the common installations.....................
docker build -t myalpine -f srcs/Dockerfile_myalpine srcs/ > $PWD/log.txt
echo	Build InfluxDB image....................................................
docker build -t influxdb_image --build-arg USER=$USER --build-arg PASS=$PASS \
		--build-arg HOST=localhost -f srcs/influxdb/Dockerfile \
		srcs/influxdb >> $PWD/log.txt
echo	Build Mysql image.......................................................
docker build -t mysql_image --build-arg USER=$USER --build-arg PASS=$PASS \
		--build-arg IP=$IP --build-arg DATABASE=$DATABASE \
		--build-arg HOST=localhost -f srcs/mysql/Dockerfile \
		srcs/mysql >> $PWD/log.txt
echo	Build Ftps image........................................................
docker build -t ftps_image --build-arg USER=$USER --build-arg PASS=$PASS \
		--build-arg IP=$IP --build-arg HOST=localhost -f srcs/ftps/Dockerfile \
		srcs/ftps >> $PWD/log.txt
echo	Build Nginx image.......................................................
docker build -t nginx_image --build-arg USER=$USER --build-arg PASS=$PASS \
		--build-arg HOST=localhost --build-arg IP=$IP -f srcs/nginx/Dockerfile \
		srcs/nginx >> $PWD/log.txt
echo	Build Wordpress image...................................................
docker build -t wordpress_image --build-arg USER=$USER --build-arg PASS=$PASS \
		--build-arg HOST1=mysql --build-arg HOST2=localhost --build-arg IP=$IP \
		--build-arg DATABASE=$DATABASE -f srcs/wordpress/Dockerfile \
		srcs/wordpress >> $PWD/log.txt
echo	Build PhpMyAdmin image..................................................
docker build -t phpmyadmin_image --build-arg USER=$USER --build-arg PASS=$PASS \
		--build-arg HOST1=mysql --build-arg HOST2=localhost --build-arg IP=$IP \
		-f srcs/phpmyadmin/Dockerfile srcs/phpmyadmin >> $PWD/log.txt
echo	Build Grafana image.....................................................
docker build -t grafana_image --build-arg USER=$USER --build-arg PASS=$PASS \
		--build-arg HOST=localhost -f srcs/grafana/Dockerfile \
		srcs/grafana >> $PWD/log.txt
echo	Done.................................................... >> $PWD/log.txt
#
if [ "$1" = --build ]; then
		exit
fi
#
echo Run containers.............................................................
echo	Spin up a container to create a key and a certificate in the master node...
docker run --rm -v $PWD/srcs/certs:/certs myalpine \
		sh /ssl_key_crt_gen.sh -d=/certs -n=cert -i=$IP >> $PWD/log.txt
echo	Run InfluxDB container..................................................
docker run -d --restart unless-stopped --name influxdb -p 8086:8086 \
		-v $PWD/srcs/certs:/certs -v $PWD/data/influxdb:/var/lib/influxdb \
		influxdb_image
echo	Run Mysql container.....................................................
docker run -d --restart unless-stopped --name mysql -p 3306:3306 \
		--link influxdb:mysql -v $PWD/data/mysql:/var/lib/mysql mysql_image
#docker exec -d influxdb sh /database.sh 
echo	Run Ftps container......................................................
docker run -d --restart unless-stopped --name ftps -p 21:21 \
		--link influxdb:ftps -v $PWD/srcs/certs:/certs -v $PWD/data/ftps:/home/$USER ftps_image
echo	Run Nginx container.....................................................
docker run -d --restart unless-stopped --name nginx -p 80:80 -p 22:22 \
		-p 443:443 -v $PWD/srcs/certs:/certs nginx_image
echo	Run Wordpress container.................................................
docker run -d --restart unless-stopped --name wordpress -p 5050:5050 \
		-v $PWD/srcs/certs:/certs -v $PWD/data/mysql:/var/lib/mysql \
		--link mysql:mysql wordpress_image
echo	Run PhpMyAdmin container................................................
docker run -d --restart unless-stopped --name phpmyadmin -p 5000:5000 \
		-v $PWD/srcs/certs:/certs -v $PWD/data/mysql:/var/lib/mysql \
		--link mysql:mysql phpmyadmin_image
echo	Run Grafana container...................................................
docker run -d --restart unless-stopped --name grafana -p 3000:3000/tcp \
		-p 3000:3000/udp -v $PWD/srcs/certs:/certs \
		-v $PWD/data/grafana:/var/lib/grafana grafana_image
#
# TODO: establish connection between pods
