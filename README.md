# Overview

This repository is a demostration how to use GitHub CodeSpaces customized with DevContainers for modern application development. It leverages AKS plus its Web Application Routing feature and Skaffold. 

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
* skaffold can be configured to continuously monitor for any code changes. 
    * This will also open a port-forward from the kubernetes cluster to your local browser.
    * To test:
    ```golang
        source ./scripts/setup-env.sh
        cd manifests
        skaffold dev
        //Modify a line in main.go and watch the change get automatically push to the cluster
            var version string = "v1"
        //to 
            var version string = "v1.1"
    ```
* If you are using Codespaces, then after a restart, do:
    ```bash
        make refresh
    ```
    * This will add the Codespaces IP addres to the ACLs for Azure Container Registry, Key Vault and AKS
* If you want to re-generate any deployment manifests, do:
    ```bash
        make manifests
    ```
    * Sample Draft Answers:
        ```
        Modules: Yes
        Ports Expose: 8081
        Name of Application: whatos
        Deployment Type: kustomize
        ```

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
