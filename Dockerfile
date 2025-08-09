FROM archlinux:latest

RUN pacman -Syu --noconfirm \
    lighttpd \
    certbot \
    bash \
    && pacman -Scc --noconfirm

EXPOSE 80

CMD ["lighttpd", "-D", "-f", "/etc/lighttpd/lighttpd.conf"]
