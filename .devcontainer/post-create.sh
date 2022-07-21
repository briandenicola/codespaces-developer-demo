#!/bin/bash

# this runs at Codespace creation - not part of pre-build

echo "$(date)    post-create start" >> ~/status

# Install golang v18.4
export VERSION=1.18.4
curl -fsS https://dl.google.com/go/go${VERSION}.linux-amd64.tar.gz -o golang.tar.gz
sudo tar -xvf golang.tar.gz
sudo rm -rf /usr/local/go
rm -rf /tmp/golang.tar.gz
sudo mv go /usr/local/bin

# Install buildpacks
sudo add-apt-repository ppa:cncf-buildpacks/pack-cli
sudo apt-get update
sudo apt-get install pack-cli

# Install skaffold
curl -Lo skaffold https://storage.googleapis.com/skaffold/releases/latest/skaffold-linux-amd64
sudo install skaffold /usr/local/bin/

# update the base docker images
docker pull bjd145/utils:3.9

echo "$(date)    post-create complete" >> ~/status
