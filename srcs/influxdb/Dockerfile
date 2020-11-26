FROM alpine

RUN apk update && apk add --no-cache influxdb supervisor \
	&& apk add telegraf --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --allow-untrusted --no-cache

ARG USER
ARG PASS
ARG HOST

COPY srcs/influxdb.conf /etc/influxdb/influxdb.conf
COPY srcs/telegraf.conf /etc/telegraf/telegraf.conf
COPY srcs/supervisord.conf /etc/supervisord.conf

RUN	sed -i "s/__USER__/$USER/" /etc/telegraf/telegraf.conf && \
	sed -i "s/__PASS__/$PASS/" /etc/telegraf/telegraf.conf && \
	sed -i "s/__HOST__/$HOST/" /etc/telegraf/telegraf.conf

EXPOSE 8086

WORKDIR /

CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisord.conf"]
