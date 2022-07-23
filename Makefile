.PHONY: help all create delete deploy app

help :
	@echo "Usage:"
	@echo "   make all              - create a cluster and deploy the apps "
	@echo "   make cluster          - create a AKS cluster "
	@echo "   make delete           - delete the AKS cluster "
	@echo "   make creds            - gets AKS credential files "
	@echo "   make manifests        - generates application manifests "

all : create creds manifests 

delete :
	cd infrastructure &&  terraform destroy -auto-approve

cluster : 
	cd infrastructure && terraform init && terraform apply -auto-approve

creds : 
	cd infrastructure \&&
	export RG=`terraform output AKS_RESOURCE_GROUP` \&& 
	export AKS=`terraform output AKS_CLUSTER_NAME` \&& 
	az aks get-credentials -g ${RG} -n ${AKS} \&& 
	kubelogin convert-kubeconfig -l azurecli

manifests :
	cd src && draft create
