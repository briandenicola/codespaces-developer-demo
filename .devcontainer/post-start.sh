#!/bin/bash

# this runs each time the container starts

echo "$(date)    post-start start" >> ~/status
az extension update --name aks-preview
az --version >> ~/status 

echo "$(date)    Update azure cli" >> ~/status
az upgrade --yes

echo "$(date)    Turn off Skaffold metric collection " >> ~/status
skaffold config set --global collect-metrics false

echo "$(date)    post-start complete" >> ~/status