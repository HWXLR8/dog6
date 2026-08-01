#!/bin/bash

set -e

renew_certs_forever() {
    while true; do
        sleep 12h
        echo "checking SSL cert renewal..."
        certbot renew \
            --webroot --webroot-path=/srv/http \
            --quiet \
            --deploy-hook "cat /etc/letsencrypt/live/dog6.net/privkey.pem /etc/letsencrypt/live/dog6.net/fullchain.pem > /etc/letsencrypt/live/dog6.net/lighttpd.pem && pkill -HUP lighttpd" \
            || echo "warning: certbot renew failed"
    done
}

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
echo "starting cert renewal loop..."
renew_certs_forever &
echo "starting lighttpd..."
exec lighttpd -D -f /etc/lighttpd/lighttpd.conf
