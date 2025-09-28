FROM archlinux:latest

RUN pacman -Syu --noconfirm \
    lighttpd \
    certbot \
    openssl \
    cgit \
    bash \
    && pacman -Scc --noconfirm

COPY lighttpd.conf /etc/lighttpd/lighttpd.conf
COPY cgit/cgitrc /etc/cgitrc
COPY cgit/cgit.css /usr/share/webapps/cgit/cgit.css
COPY certbot-init.sh /certbot-init.sh
COPY entrypoint.sh /entrypoint.sh

RUN mkdir -p /srv/http /etc/letsencrypt/live/dog6.net \
    # create dummy self-signed cert and key \
    && openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
       -keyout /etc/letsencrypt/live/dog6.net/dummy.key \
        -out /etc/letsencrypt/live/dog6.net/dummy.crt \
        -subj "/CN=dog6.net" \
    # combine them into lighttpd.pem \
    && cat /etc/letsencrypt/live/dog6.net/dummy.key \
        /etc/letsencrypt/live/dog6.net/dummy.crt > \
        /etc/letsencrypt/live/dog6.net/lighttpd.pem

EXPOSE 80 443

CMD ["lighttpd", "-D", "-f", "/etc/lighttpd/lighttpd.conf"]
