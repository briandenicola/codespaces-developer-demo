# Overview

This repository is a demostration on how to use GitHub CodeSpaces customized with DevContainers for modern application development. It leverages AKS plus its Web Application Routing feature and Skaffold. 

* [Web Application Routing](https://docs.microsoft.com/en-us/azure/aks/web-app-routing) is a developer tool that makes it easier for developers to create dev environments accessible for TLS.  
* [Skaffold](https://skaffold.dev/docs/) is a continous deployment tool used by developers to automate pushing changes to a Kubernetes cluster.  
* [DevContainers](https://containers.dev/) build consistent developer environments

# Quicksteps
## Complete Environment
> **_NOTE:_** `task up` will create all required Azure resources (locked down to the Codespace's current IP Address) then deploy code via `skaffold run`
```bash
    az login --scope https://graph.microsoft.com/.default
    task up
```

## Deploy Skaffold - Dev Mode
> **_NOTE:_** Dev Mode will continuously build, test, and deploy changes to your kubernetes cluster when your code changes 
```bash
    task skaffold -- dev
```

## Deploy Skaffold - Run Mode
> **_NOTE:_**  Run Mode will build, test, and deploy your code to your kubernetes cluster once
```bash
    task skaffold -- run
```

## Clean up
```bash
    task down
```

## Notes
* This will create an AKS cluster and deploy code to it using Skaffold.
* If you are using Codespaces, then after a restart, do:
    ```bash
        task update-firewalls
    ```
    * This will add the Codespaces IP addres to the ACLs for Azure Container Registry, Key Vault and AKS

# Validate 
* Skaffold will automtically run Golang Unit test cases and a Custom curl Test on each build/deploy 
* Web Applciation Routing will create an external load balancer and configure an Nginx ingress configured with a self signed certificate
    * The Uri will be in the form of https://api.${random_pet}-${random_id}.local.
        ```bash
            cd scripts
            ./network-tests.sh
        ```
* Skaffold is also set for port-forwading so the service can be accessible over localhost as well

# Backlog
- [X] Workload identity deployment
- [X] Developer namespace with OSM enabled 
- [X] Update for Web Application Routing 
- [X] Update Documentation and examples

# Issues
- [X] There is a current issue with Web Application Routing when using a custom Service Account
