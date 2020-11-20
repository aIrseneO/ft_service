FROM alpine

RUN apk update && apk add mysql mysql-client --no-cache && \
	apk add telegraf --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --allow-untrusted --no-cache

ARG USER
ARG PASS
ARG HOST
ARG IP
ARG DATABASE

ENV ROOT_PASSWORD="$PASS" DATABASE="$DATABASE" IP="$IP" ADMIN="$USER" \
	ADMIN_PW="$PASS"

COPY srcs/my.cnf /etc/mysql/my.cnf
COPY srcs/telegraf.conf /etc/telegraf.conf
COPY srcs/launch_mysql.sh /home/launch_mysql.sh
COPY srcs/mydatabase.sql /mydatabase.sql
COPY srcs/import_database.sh /import_database.sh

RUN sed -i "s/__USER__/$USER/" /etc/telegraf.conf && \
	sed -i "s/__PASS__/$PASS/" /etc/telegraf.conf && \
	sed -i "s/__HOST__/$HOST/" /etc/telegraf.conf && \
	sed -i "s/__DATABASE__/$DATABASE/" /import_database.sh

EXPOSE 3306

WORKDIR /home

ENTRYPOINT ["/bin/sh"]

CMD ["launch_mysql.sh"]
