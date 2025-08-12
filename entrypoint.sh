#!/bin/bash

set -e

# start lighttpd in the background so certbot can use HTTP-01
echo "starting lighttpd..."
lighttpd -f /etc/lighttpd/lighttpd.conf
sleep 2

# request cert
echo "requesting SSL cert..."
bash /certbot-init.sh

# restart lighttpd to pick up new cert
echo "killing lighttpd..."
pkill lighttpd
sleep 1
echo "starting lighttpd..."
exec lighttpd -D -f /etc/lighttpd/lighttpd.conf
