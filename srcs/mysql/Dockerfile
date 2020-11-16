FROM alpine

RUN apk update && apk add mysql mysql-client expect --no-cache && \
	apk add telegraf --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --allow-untrusted --no-cache

ARG USER
ARG PASS
ARG HOST
ARG IP
ARG DATABASE

ENV ROOT_PASSWORD="$PASS" DATABASE="$DATABASE" IP="$IP" ADMIN="$USER" \
	ADMIN_PW="$PASS" \
	INSERTOR="insertor" INSERTOR_PW="password" DELETOR="deletor" \
	DELETOR_PW="password" CREATOR="creator" CREATOR_PW="password" \
	DROPTOR="droptor" DROPTOR_PW="password" SELECTOR="selector" \
	SELECTOR_PW="password" UPDATOR="updator" UPDATOR_PW="password" \
	GRANTOR="grantor" GRANTOR_PW="password"

COPY srcs/my.cnf /etc/mysql/my.cnf
COPY srcs/telegraf.conf /etc/telegraf.conf
COPY srcs/launch_mysql.sh /home/launch_mysql.sh

RUN sed -i "s/__USER__/$USER/" /etc/telegraf.conf && \
	sed -i "s/__PASS__/$PASS/" /etc/telegraf.conf && \
	sed -i "s/__HOST__/$HOST/" /etc/telegraf.conf

EXPOSE 3306

WORKDIR /home

ENTRYPOINT ["/bin/sh"]

CMD ["launch_mysql.sh"]
