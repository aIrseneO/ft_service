#! /bin/sh
#
# Wait until mysql is up running
until mysql
do
	echo "Mysql not up"
done
#
# Setup database
echo "CREATE DATABASE ${DATABASE};" | mysql
echo "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '${ROOT_PASSWORD}' WITH GRANT OPTION;" | mysql
echo "CREATE USER '${ADMIN}'@'%' IDENTIFIED BY '${ADMIN_PW}';" | mysql
echo "GRANT ALL PRIVILEGES ON ${DATABASE}.* TO '${ADMIN}'@'%' WITH GRANT OPTION;" | mysql
echo "DROP DATABASE test" | mysql
echo "FLUSH PRIVILEGES;" | mysql
mysql $DATABASE < /mydatabase.sql
