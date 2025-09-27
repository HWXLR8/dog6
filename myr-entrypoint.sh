#!/bin/sh
set -eu
apk add --no-cache git ca-certificates

mkdir -p /srv/git /myr
[ -d /myr/.git ] && git -C /myr pull --ff-only \
        || git clone --depth 1 https://github.com/HWXLR8/myr /myr

cd /myr
exec env MYR_DIR=/srv/git ./myr --daily
