#! /bin/sh
echo "CREATE DATABASE __DATABASE__;" | influx
echo "CREATE USER __USER__  WITH PASSWORD '__PASS__' WITH ALL PRIVILEGES;" | influx
