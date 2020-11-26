#! /bin/sh/
#
# Copy Wordpress files if necessary (bz of persistent volume)
if [ -d "/www/wordpress" ]; then
	mv -f /www/wordpress/* /var/www/wordpress
	rm -rf /www
fi
#
# Using Supervisord, start all services
/usr/bin/supervisord -n -c /etc/supervisord.conf
#
# Set the global directive for the process identifier (PID)
#php-fpm7 --pid /run/php/php.pid
#
# Reload Nginx server to include new changes
#nginx -s reload
#
# Start Telegraf
#telegraf --config /etc/telegraf.conf
#
# References
#https://wiki.alpinelinux.org/wiki/Nginx
#https://www.nginx.com/resources/wiki/start/topics/tutorials/commandline/
#https://wiki.alpinelinux.org/wiki/Nginx_with_PHP#Configuration_of_PHP7
#https://wiki.alpinelinux.org/wiki/WordPress
