#!/bin/sh

chmod +x /exec/*.sh

mkdir -p /data

aria2c --conf-path=/conf/aria2.conf
