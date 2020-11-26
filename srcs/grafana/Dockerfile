FROM alpine

RUN apk update \
	&& apk add grafana --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing --no-cache \
	&& apk add telegraf --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --allow-untrusted --no-cache \
	&& apk add supervisor --no-cache

ARG USER
ARG PASS
ARG HOST

COPY srcs/grafana.ini /usr/share/grafana/conf/custom.ini
COPY srcs/telegraf.conf /etc/telegraf/telegraf.conf
COPY srcs/provisioning /usr/share/grafana/conf/provisioning
COPY srcs/myDashboard /usr/share/grafana/myDashboard
COPY srcs/supervisord.conf /etc/supervisord.conf

RUN sed -i "s/__GRAF_USER__/$USER/g" /usr/share/grafana/conf/custom.ini \
	&& sed -i "s/__GRAF_PASS__/$PASS/g" /usr/share/grafana/conf/custom.ini \
	&& sed -i "s/__USER__/$USER/" /etc/telegraf/telegraf.conf \
	&& sed -i "s/__PASS__/$PASS/" /etc/telegraf/telegraf.conf \
	&& sed -i "s/__HOST__/$HOST/" /etc/telegraf/telegraf.conf

EXPOSE 3000

WORKDIR /

CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisord.conf"]
