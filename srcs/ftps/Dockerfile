FROM alpine

RUN apk update && apk add vsftpd --no-cache && \
	apk add telegraf --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --allow-untrusted --no-cache

ARG USER
ARG PASS
ARG IP
ARG HOST

COPY srcs/vsftpd_pasv.conf /etc/vsftpd/vsftpd.conf
COPY srcs/launch_ftps.sh /launch_ftps.sh
COPY srcs/telegraf.conf /etc/telegraf.conf

RUN echo -e "$PASS\n$PASS" | adduser --shell /sbin/nologin $USER && \
	sed -i "s/__USER__/$USER/" /etc/telegraf.conf && \
	sed -i "s/__PASS__/$PASS/" /etc/telegraf.conf && \
    sed -i "s/__HOST__/$HOST/" /etc/telegraf.conf && \
	sed -i "s/__USER__/$USER/" /etc/vsftpd/vsftpd.conf && \
	sed -i "s/__IP__/$IP/" /etc/vsftpd/vsftpd.conf

WORKDIR /home/$USER

EXPOSE 21

CMD /bin/sh /launch_ftps.sh

# To acccess:	from browser	ftp://container_ip_address
#				from terminal	ftp-ssl container_ip_address
# References
#https://wiki.alpinelinux.org/wiki/FTP
#https://www.youtube.com/watch?v=TrTrTHALWjg
#https://github.com/delfer/docker-alpine-ftp-server
