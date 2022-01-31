FROM debian:11-slim as build-image
RUN apt update && apt install -y \
closure-compiler \
git \
intltool \
python3-pip

ADD deluge /deluge
WORKDIR "/deluge"
RUN pip install --user .

FROM debian:11-slim
RUN apt update && apt install -y \
python3-chardet \
python3-dbus \
python3-geoip \
python3-libtorrent \
python3-setuptools \
&& rm -rf /var/lib/apt/lists/*

COPY --from=build-image /root/.local /var/lib/deluge/.local

RUN groupadd --gid=999 --system deluge; \
    useradd  --gid deluge --home-dir=/var/lib/deluge --shell=/bin/false --system --uid=999 deluge; \
	chown -R deluge:deluge /var/lib/deluge
USER deluge

ENTRYPOINT ["/var/lib/deluge/.local/bin/deluged", "--do-not-daemonize"]
CMD ["--loglevel", "info", "--config" ,"/config"]
