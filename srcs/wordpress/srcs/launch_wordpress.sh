#! /bin/sh/
#
#
if [ -d "/www/wordpress" ]; then
	mv -f /www/wordpress/* /var/www/wordpress
	rm -rf /www
fi
#
# Set Pid for nginx
nginx -g "pid /run/nginx/nginx.pid;"
#
# Start Telegraf, Php, Ssh and Nginx
telegraf --config /etc/telegraf.conf &
php-fpm7 --pid /run/php/php.pid &
/usr/sbin/sshd &
nginx -s reload
#
# Check if nginx and php are up running
#ps aux | grep nginx
#ps aux | grep php
#
# References
#https://wiki.alpinelinux.org/wiki/Nginx
#https://www.nginx.com/resources/wiki/start/topics/tutorials/commandline/
#https://wiki.alpinelinux.org/wiki/WordPress
