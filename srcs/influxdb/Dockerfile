FROM alpine

RUN apk update && apk add --no-cache influxdb \
	&& apk add telegraf --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --allow-untrusted --no-cache

ARG USER
ARG PASS
ARG HOST

COPY srcs/influxdb.conf /etc/influxdb/influxdb.conf
COPY srcs/telegraf.conf /etc/telegraf.conf
COPY srcs/database.sh /database.sh
COPY srcs/launch_influxdb.sh /launch_influxdb.sh

RUN sed -i "s/__USER__/$USER/" /database.sh && \
	sed -i "s/__PASS__/$PASS/" /database.sh && \
	sed -i "s/__USER__/$USER/" /etc/telegraf.conf && \
	sed -i "s/__PASS__/$PASS/" /etc/telegraf.conf && \
	sed -i "s/__HOST__/$HOST/" /etc/telegraf.conf

EXPOSE 8086

WORKDIR /

ENTRYPOINT ["/bin/sh"]

CMD ["launch_influxdb.sh"]
