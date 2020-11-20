#! /bin/sh/
#
################################################################# -1-
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
# Start telegraf
telegraf --config /etc/telegraf.conf &
#
# Install MariaDB/MySQL system tables
mysql_install_db --user=root --defaults-file=/etc/mysql/my.cnf
#
# Start MYSQL
/usr/bin/mysqld_safe --datadir='/var/lib/mysql'
#
############################################################### or -2-
#
# Start the MariaDB daemon [2]
#/usr/bin/mysqld_safe --no-watch --basedir=/usr --datadir='/var/lib/mysql' --plugin-dir='/usr/lib/mariadb/plugin' --user=root --log-error='/var/lib/mysql/error.log' --pid-file='/run/mysqld/mysqld.pid' --port=3306 --verbose=0 
#
# Secure installation [3]
#sh mysql_secure_installation.sh ${MYSQL_ROOT_PASSWORD}
#
# Create a new database
#echo "CREATE DATABASE ${MYSQL_DATABASE};" | mysql -u root
#
# Create users based on their permissions using the following  formats:
#CREATE USER 'username'@'ip_address' IDENTIFIED BY 'password';
#GRANT permission ON database.table TO 'username'@'ip_address';
#	Administrator: This user account has full access to the database
#echo "CREATE USER '${ADMIN}'@'%' IDENTIFIED BY '${ADMIN_PW}';" | mysql -u root
#echo "GRANT ALL PRIVILEGES ON *.* TO '${ADMIN}'@'%';" | mysql -u root
#	Insertor: This user can insert rows into tables
#echo "CREATE USER '${INSERTOR}'@'{IP}' IDENTIFIED BY '${INSERTOR_PW}';" | mysql -u root
#echo "GRANT INSERT ON ${DATABASE}.* TO '${INSERTOR}'@'${IP}';" | mysql -u root
#	Deletor: The user can remove rows from tables
#echo "CREATE USER '${DELETOR}'@'${IP}' IDENTIFIED BY '${DELETOR_PW}';" | mysql -u root
#echo "GRANT DELETE ON ${DATABASE}.* TO '${DELETOR}'@'${IP}';" | mysql -u root
#	Creator: The user can create entirely new tables and databases
#echo "CREATE USER '${CREATOR}'@'${IP}' IDENTIFIED BY '${CREATOR_PW}';" | mysql -u root
#echo "GRANT CREATE ON ${DATABASE}.* TO '${CREATOR}'@'${IP}';" | mysql -u root
#	Droptor: This user can drop (remove) entire tables and databases
#echo "CREATE USER '${DROPTOR}'@'${IP}' IDENTIFIED BY '${DROPTOR_PW}';" | mysql -u root
#echo "GRANT DROP ON ${DATABASE}.* TO '${DROPTOR}'@'${IP}';" | mysql -u root
#	Selector: This user gets access to the select command, to read 
#	the information in the databases
#echo "CREATE USER '${SELECTOR}'@'${IP}' IDENTIFIED BY '${SELECTOR_PW}';" | mysql -u root
#echo "GRANT SELECT ON ${DATABASE}.* TO '${SELECTOR}'@'${IP}';" | mysql -u root
#	Updator: This user can update table rows
#echo "CREATE USER '${UPDATOR}'@'${IP}' IDENTIFIED BY '${UPDATOR_pw}';" | mysql -u root
#echo "GRANT UPDATE ON ${DATABASE}.* TO '${UPDATOR}'@'${IP}';" | mysql -u root
#	Grantor: This user can modify other user account privileges
#echo "CREATE USER '${GRANTOR}'@'${IP}' IDENTIFIED BY '${GRANTOR_PW}';" | mysql -u root
#echo "GRANT GRANT OPTION ON ${DATABASE}.* TO '${GRANTOR}'@'${IP}';" | mysql -u root
#
#echo "FLUSH PRIVILEGES;" | mysql -u root
#
# Display latest errors logging
#tail -f /var/lib/mysql/error.log
#
# References
#https://phoenixnap.com/kb/how-to-create-new-mysql-user-account-grant-privileges [1]
#https://mariadb.com/kb/en/mysqld_safe/ [2]
#https://gist.github.com/Mins/4602864 [3]
#https://github.com/wangxian/alpine-mysql [4]
