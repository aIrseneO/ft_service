FROM alpine

ARG USER

ARG PASSWORD

RUN apk update

RUN apk add vsftpd --no-cache

COPY srcs/vsftpd.conf /etc/vsftpd/vsftpd.conf

RUN echo -e "$PASSWORD\n$PASSWORD" | adduser --shell /sbin/nologin $USER

WORKDIR /home/$USER

EXPOSE 21

ENTRYPOINT /usr/sbin/vsftpd

CMD /etc/vsftpd/vsftpd.conf

# To acccess:	from browser	ftp://container_ip_address
#				from terminal	ftp-ssl container_ip_address
# References
#https://wiki.alpinelinux.org/wiki/FTP
#https://www.youtube.com/watch?v=TrTrTHALWjg
#https://github.com/delfer/docker-alpine-ftp-server
