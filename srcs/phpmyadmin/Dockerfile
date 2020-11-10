FROM myalpine

ARG USER=www
ARG HOSTNAME

ENV PHP_FPM_USER="$USER" PHP_FPM_GROUP="$USER" \
	PHP_FPM_LISTEN_MODE="0660" PHP_MEMORY_LIMIT="512M" \
	PHP_MAX_UPLOAD="50M" PHP_MAX_FILE_UPLOAD="200" \
	PHP_MAX_POST="100M" PHP_DISPLAY_ERRORS="On" \
	PHP_DISPLAY_STARTUP_ERRORS="On" PHP_CGI_FIX_PATHINFO=0 \
	PHP_ERROR_REPORTING="E_COMPILE_ERROR\|E_RECOVERABLE_ERROR\|E_ERROR\|E_CORE_ERROR"

COPY srcs/nginx.conf /etc/nginx/nginx.conf
COPY srcs/localhost.conf /etc/nginx/conf.d/localhost.conf
COPY srcs/launch_phpmyadmin.sh /launch_phpmyadmin.sh

RUN adduser -D -g '$USER' -h /home/$USER/ $USER && mkdir /$USER && \
	chown -R $USER:$USER /$USER && chown -R $USER:$USER /var/lib/nginx && \
	mkdir -p /run/nginx && mkdir -p /run/php

RUN wget https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-english.tar.gz \
	&& tar xfz phpMyAdmin-latest-english.tar.gz -C /$USER && \
	rm phpMyAdmin-latest-english.tar.gz && mv -f /$USER/phpMyAd* /$USER/phpmyadmin \
	&& cp /$USER/phpmyadmin/config.sample.inc.php /$USER/phpmyadmin/config.inc.php \
	&& chown -R $USER:$USER /$USER/phpmyadmin && chmod 700 /$USER/phpmyadmin/config.inc.php \
	&& sed -i "s/blowfish_secret'] = ''/blowfish_secret'] = 'mysecretpassword'/1" /$USER/phpmyadmin/config.inc.php \
	&& sed -i "s/localhost/$HOSTNAME/1" /$USER/phpmyadmin/config.inc.php \
	&& mv -f /$USER/phpmyadmin /var/www && rm -rf /$USER

RUN sed -i "s|;listen.owner\s*=\s*nobody|listen.owner = ${PHP_FPM_USER}|g" /etc/php7/php-fpm.d/$USER.conf && \
	sed -i "s|;listen.group\s*=\s*nobody|listen.group = ${PHP_FPM_GROUP}|g" /etc/php7/php-fpm.d/$USER.conf && \
	sed -i "s|;listen.mode\s*=\s*0660|listen.mode = ${PHP_FPM_LISTEN_MODE}|g" /etc/php7/php-fpm.d/$USER.conf && \
	sed -i "s|user\s*=\s*nobody|user = ${PHP_FPM_USER}|g" /etc/php7/php-fpm.d/$USER.conf && \
	sed -i "s|group\s*=\s*nobody|group = ${PHP_FPM_GROUP}|g" /etc/php7/php-fpm.d/$USER.conf && \
	sed -i "s|;log_level\s*=\s*notice|log_level = notice|g" /etc/php7/php-fpm.d/$USER.conf && \
	sed -i "s|display_errors\s*=\s*Off|display_errors = ${PHP_DISPLAY_ERRORS}|i" /etc/php7/php.ini && \
	sed -i "s|display_startup_errors\s*=\s*Off|display_startup_errors = ${PHP_DISPLAY_STARTUP_ERRORS}|i" /etc/php7/php.ini && \
	sed -i "s|error_reporting\s*=\s*E_ALL & ~E_DEPRECATED & ~E_STRICT|error_reporting = ${PHP_ERROR_REPORTING}|i" /etc/php7/php.ini && \
	sed -i "s|;*memory_limit =.*|memory_limit = ${PHP_MEMORY_LIMIT}|i" /etc/php7/php.ini && \
	sed -i "s|;*upload_max_filesize =.*|upload_max_filesize = ${PHP_MAX_UPLOAD}|i" /etc/php7/php.ini && \
	sed -i "s|;*max_file_uploads =.*|max_file_uploads = ${PHP_MAX_FILE_UPLOAD}|i" /etc/php7/php.ini && \
	sed -i "s|;*post_max_size =.*|post_max_size = ${PHP_MAX_POST}|i" /etc/php7/php.ini && \
	sed -i "s|;*cgi.fix_pathinfo=.*|cgi.fix_pathinfo= ${PHP_CGI_FIX_PATHINFO}|i" /etc/php7/php.ini

EXPOSE 5000

WORKDIR /

ENTRYPOINT ["/bin/sh"]

CMD ["launch_phpmyadmin.sh"]
