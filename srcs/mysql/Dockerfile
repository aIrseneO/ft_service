FROM alpine

ARG ROOT_PASSWORD
ARG DATABASE
ARG HOST
ARG ADMIN
ARG ADMIN_PW

ENV ROOT_PASSWORD="$ROOT_PASSWORD" DATABASE="$DATABASE" HOST="$HOST" \
	ADMIN="$ADMIN" ADMIN_PW="$ADMIN_PW" \
	INSERTOR="insertor" INSERTOR_PW="password" DELETOR="deletor" \
	DELETOR_PW="password" CREATOR="creator" CREATOR_PW="password" \
	DROPTOR="droptor" DROPTOR_PW="password" SELECTOR="selector" \
	SELECTOR_PW="password" UPDATOR="updator" UPDATOR_PW="password" \
	GRANTOR="grantor" GRANTOR_PW="password"

RUN apk update

RUN apk add mysql mysql-client expect --no-cache

COPY srcs/my.cnf /etc/mysql/my.cnf

COPY srcs/launch_mysql.sh /home/launch_mysql.sh

VOLUME /var/lib/mysql

EXPOSE 3306

WORKDIR /home

ENTRYPOINT ["/bin/sh"]

CMD ["launch_mysql.sh"]
