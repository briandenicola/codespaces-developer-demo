#!/bin/bash

cd ../infrastructure

export APPLICATION_URI=`terraform output APPLICATION_URI | tr -d \"` 
export APPLICATION_URI_IP=`kubectl -n app-routing-system get service nginx -o jsonpath={.status.loadBalancer.ingress[].ip}` 

echo Testing ${APPLICATION_URI} at ${APPLICATION_URI_IP}:443
curl -k https://${APPLICATION_URI_IP}/api/os -H "Host: ${APPLICATION_URI}"

# TBD - Add playwright test suite