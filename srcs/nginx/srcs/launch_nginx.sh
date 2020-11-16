#! /bin/sh/
#
# Creating new user and group 'www' for nginx
#adduser -D -g 'www' -h /home/www/ www
#
# Create a directory for web files
#mkdir /www
#chown -R www:www /www
#
# Move web files to the web directory
#mv info.php /www
#
# Give ownership of nginx's file to the user
#chown -R www:www /var/lib/nginx
#
# Make backup of the original nginx.conf file
#mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.orig
#
# Copy Nginx's configuration file
#cp nginx.conf /etc/nginx/nginx.conf
#
# Copy the server configuration file to Nginx
#cp localhost.conf /etc/nginx/conf.d/localhost.conf
#
# Generate Self signed certificate
#sh ssl_key_crt_gen.sh nginx
#
# Check if the configuration is correct
##nginx -t
#
# Modify PHP config files www.conf and php.ini
#sed -i "s|;listen.owner\s*=\s*nobody|listen.owner = ${PHP_FPM_USER}|g" /etc/php7/php-fpm.d/www.conf
#sed -i "s|;listen.group\s*=\s*nobody|listen.group = ${PHP_FPM_GROUP}|g" /etc/php7/php-fpm.d/www.conf
#sed -i "s|;listen.mode\s*=\s*0660|listen.mode = ${PHP_FPM_LISTEN_MODE}|g" /etc/php7/php-fpm.d/www.conf
#sed -i "s|user\s*=\s*nobody|user = ${PHP_FPM_USER}|g" /etc/php7/php-fpm.d/www.conf
#sed -i "s|group\s*=\s*nobody|group = ${PHP_FPM_GROUP}|g" /etc/php7/php-fpm.d/www.conf
#sed -i "s|;log_level\s*=\s*notice|log_level = notice|g" /etc/php7/php-fpm.d/www.conf
#
#sed -i "s|display_errors\s*=\s*Off|display_errors = ${PHP_DISPLAY_ERRORS}|i" /etc/php7/php.ini
#sed -i "s|display_startup_errors\s*=\s*Off|display_startup_errors = ${PHP_DISPLAY_STARTUP_ERRORS}|i" /etc/php7/php.ini
#sed -i "s|error_reporting\s*=\s*E_ALL & ~E_DEPRECATED & ~E_STRICT|error_reporting = ${PHP_ERROR_REPORTING}|i" /etc/php7/php.ini
#sed -i "s|;*memory_limit =.*|memory_limit = ${PHP_MEMORY_LIMIT}|i" /etc/php7/php.ini
#sed -i "s|;*upload_max_filesize =.*|upload_max_filesize = ${PHP_MAX_UPLOAD}|i" /etc/php7/php.ini
#sed -i "s|;*max_file_uploads =.*|max_file_uploads = ${PHP_MAX_FILE_UPLOAD}|i" /etc/php7/php.ini
#sed -i "s|;*post_max_size =.*|post_max_size = ${PHP_MAX_POST}|i" /etc/php7/php.ini
#sed -i "s|;*cgi.fix_pathinfo=.*|cgi.fix_pathinfo= ${PHP_CGI_FIX_PATHINFO}|i" /etc/php7/php.ini
#
# Set the global directive for the process identifier (PID)
#mkdir -p /run/nginx
#mkdir -p /run/php
#
# Start ssh server
/usr/sbin/sshd
#
# Reload Nginx server and start PHP
nginx -g "pid /run/nginx/nginx.pid;"
php-fpm7 --pid /run/php/php.pid
nginx -s reload
#
# Start Telegraf
telegraf --config /etc/telegraf.conf &
# Check if nginx and php are up running
#ps aux | grep nginx
#ps aux | grep php
#
# Display latest accesses logging and errors logging to ease administration
tail -f /var/log/nginx/access.log /var/log/nginx/error.log
#
# References
#https://wiki.alpinelinux.org/wiki/Nginx
#https://www.nginx.com/resources/wiki/start/topics/tutorials/commandline/
#https://wiki.alpinelinux.org/wiki/Nginx_with_PHP#Configuration_of_PHP7
