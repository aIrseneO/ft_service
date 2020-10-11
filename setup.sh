#! /bin/bash


# Create images

# Create my Alpine image with the common installations
#docker build -t myalpine -f Dockerfile .

# Ftps
#cd srcs/ftps
#docker build -t ftps_image -f Dockerfile_ftps .
# To create a container
##docker run -d -P --name ftps_container ftps_image
# To remove a container with the commun volume attached
##docker rm -v ftps_container

# Wordpress

# phpMyAdmin
cd srcs/phpmyadmin
docker build -t phpmyadmin_image -f Dockerfile_phpmyadmin .
# To create a container
docker run -d -p 5000:80 -p 443:443 --name phpmyadmin_container phpmyadmin_image
# docker run -it -p 80:80 -p 443:443 --name php -v ${PWD}/srcs/phpmyadmin/srcs:/root phpmyadmin_image


# Nginx

# Mysql

# InfluxDB

# Grafana
