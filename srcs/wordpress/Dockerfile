FROM myalpine

ARG USER
ARG PASS
ARG HOST1
ARG HOST2
ARG IP
ARG DATABASE
ARG USR=www

ENV PHP_FPM_USER="$USR" PHP_FPM_GROUP="$USR" \
	PHP_FPM_LISTEN_MODE="0660" PHP_MEMORY_LIMIT="512M" \
	PHP_MAX_UPLOAD="50M" PHP_MAX_FILE_UPLOAD="200" \
	PHP_MAX_POST="100M" PHP_DISPLAY_ERRORS="On" \
	PHP_DISPLAY_STARTUP_ERRORS="On" PHP_CGI_FIX_PATHINFO=0 \
	PHP_ERROR_REPORTING="E_COMPILE_ERROR\|E_RECOVERABLE_ERROR\|E_ERROR\|E_CORE_ERROR"

COPY srcs/nginx.conf /etc/nginx/nginx.conf
COPY srcs/localhost.conf /etc/nginx/conf.d/localhost.conf
COPY srcs/launch_wordpress.sh /launch_wordpress.sh
COPY srcs/telegraf.conf /etc/telegraf/telegraf.conf
COPY srcs/supervisord.conf /etc/supervisord.conf

RUN adduser -D -g '$USR' -h /home/$USR/ $USR && mkdir /$USR && \
	chown -R $USR:$USR /$USR && chown -R $USR:$USR /var/lib/nginx && \
	mkdir -p /run/nginx && mkdir -p /run/php

RUN wget http://wordpress.org/latest.tar.gz -O /$USR/wp.tar.gz \
	&& tar xfz /$USR/wp.tar.gz -C /$USR && rm -f /$USR/wp.tar.gz && \
	cp /$USR/wordpress/wp-config-sample.php /$USR/wordpress/wp-config.php \
	&& sed -i "s/database_name_here/$DATABASE/" /$USR/wordpress/wp-config.php \
	&& sed -i "s/username_here/$USER/" /$USR/wordpress/wp-config.php \
	&& sed -i "s/password_here/$PASS/" /$USR/wordpress/wp-config.php \
	&& sed -i "s/localhost/$HOST1/" /$USR/wordpress/wp-config.php \
	&& chown -R $USR:$USR /$USR/wordpress && chmod 700 /$USR/wordpress/wp-config.php \
	&& sed -i "s/__USER__/$USER/" /etc/telegraf/telegraf.conf \
	&& sed -i "s/__PASS__/$PASS/" /etc/telegraf/telegraf.conf \
	&& sed -i "s/__HOST__/$HOST2/" /etc/telegraf/telegraf.conf \
	&& sed -i "s/__IP__/$IP/" /etc/nginx/conf.d/localhost.conf


RUN sed -i "s|;listen.owner\s*=\s*nobody|listen.owner = ${PHP_FPM_USER}|g" /etc/php7/php-fpm.d/$USR.conf && \
	sed -i "s|;listen.group\s*=\s*nobody|listen.group = ${PHP_FPM_GROUP}|g" /etc/php7/php-fpm.d/$USR.conf && \
	sed -i "s|;listen.mode\s*=\s*0660|listen.mode = ${PHP_FPM_LISTEN_MODE}|g" /etc/php7/php-fpm.d/$USR.conf && \
	sed -i "s|user\s*=\s*nobody|user = ${PHP_FPM_USER}|g" /etc/php7/php-fpm.d/$USR.conf && \
	sed -i "s|group\s*=\s*nobody|group = ${PHP_FPM_GROUP}|g" /etc/php7/php-fpm.d/$USR.conf && \
	sed -i "s|;log_level\s*=\s*notice|log_level = notice|g" /etc/php7/php-fpm.d/$USR.conf && \
	sed -i "s|display_errors\s*=\s*Off|display_errors = ${PHP_DISPLAY_ERRORS}|i" /etc/php7/php.ini && \
	sed -i "s|display_startup_errors\s*=\s*Off|display_startup_errors = ${PHP_DISPLAY_STARTUP_ERRORS}|i" /etc/php7/php.ini && \
	sed -i "s|error_reporting\s*=\s*E_ALL & ~E_DEPRECATED & ~E_STRICT|error_reporting = ${PHP_ERROR_REPORTING}|i" /etc/php7/php.ini && \
	sed -i "s|;*memory_limit =.*|memory_limit = ${PHP_MEMORY_LIMIT}|i" /etc/php7/php.ini && \
	sed -i "s|;*upload_max_filesize =.*|upload_max_filesize = ${PHP_MAX_UPLOAD}|i" /etc/php7/php.ini && \
	sed -i "s|;*max_file_uploads =.*|max_file_uploads = ${PHP_MAX_FILE_UPLOAD}|i" /etc/php7/php.ini && \
	sed -i "s|;*post_max_size =.*|post_max_size = ${PHP_MAX_POST}|i" /etc/php7/php.ini && \
	sed -i "s|;*cgi.fix_pathinfo=.*|cgi.fix_pathinfo= ${PHP_CGI_FIX_PATHINFO}|i" /etc/php7/php.ini

EXPOSE 5050

WORKDIR /

CMD /bin/sh launch_wordpress.sh
