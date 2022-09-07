#!/bin/bash

cd ..

source ./scripts/setup-env.sh
export APPLICATION_URI_IP=`kubectl -n app-routing-system get service nginx -o jsonpath={.status.loadBalancer.ingress[].ip}` 

echo Testing ${APPLICATION_URI} at ${APPLICATION_URI_IP}:443
curl -k https://${APPLICATION_URI_IP}/api/os -H "Host: ${APPLICATION_URI}"