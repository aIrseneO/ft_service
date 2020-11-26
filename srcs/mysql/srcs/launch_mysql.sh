#! /bin/sh/
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
#
# Using Supervisord, start all services
/usr/bin/supervisord -n -c /etc/supervisord.conf
#
# References
#https://mariadb.com/kb/en/mysqld_safe/
#https://github.com/wangxian/alpine-mysql
