#!/bin/bash

git clone -b develop --single-branch git://deluge-torrent.org/deluge.git
cd deluge

version=$(python3 version.py)
latest_tag_count=$(curl --silent https://hub.docker.com/v2/repositories/avatat/deluged/tags/?name="$version" | jq '.count')

if [ "$latest_tag_count" -gt 0 ]
then
    echo "Latest commit build is currently on Docker Hub. Exiting."
    exit 0
fi

cd ..

docker login -u avatat -p "$HUB_PASSWORD"
docker build -t avatat/deluged:"$version" -t avatat/deluged:latest .
docker push avatat/deluged:"$version"
docker push avatat/deluged:latest
