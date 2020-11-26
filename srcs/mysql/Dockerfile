FROM alpine

RUN apk update && apk add mysql mysql-client supervisor --no-cache && \
	apk add telegraf --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --allow-untrusted --no-cache

ARG USER
ARG PASS
ARG HOST
ARG IP
ARG DATABASE

ENV ROOT_PASSWORD="$PASS" DATABASE="$DATABASE" IP="$IP" ADMIN="$USER" \
	ADMIN_PW="$PASS"

COPY srcs/my.cnf /etc/mysql/my.cnf
COPY srcs/telegraf.conf /etc/telegraf/telegraf.conf
COPY srcs/launch_mysql.sh /home/launch_mysql.sh
COPY srcs/mydatabase.sql /mydatabase.sql
COPY srcs/setup_database.sh /home/setup_database.sh
COPY srcs/supervisord.conf /etc/supervisord.conf

RUN sed -i "s/__USER__/$USER/" /etc/telegraf/telegraf.conf && \
	sed -i "s/__PASS__/$PASS/" /etc/telegraf/telegraf.conf && \
	sed -i "s/__HOST__/$HOST/" /etc/telegraf/telegraf.conf && \
	sed -i "s/__DATABASE__/$DATABASE/" /home/setup_database.sh && \
	sed -i "s/__IP__/$IP/g" /mydatabase.sql && \
	sed -i 's/skip-networking/#skip-networking/g' /etc/my.cnf.d/mariadb-server.cnf

EXPOSE 3306

WORKDIR /home

CMD /bin/sh launch_mysql.sh
