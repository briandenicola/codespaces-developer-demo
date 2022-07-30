# Overview

TBD

# Quicksteps
```bash
make cluster

cd infrastructure
export SKAFFOLD_DEFAULT_REPO=`terraform output ACR_NAME | tr -d \"`
export APPLICATION_URI=`terraform output APPLICATION_URI | tr -d \"`
export CERTIFICATE_KV_URI=`terraform output CERTIFICATE_KV_URI | tr -d \"`
cd ../src
envsubst < ./base/service.tmpl > ./base/service.yaml
skaffold dev
```

## Notes
* draft will create an external load balancer in AKS which may or may not be allowed by policy. 

## Draft Answers 
    draft create
        Modules: Yes
        Ports Expose: 8081
        Name of Application: whatos
        Deployment Type: kustomize

# Backlog
- [] Workload identity deployment
- [] Developer namespace with OSM enabled 
