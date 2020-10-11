#! /bin/sh/
#
# PHP's configuration variables
PHP_FPM_USER="www"
PHP_FPM_GROUP="www"
PHP_FPM_LISTEN_MODE="0660"
PHP_MEMORY_LIMIT="512M"
PHP_MAX_UPLOAD="50M"
PHP_MAX_FILE_UPLOAD="200"
PHP_MAX_POST="100M"
PHP_DISPLAY_ERRORS="On"
PHP_DISPLAY_STARTUP_ERRORS="On"
PHP_ERROR_REPORTING="E_COMPILE_ERROR\|E_RECOVERABLE_ERROR\|E_ERROR\|E_CORE_ERROR"
PHP_CGI_FIX_PATHINFO=0
#
# Unpack the phpMyAdmin tar.gz files
tar xvf phpmyadmin.tar.gz > /dev/null
#
# Remove the tar.gz file
#rm -f phpmyadmin.tar.gz
#
# Rename the phpmyadmin file
mv -f phpMyAdmin* phpmyadmin
#
# Create a configuration file
cp phpmyadmin/config.sample.inc.php phpmyadmin/config.inc.php
#
# Edit the configuration file with sed app
sed -i "s/blowfish_secret'] = ''/blowfish_secret'] = 'mysecretpassword'/1" \
			phpmyadmin/config.inc.php
#
# Creating new user and group 'www' for nginx
adduser -D -g 'www' -h /home/www/ www
#
# Create a directory for html files
mkdir /www
chown -R www:www /var/lib/nginx
chown -R www:www /www
#
# Make backup of the original nginx.conf file
mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.orig
#
# Copy Nginx's configuration file
cp nginx.conf /etc/nginx/nginx.conf
#
# Copy the server configuration file to Nginx
cp phpmyadmin.conf /etc/nginx/conf.d/localhost.conf
#
# Generate Self signed certificate
sh ssl_key_crt_gen.sh nginx
#
# Move phpmyadmin files to www
mv -f phpmyadmin /www
cp info.php /www
#
# Check if the configuration is correct
#nginx -t
#
# Check if nginx is up running
ps aux | grep nginx
#
# Modify PHP config files www.conf and php.ini
sed -i "s|;listen.owner\s*=\s*nobody|listen.owner = ${PHP_FPM_USER}|g" /etc/php7/php-fpm.d/www.conf
sed -i "s|;listen.group\s*=\s*nobody|listen.group = ${PHP_FPM_GROUP}|g" /etc/php7/php-fpm.d/www.conf
sed -i "s|;listen.mode\s*=\s*0660|listen.mode = ${PHP_FPM_LISTEN_MODE}|g" /etc/php7/php-fpm.d/www.conf
sed -i "s|user\s*=\s*nobody|user = ${PHP_FPM_USER}|g" /etc/php7/php-fpm.d/www.conf
sed -i "s|group\s*=\s*nobody|group = ${PHP_FPM_GROUP}|g" /etc/php7/php-fpm.d/www.conf
sed -i "s|;log_level\s*=\s*notice|log_level = notice|g" /etc/php7/php-fpm.d/www.conf
#
sed -i "s|display_errors\s*=\s*Off|display_errors = ${PHP_DISPLAY_ERRORS}|i" /etc/php7/php.ini
sed -i "s|display_startup_errors\s*=\s*Off|display_startup_errors = ${PHP_DISPLAY_STARTUP_ERRORS}|i" /etc/php7/php.ini
sed -i "s|error_reporting\s*=\s*E_ALL & ~E_DEPRECATED & ~E_STRICT|error_reporting = ${PHP_ERROR_REPORTING}|i" /etc/php7/php.ini
sed -i "s|;*memory_limit =.*|memory_limit = ${PHP_MEMORY_LIMIT}|i" /etc/php7/php.ini
sed -i "s|;*upload_max_filesize =.*|upload_max_filesize = ${PHP_MAX_UPLOAD}|i" /etc/php7/php.ini
sed -i "s|;*max_file_uploads =.*|max_file_uploads = ${PHP_MAX_FILE_UPLOAD}|i" /etc/php7/php.ini
sed -i "s|;*post_max_size =.*|post_max_size = ${PHP_MAX_POST}|i" /etc/php7/php.ini
sed -i "s|;*cgi.fix_pathinfo=.*|cgi.fix_pathinfo= ${PHP_CGI_FIX_PATHINFO}|i" /etc/php7/php.ini
#
# Set the global directive for the process identifier (PID)
mkdir -p /run/nginx
mkdir -p /run/php
nginx -g "pid /run/nginx/nginx.pid;"
php-fpm7 --pid /run/php/php.pid
#
# Reload Nginx server to include new changes
nginx -s reload
#
# Display latest accesses logging and errors logging to ease administration
tail -f /var/log/nginx/access.log /var/log/nginx/error.log
#
# Source
#https://wiki.alpinelinux.org/wiki/Nginx
#https://www.nginx.com/resources/wiki/start/topics/tutorials/commandline/
#https://wiki.alpinelinux.org/wiki/Nginx_with_PHP#Configuration_of_PHP7
#https://wiki.alpinelinux.org/wiki/PhpMyAdmin
