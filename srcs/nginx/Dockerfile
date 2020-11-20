FROM myalpine

RUN apk add openssh --no-cache

ARG USER
ARG PASS
ARG HOST
ARG IP
ARG USR=www

COPY srcs/nginx.conf /etc/nginx/nginx.conf
COPY srcs/localhost.conf /etc/nginx/conf.d/localhost.conf
COPY srcs/telegraf.conf /etc/telegraf.conf
COPY srcs/launch_nginx.sh /home/$USR/launch_nginx.sh
COPY srcs/index.html /var/www/localhost

RUN adduser -D -g '$USR' -h /home/$USR/ $USR && mkdir /$USR \
	&& echo "$USR:$USR"|chpasswd && ssh-keygen -A \
	&& chown -R $USR:$USR /$USR && chown -R $USR:$USR /var/lib/nginx \
	&& mkdir -p /run/nginx && mkdir -p /run/php \
	&& sed -i "s/__USER__/$USER/" /etc/telegraf.conf \
	&& sed -i "s/__PASS__/$PASS/" /etc/telegraf.conf \
	&& sed -i "s/__HOST__/$HOST/" /etc/telegraf.conf \
	&& sed -i "s/__IP__/$IP/g" /etc/nginx/conf.d/localhost.conf

WORKDIR /home/$USR

EXPOSE 80

EXPOSE 22

EXPOSE 443

ENTRYPOINT ["/bin/sh"]

CMD ["launch_nginx.sh"]
