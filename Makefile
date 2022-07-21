.PHONY: help all create delete deploy app

help :
	@echo "Usage:"
	@echo "   make all              - create a cluster and deploy the apps "
	@echo "   make cluster          - create a AKS cluster "
	@echo "   make delete           - delete the AKS cluster "
	@echo "   make creds            - gets AKS credential files "
	@echo "   make app              - build and deploys the app "

all : create creds app

delete :
	@cd infrastructure
	@terraform init
	@terraform destroy -auto-approve

cluster : 
	@cd infrastructure
	@terraform init
	@terraform apply -auto-approve

creds : cluster
	@cd infrastructure
	@export RG=`terraform output AKS_RESOURCE_GROUP`
	@export AKS=`terraform output AKS_CLUSTER_NAME`

	@az aks get-credentials --resource-group ${RG} --name ${AKS}
	@kubelogin convert-kubeconfig -l azurecli

app : 
	@cd ../src
	draft create
	@skaffold dev 