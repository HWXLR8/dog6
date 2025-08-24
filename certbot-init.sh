#!/bin/sh

set -e

HOST=dog6.net
DOMAINS="dog6.net obese.dog6.net"
EMAIL=test@dog6.net

CERT_DIR="/etc/letsencrypt/live/$HOST"
FULLCHAIN="$CERT_DIR/fullchain.pem"
KEY="$CERT_DIR/privkey.pem"
PEM="$CERT_DIR/lighttpd.pem"

# function to check if the current cert is production
is_production_cert() {
    [ -f "$FULLCHAIN" ] || return 1
    issuer="$(openssl x509 -in "$FULLCHAIN" -noout -issuer)"
    echo "$issuer" | grep -q "Let's Encrypt" || return 1
    echo "$issuer" | grep -q "(STAGING)" && return 1
    return 0
}

# generate args so certbot will request a cert for each
# domain+subdomain
DOMAIN_ARGS=""
for d in $DOMAINS; do
    DOMAIN_ARGS="$DOMAIN_ARGS -d $d"
done

if is_production_cert; then
    echo "Production certificate already exists for $DOMAINS, skipping request"
else
    echo "Deleting existing certificate if exists..."
    rm -rfv /etc/letsencrypt/live/dog6.net || true
    rm -rfv /etc/letsencrypt/archive/dog6.net || true
    rm -rfv /etc/letsencrypt/renewal/dog6.net.conf || true
    echo "Requesting new production certificate for $DOMAINS..."
    certbot certonly \
            --webroot --webroot-path=/srv/http \
            $DOMAIN_ARGS \
            --email "$EMAIL" \
            --agree-tos --noninteractive
fi

# combine key and chain into lighttpd.pem
if [ -f "$KEY" ] && [ -f "$FULLCHAIN" ]; then
    cat "$KEY" "$FULLCHAIN" > "$PEM"
    echo "combined cert and key into $PEM"
else
    echo "error: could not find both key and fullchain.pem"
    exit 1
fi
