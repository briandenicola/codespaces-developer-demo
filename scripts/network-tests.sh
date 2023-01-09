#!/bin/bash

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
source ${SCRIPT_DIR}/setup-env.sh

export APPLICATION_URI_IP=`kubectl -n app-routing-system get service nginx -o jsonpath={.status.loadBalancer.ingress[].ip}` 

echo Testing ${APPLICATION_URI} at ${APPLICATION_URI_IP}:443
curl -vvk https://${APPLICATION_URI}/api/os --resolve ${APPLICATION_URI}:443:${APPLICATION_URI_IP}