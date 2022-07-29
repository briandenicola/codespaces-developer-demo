# Overview

# Quicksteps
1. make cluster (or make all)
1. make credentials
1. make manifests #Optional
    * draft will create an external load balancer in AKS which may or may not be allowed by policy. 
1. cd infrastructure && export SKAFFOLD_DEFAULT_REPO=`terraform output ACR_NAME | tr -d \"` && cd ..
1. cd src
1. skaffold dev
    * Can also do:
        ```
        cd infrastructure && export ACR_NAME=`terraform output ACR_NAME | tr -d \"` && cd ..
        make container 
        ```
1. utils && kubectl exec -it utils -- bash 
1. curl http://production-whatos.whatos/api/os

## Draft Answers 
    draft create
        Modules: Yes
        Ports Expose: 8081
        Name of Application: whatos
        Deployment Type: kustomize