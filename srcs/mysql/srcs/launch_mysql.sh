#! /bin/sh/
#
#################################################################
#
if [ ! -d "/run/mysqld" ]; then
  mkdir -p /run/mysqld
fi
#
if [ ! -d /var/lib/mysql/DB_created ]; then
	# Setup the database when mysql is up (nohup comes handy)
	nohup sh setup_database.sh > /dev/null 2>&1 &
	mkdir -p /var/lib/mysql/DB_created
fi
# Configure MariaDB
sed -i 's/skip-networking/#skip-networking/g' /etc/my.cnf.d/mariadb-server.cnf
#
# Install MariaDB/MySQL system tables
mysql_install_db --user=root --defaults-file=/etc/mysql/my.cnf
#
# Start telegraf
telegraf --config /etc/telegraf.conf &
#
# Start MYSQL
/usr/bin/mysqld_safe --datadir='/var/lib/mysql'
#
###############################################################
#
# Start the MariaDB daemon [2]
#/usr/bin/mysqld_safe --no-watch --basedir=/usr --datadir='/var/lib/mysql' --plugin-dir='/usr/lib/mariadb/plugin' --user=root --log-error='/var/lib/mysql/error.log' --pid-file='/run/mysqld/mysqld.pid' --port=3306 --verbose=0 
#
# Secure installation [3]
#sh mysql_secure_installation.sh ${MYSQL_ROOT_PASSWORD}
#
# Display latest errors logging
#tail -f /var/lib/mysql/error.log
#
# References
#https://phoenixnap.com/kb/how-to-create-new-mysql-user-account-grant-privileges [1]
#https://mariadb.com/kb/en/mysqld_safe/ [2]
#https://gist.github.com/Mins/4602864 [3]
#https://github.com/wangxian/alpine-mysql [4]
