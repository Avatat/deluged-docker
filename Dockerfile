FROM debian:11-slim as build-image
RUN apt update && apt install -y \
closure-compiler \
git \
intltool \
python3-pip

RUN git clone -b develop git://deluge-torrent.org/deluge.git
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

COPY --from=build-image /root/.local /root/.local
ENTRYPOINT ["/root/.local/bin/deluged", "--do-not-daemonize"]
CMD ["--loglevel", "info", "--config" ,"/config"]
