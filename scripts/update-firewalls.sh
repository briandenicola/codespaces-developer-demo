#!/bin/bash

source ./scripts/setup-env.sh

# check if resource group variable is defined else exit

# check if logged into azure exit if not
az account show  >> /dev/null 2>&1
if [[ $? -ne 0 ]]; then
  echo "Please login to Azure before updating firewall rules"
fi

ip=$(curl -sS http://checkip.amazonaws.com/)

echo "Updating Azure Container Registry firewall to allow access from $ip"
az acr network-rule add --name ${ACR_NAME} --resource-group ${RG} --ip-address $ip

echo "Updating AKS firewall to allow access from $ip"
az aks update -n ${AKS} -g ${RG} --api-server-authorized-ip-ranges $ip