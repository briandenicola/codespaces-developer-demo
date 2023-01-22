#!/bin/bash

# this runs each time the container starts

echo "$(date)    post-start start" >> ~/status
az extension update --name aks-preview
echo -e "\e[34m»»»\e[32mVersion details: \e[39m$(az --version)" 

echo "$(date)    Update Resource firewalls " >> ~/status
cd ${CODESPACE_VSCODE_FOLDER}
bash ./scripts/update-firewalls.sh

echo "$(date)    post-start complete" >> ~/status