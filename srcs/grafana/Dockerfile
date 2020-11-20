FROM alpine

RUN apk update \
	&& apk add grafana --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing --no-cache \
	&& apk add telegraf --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --allow-untrusted --no-cache

ARG USER
ARG PASS
ARG HOST

COPY srcs/grafana.ini /usr/share/grafana/conf/custom.ini
COPY srcs/launch_grafana.sh /launch_grafana.sh
COPY srcs/telegraf.conf /etc/telegraf.conf
COPY srcs/provisioning /usr/share/grafana/conf/provisioning
COPY srcs/myDashboard /usr/share/grafana/myDashboard

RUN sed -i "s/__GRAF_USER__/$USER/g" /usr/share/grafana/conf/custom.ini \
	&& sed -i "s/__GRAF_PASS__/$PASS/g" /usr/share/grafana/conf/custom.ini \
	&& sed -i "s/__USER__/$USER/" /etc/telegraf.conf \
	&& sed -i "s/__PASS__/$PASS/" /etc/telegraf.conf \
	&& sed -i "s/__HOST__/$HOST/" /etc/telegraf.conf

EXPOSE 3000

WORKDIR /

CMD /bin/sh /launch_grafana.sh
