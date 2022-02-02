## deluged Docker image
This repository provides Docker image with [deluged](https://dev.deluge-torrent.org/wiki/UserGuide/ThinClient) - daemon part of [Deluge](https://deluge-torrent.org/) "ecosystem".

[Fresh image](https://hub.docker.com/repository/docker/avatat/deluged) is always available on [Docker Hub](https://hub.docker.com/repository/docker/avatat/deluged).

## How does it build?
The image builds every hour from the latest ["development" commit](https://git.deluge-torrent.org/deluge/log/?h=develop). To achieve this, I wrote simple [GitHub Action](https://github.com/Avatat/deluged-docker/blob/master/.github/workflows/docker-image.yml), which builds image using [this Dockerfile](https://github.com/Avatat/deluged-docker/blob/master/Dockerfile).

## How can I run it?
To run deluged using this image, you have to mount at least two volumes - one for torrent data and one for configuration (this has to be mounted as `/config`). You need to publish TCP port for remote management (Deluge desktop client, Deluge WebUI), in this case `58846`, and TCP/UDP ports for P2P traffic, in this case `60630`.
```
docker run -d --name deluged -p 58846:58846/tcp -p 60630:60630/tcp -p 60630:60630/udp -v /torrent/data:/torrent -v /torrent/config:/config avatat/deluged:latest
```

## The future

I plan to add more customization to the image and build stable releases in addition to dev builds.