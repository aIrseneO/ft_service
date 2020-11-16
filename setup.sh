#! /bin/sh
#
##sudo chown "$USER":"$USER" /home/"$USER"/.docker -R
##sudo chmod g+rwx "/home/$USER/.docker" -R
#
USER=user42
PASS=user42
DATABASE=mydatabase
#
#sudo chown "$USER":"$USER" /var/run/docker.sock -R
#
if [ "$1" = --restart ] || [ "$1" = --clean ]; then
	kubectl delete deploy,svc,replicaset,pod,pvc,pv --all
	docker exec -d minikube sh rm -rf /data
	docker exec -d minikube sh rm -rf /certs
	docker exec -d minikube sh rm -rf /mnt
fi
#
if [ "$1" = --clean ]; then
	exit
fi
#
if [ "$1" != --restart ] && [ "$1" != --build ]; then
	# Starting minikube
	minikube start --driver=docker \
		--extra-config=apiserver.service-node-port-range=1-40000
	#
	# Enable minikube dashboard
	minikube addons enable dashboard
	minikube addons enable metrics-server
	minikube dashboard &
fi
#
echo	Get the IP address of the running container minikube....................
##IP=$(minikube ip)
IP=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' minikube)
##IP=$(kubectl get node \
##	-o=custom-columns='DATA:status.addresses[0].address' | sed -n 2p)
##IP=$(docker inspect -f '{{range.NetworkSettings.Networks}} \
##	{{.IPAddress}}{{end}}' minikube)
echo IP: $IP
#
# Point shell to minikube's docker-daemon
eval $(minikube -p minikube docker-env)
#
echo Build images...
echo    Build my Alpine image with the common installations.....................
docker build -t myalpine -f srcs/Dockerfile_myalpine srcs/ > $PWD/log.txt
echo    Build InfluxDB image....................................................
docker build -t influxdb_image --build-arg USER=$USER --build-arg PASS=$PASS \
		--build-arg HOST=127.0.0.1 -f srcs/influxdb/Dockerfile \
		srcs/influxdb >> $PWD/log.txt
echo    Build Mysql image.......................................................
docker build -t mysql_image --build-arg USER=$USER --build-arg PASS=$PASS \
		--build-arg IP=$IP --build-arg DATABASE=$DATABASE \
		--build-arg HOST=influxdb-service \
		-f srcs/mysql/Dockerfile srcs/mysql >> $PWD/log.txt
echo    Build Ftps image........................................................
docker build -t ftps_image --build-arg USER=$USER --build-arg PASS=$PASS \
		--build-arg IP=$IP --build-arg HOST=influxdb-service \
		-f srcs/ftps/Dockerfile srcs/ftps >> $PWD/log.txt
echo    Build Nginx image.......................................................
docker build -t nginx_image --build-arg USER=$USER --build-arg PASS=$PASS \
		--build-arg HOST=influxdb-service --build-arg IP=$IP \
		-f srcs/nginx/Dockerfile srcs/nginx >> $PWD/log.txt
echo    Build Wordpress image...................................................
docker build -t wordpress_image --build-arg USER=$USER --build-arg PASS=$PASS \
		--build-arg HOST1=mysql --build-arg HOST2=influxdb-service \
		--build-arg DATABASE=$DATABASE -f srcs/wordpress/Dockerfile \
		srcs/wordpress >> $PWD/log.txt
echo    Build PhpMyAdmin image..................................................
docker build -t phpmyadmin_image --build-arg USER=$USER --build-arg PASS=$PASS \
		--build-arg HOST1=mysql --build-arg HOST2=influxdb-service \
		-f srcs/phpmyadmin/Dockerfile srcs/phpmyadmin >> $PWD/log.txt
echo    Build Grafana image.....................................................
docker build -t grafana_image --build-arg USER=$USER --build-arg PASS=$PASS \
		--build-arg HOST=influxdb-service -f srcs/grafana/Dockerfile \
		srcs/grafana >> $PWD/log.txt
echo	Done.................................................... >> $PWD/log.txt
#
if [ "$1" = --build ]; then
		exit
fi
#
echo    Spin up a container to create a key and a certificate in the master node...
docker run --rm -v /certs:/certs myalpine \
	sh /ssl_key_crt_gen.sh -d=/certs -n=cert -i=$IP
#
if [ "$1" != --restart ]; then
	echo	Prepare and install MetalLB.........................................
	kubectl get configmap kube-proxy -n kube-system -o yaml | \
		sed -e "s/strictARP: false/strictARP: true/" | \
		kubectl apply -f - -n kube-system
	kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.4/manifests/namespace.yaml
	kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.4/manifests/metallb.yaml
	# On first install only
	kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"
fi
#
echo	Configure MetalLB.......................................................
sed -e "s|MyClusterIP|$IP-255.255.255.255|" srcs/metalLB-conf.yaml |\
	kubectl apply -f -
#
echo	Update yaml files and create deployments and services...................
echo	InfluxDB................................................................
kubectl create -f srcs/influxdb/influxdb-deployment.yaml
kubectl create -f srcs/influxdb/influxdb-service.yaml
kubectl create -f srcs/influxdb/influxdb-persistentVolume.yaml
echo	Mysql...................................................................
kubectl create -f srcs/mysql/mysql-persistentVolume.yaml
kubectl create -f srcs/mysql/mysql-deployment.yaml
kubectl create -f srcs/mysql/mysql-service.yaml
echo	FTPS....................................................................
kubectl create -f srcs/ftps/ftps-persistentVolume.yaml
sed -e "s|__USER__|$USER|" srcs/ftps/ftps-deployment.yaml |\
	kubectl create -f -
sed -e "s|MyClusterIP|$IP|" srcs/ftps/ftps-service.yaml |\
	kubectl create -f -
echo	Nginx...................................................................
kubectl create -f srcs/nginx/nginx-deployment.yaml
sed -e "s|MyClusterIP|$IP|" srcs/nginx/nginx-service.yaml |\
	kubectl create -f -
echo	Wordpress...............................................................
kubectl create -f srcs/wordpress/wordpress-persistentVolume.yaml
kubectl create -f srcs/wordpress/wordpress-deployment.yaml
sed -e "s|MyClusterIP|$IP|" srcs/wordpress/wordpress-service.yaml |\
	kubectl create -f -
echo	PhpMyAdmin..............................................................
kubectl create -f srcs/phpmyadmin/phpmyadmin-deployment.yaml
sed -e "s|MyClusterIP|$IP|" srcs/phpmyadmin/phpmyadmin-service.yaml |\
	kubectl create -f -
echo	Grafana.................................................................
kubectl create -f srcs/grafana/grafana-persistentVolume.yaml
kubectl create -f srcs/grafana/grafana-deployment.yaml
sed -e "s|MyClusterIP|$IP|" srcs/grafana/grafana-service.yaml |\
	kubectl create -f -
#
# Open the network in the browser
#open https://$IP
echo	https://$IP


#TODO: Create secrets for passwords
