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
	@pushd
	@cd infrastructure
	@terraform destroy -auto-approve
	@popd

cluster : 
	@pushd
	@cd infrastructure
	@terraform init
	@terraform apply -auto-approve
	@popd

creds : cluster
	@pushd
	@cd infrastructure
	@export RG=`terraform output AKS_RESOURCE_GROUP`
	@export AKS=`terraform output AKS_CLUSTER_NAME`

	@az aks get-credentials --resource-group ${RG} --name ${AKS}
	@kubelogin convert-kubeconfig -l azurecli
	@popd

app :
	@pushd
	@cd src
	@draft create
	@skaffold dev 