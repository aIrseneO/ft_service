#!/bin/sh
#
telegraf --config /etc/telegraf.conf &
exec grafana-server \
  --homepath="/usr/share/grafana" \
  --config="/usr/share/grafana/conf/custom.ini" \
  --packaging=docker "$@" \
  cfg:default.log.mode="console" \
  cfg:default.paths.data="/var/lib/grafana" \
  cfg:default.paths.logs="/var/log/grafana" \
  cfg:default.paths.plugins="/var/lib/grafana/plugins" \
  cfg:default.paths.provisioning="/usr/share/grafana/conf/provisioning"
