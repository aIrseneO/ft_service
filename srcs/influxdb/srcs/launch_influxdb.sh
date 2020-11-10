#! /bin/sh
#
influxd -config /etc/influxdb/influxdb.conf run
#
#influxd --tls-cert="/certs/cert.crt" --tls-key="/certs/cert.key"
