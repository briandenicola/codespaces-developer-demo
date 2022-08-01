# Overview

This repository is a demostration of AKS's Web Application Routing feature when used with Skaffold and DevContainers. 

* [Web Application Routing](https://docs.microsoft.com/en-us/azure/aks/web-app-routing) is a developer tool that makes it easier for developers to create dev environments accessible for TLS.  
* [Skaffold](https://skaffold.dev/docs/) is a continous deployment tool used by developers to automate pushing changes to a Kubernetes cluster.  
* [DevContainers](https://containers.dev/) build consistent developer environments

# Quicksteps
```bash
az login --scope https://graph.microsoft.com/.default
make environment
```

## Notes
* This will create an AKS cluster and deploy code to it using Skaffold.
* Afterwards, skaffold will continue to monitor any changes to the kustomize deployment manifests or to the application source code.
* To try:
    * Modify the line in main.go and watch the change get automatically push to the cluster
        ```golang 
            var version string = "v1"
        ```
        to 
        ```golang 
            var version string = "v1.1"
        ```
* If you are using Codespaces, then after a restart, do:
    ```bash
    make refresh
    ```
    * This will add the Codespaces IP addres to the ACLs for Azure Container Registry and to AKS
* If you 
    * Please noote: draft will create an external load balancer in AKS which may or may not be allowed by policy. 
    * Sample Draft Answers:
        ```
        Modules: Yes
        Ports Expose: 8081
        Name of Application: whatos
        Deployment Type: kustomize
        ```

# Validate 
* Web Applciation Routing will create an external load balancer and configure an Nginx ingress configured with a self signed certificate
    * The Uri will be in the form of https://api.${random_pet}-${random_id}.local.
    * Add the hostname and IP to the /etc/host file 
    * Then 
        ```bash
            curl https://api.${random_pet}-${random_id}.local/api/os
        ```
* Skaffold is also set for port-forwading so the service can be accessible over localhost as well
# Backlog
- [X] Workload identity deployment
- [X] Developer namespace with OSM enabled 
- [X] Update for Web Application Routing 
- [ ] Update Documentation and examples
