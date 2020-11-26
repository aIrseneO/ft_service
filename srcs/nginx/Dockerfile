FROM alpine

RUN apk add nginx openssh supervisor --no-cache && \
	apk add telegraf --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --allow-untrusted --no-cache

ARG USER
ARG PASS
ARG HOST
ARG IP

COPY srcs/nginx.conf /etc/nginx/nginx.conf
COPY srcs/localhost.conf /etc/nginx/conf.d/localhost.conf
COPY srcs/telegraf.conf /etc/telegraf/telegraf.conf
COPY srcs/index.html /var/www/localhost
COPY srcs/supervisord.conf /etc/supervisord.conf

RUN adduser -D -g 'www' -h /home/www/ www && mkdir -p /etc/telegraf \
	&& echo "www:www" | chpasswd && ssh-keygen -A && mkdir -p /var/www \
	&& chown -R www:www /var/www && chown -R www:www /var/lib/nginx && \
	sed -i "s/__USER__/$USER/" /etc/telegraf/telegraf.conf && \
	sed -i "s/__PASS__/$PASS/" /etc/telegraf/telegraf.conf && \
	sed -i "s/__HOST__/$HOST/" /etc/telegraf/telegraf.conf && \
	sed -i "s/__IP__/$IP/g" /etc/nginx/conf.d/localhost.conf


WORKDIR /home/www

EXPOSE 80
EXPOSE 443
EXPOSE 22

CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisord.conf"]
