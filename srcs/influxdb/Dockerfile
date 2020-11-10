FROM alpine

RUN apk update && apk add --no-cache influxdb

ARG USER
ARG PASS
ARG DATABASE

COPY srcs/influxdb.conf /etc/influxdb/influxdb.conf

COPY srcs/database.sh /database.sh

RUN sed -i "s/__USER__/$USER/" /database.sh && \
	sed -i "s/__PASS__/$PASS/" /database.sh && \
	sed -i "s/__DATABASE__/$DATABASE/" /database.sh

COPY srcs/launch_influxdb.sh /launch_influxdb.sh

EXPOSE 8086

WORKDIR /

ENTRYPOINT ["/bin/sh"]

CMD ["launch_influxdb.sh"]
