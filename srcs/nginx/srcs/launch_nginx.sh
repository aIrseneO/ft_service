#! /bin/sh/
#
# Start Telegraf, Php, Ssh and Nginx
telegraf --config /etc/telegraf.conf &
/usr/sbin/sshd &
nginx -g "pid /run/nginx/nginx.pid;"
#
# Check if nginx and php are up running
#ps aux | grep nginx
#ps aux | grep php
#
# References
#https://wiki.alpinelinux.org/wiki/Nginx
#https://www.nginx.com/resources/wiki/start/topics/tutorials/commandline/
#https://wiki.alpinelinux.org/wiki/Nginx_with_PHP#Configuration_of_PHP7
