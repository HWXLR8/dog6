#!/bin/sh

set -e

CERT_DIR="/etc/letsencrypt/live/$DOMAIN"
FULLCHAIN="$CERT_DIR/fullchain.pem"
KEY="$CERT_DIR/privkey.pem"
PEM="$CERT_DIR/lighttpd.pem"

# function to check if the current cert is a production Let's Encrypt
# cert
is_production_cert() {
    [ -f "$FULLCHAIN" ] || return 1
    issuer="$(openssl x509 -in "$FULLCHAIN" -noout -issuer)"
    # must contain "Let's Encrypt" but not "(STAGING)"
    echo "$issuer" | grep -q "Let's Encrypt" || return 1
    echo "$issuer" | grep -q "(STAGING)" && return 1
    return 0
}

if is_production_cert; then
    echo "production certificate for $DOMAIN already exists, skipping request"
else
    echo "deleting existing certificate if exists..."
    rm -rfv /etc/letsencrypt/live/$DOMAIN || true
    rm -rfv /etc/letsencrypt/archive/$DOMAIN || true
    rm -rfv /etc/letsencrypt/renewal/$DOMAIN.conf || true
    echo "requesting new production certificate for $DOMAIN..."
    certbot certonly \
            --webroot --webroot-path=/srv/http \
            -d "$DOMAIN" \
            --email "$EMAIL" \
            --agree-tos --noninteractive \
            # --server https://acme-v02.api.letsencrypt.org/directory
fi

# combine key and chain into lighttpd.pem
if [ -f "$KEY" ] && [ -f "$FULLCHAIN" ]; then
    cat "$KEY" "$FULLCHAIN" > "$PEM"
    echo "combined cert and key into $PEM"
else
    echo "error: could not find both key and fullchain.pem"
    exit 1
fi
