#!/bin/bash

# this runs at Codespace creation - not part of pre-build

echo "$(date)    post-create start" >> ~/status

# Install buildpacks
(curl -sSL "https://github.com/buildpacks/pack/releases/download/v0.27.0/pack-v0.27.0-linux.tgz" | sudo tar -C /usr/local/bin/ --no-same-owner -xzv pack)

# Install envsubst 
curl -Lso envsubst https://github.com/a8m/envsubst/releases/download/v1.2.0/envsubst-Linux-x86_64
sudo install envsubst /usr/local/bin
rm -rf ./envsubst

# Install draft
curl -Lso draft https://github.com/Azure/draft/releases/download/v0.0.22/draft-linux-amd64
sudo install draft /usr/local/bin/
rm -rf ./draft

# Install skaffold
curl -Lo skaffold https://storage.googleapis.com/skaffold/releases/latest/skaffold-linux-amd64
sudo install skaffold /usr/local/bin/
rm -rf skaffold 

# Install Playwright
npm install -g playwright@latest

# Update Kubelogin and kubectl
sudo az aks install-cli

# Add aks preview extensions
az extension add --name aks-preview

# update the base docker images
docker pull bjd145/utils:3.8

echo "$(date)    post-create complete" >> ~/status
