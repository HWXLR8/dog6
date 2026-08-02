# dog6

Docker setup for `dog6.net`.

It runs:

- `lighttpd` for static sites and HTTPS
- `cgit` at `git.dog6.net`
- `myr` to mirror selected source repositories into a Docker volume

## Hosts

- `dog6.net` serves `http/dog6.net`
- `obese.dog6.net` serves `http/obese`
- `git.dog6.net` serves mirrored Git repos with cgit

## Run

```sh
make run
```

Deploy in the background:

```sh
make deploy
```

Stop:

```sh
make stop
```

## Certificates

Certificates are managed by Certbot inside the `web-server` container.

On startup, the container:

1. starts `lighttpd` with an existing or dummy cert
2. requests/validates the Let's Encrypt cert
3. restarts `lighttpd`
4. starts a renewal loop that checks twice per day

The certificate is stored in the `dog6_certs` Docker volume.

## Git mirrors

The `myr` service clones and updates repositories into the `dog6_repos` Docker volume.

That volume is mounted read-only into the web container at `/srv/git`, where cgit scans it.
