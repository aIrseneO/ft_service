#! /bin/sh
#
cp /certs/cert.key /etc/pure-ftpd.key
cp /certs/cert.crt /etc/pure-ftpd.pem
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/pure-ftpd.pem -out /etc/ssl/private/pure-ftpd.pem -subj "/CN=$IP" 
telegraf --config /etc/telegraf.conf &
pure-ftpd -j -Y 2 -p 21000:21000 -P $IP
