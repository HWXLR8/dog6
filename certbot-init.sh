#!/bin/sh

certbot certonly \
        --webroot --webroot-path=/srv/http \
        -d "$DOMAIN" \
        --email "$EMAIL" \
        --agree-tos --noninteractive \
        --server https://acme-staging-v02.api.letsencrypt.org/directory &&

    cat /etc/letsencrypt/live/"$DOMAIN"/privkey.pem \
        /etc/letsencrypt/live/"$DOMAIN"/fullchain.pem > \
        /etc/letsencrypt/live/"$DOMAIN"/lighttpd.pem
