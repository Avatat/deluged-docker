FROM debian:11-slim as build-image

ADD deluge /deluge
WORKDIR "/deluge"

RUN apt update && apt install -y --no-install-recommends \
    closure-compiler \
    git \
    intltool \
    python3-pip \
    && pip install --upgrade pip \
    && pip install --force-reinstall --no-cache-dir --user . chardet \
    && find /root/.local -name __pycache__ -exec rm -rf {} + \
    && chown -R 999:999 /root

FROM debian:11-slim

RUN apt update && apt install -y --no-install-recommends \
    ca-certificates \
    python3-libtorrent \
    && groupadd --gid=999 --system deluge \
    && useradd  --create-home --gid deluge --home-dir=/var/lib/deluge --system --uid=999 deluge \
    && rm -rf /var/lib/apt/lists/*

COPY --from=build-image /root/.local /var/lib/deluge/.local

USER deluge

ENTRYPOINT ["/var/lib/deluge/.local/bin/deluged", "--do-not-daemonize"]
CMD ["--loglevel", "info", "--config" ,"/config"]