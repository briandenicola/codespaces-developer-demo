#!/bin/bash

# this runs each time the container starts

echo "$(date)    post-start start" >> ~/status
az extension update --name aks-preview
echo -e "\e[34m»»» 💡 \e[32mVersion details: \e[39m$(az --version)" 

echo "$(date)    post-start complete" >> ~/status
