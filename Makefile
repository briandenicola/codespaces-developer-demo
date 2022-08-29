.PHONY: help environment cluster creds refresh manifests skaffold

help :
	@echo "Usage:"
	@echo "   make environment      - create a cluster and deploy the apps "
	@echo "   make refresh          - updates infrastructure "
	@echo "   make clean            - delete the AKS cluster and cleans up "
	@echo "   make creds            - updates AKS credential files "
	@echo "   make manifests        - re-generates application manifests "
	@echo "   make skaffold         - starts up skaffold "

clean :
	export RG=`terraform -chdir=./infrastructure output -raw AKS_RESOURCE_GROUP` ;\
	cd infrastructure ;\
	rm -rf .terraform.lock.hcl .terraform terraform.tfstate terraform.tfstate.backup .terraform.tfstate.lock.info ;\
	az group delete -n $${RG} --yes || true

environment: infra creds skaffold

infra : 
	terraform -chdir=./infrastructure init; terraform -chdir=./infrastructure apply -auto-approve

refresh :
	export RG=`terraform -chdir=./infrastructure output -raw AKS_RESOURCE_GROUP` ;\
	export AKS=`terraform -chdir=./infrastructure output -raw AKS_CLUSTER_NAME` ;\
	az aks update -g $${RG} -n $${AKS} --api-server-authorized-ip-ranges "";\
	terraform -chdir=./infrastructure apply -auto-approve

creds : 
	export RG=`terraform -chdir=./infrastructure output -raw AKS_RESOURCE_GROUP` ;\
	export AKS=`terraform -chdir=./infrastructure output -raw AKS_CLUSTER_NAME` ;\
	az aks get-credentials -g $${RG} -n $${AKS} ;\
	kubelogin convert-kubeconfig -l azurecli

manifests :
	cd src; draft create

skaffold :
	export SKAFFOLD_DEFAULT_REPO=`terraform -chdir=./infrastructure output -raw ACR_NAME` ;\
	export APPLICATION_URI=`terraform -chdir=./infrastructure output -raw APPLICATION_URI` ;\
	export CERTIFICATE_KV_URI=`terraform -chdir=./infrastructure output -raw CERTIFICATE_KV_URI` ;\
	export WORKLOAD_IDENTITY=`terraform -chdir=./infrastructure output -raw WORKLOAD_IDENTITY` ;\
	az acr login -n $${SKAFFOLD_DEFAULT_REPO} ;\
	envsubst < manifests/overlays/templates/service.tmpl > manifests/overlays/dev-a/service.yaml ;\
	envsubst < manifests/overlays/templates/deployment.tmpl > manifests/overlays/dev-a/deployment.yaml ;\
	cd manifests ;\
	skaffold dev