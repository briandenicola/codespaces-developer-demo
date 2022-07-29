.PHONY: help all create creds manifests container

help :
	@echo "Usage:"
	@echo "   make all              - create a cluster and deploy the apps "
	@echo "   make cluster          - create a AKS cluster "
	@echo "   make delete           - delete the AKS cluster "
	@echo "   make creds            - gets AKS credential files "
	@echo "   make manifests        - generates application manifests "
	@echo "   make container        - builds docker container "

all : create creds manifests container

delete :
	cd infrastructure &&  terraform destroy -auto-approve

cluster : 
	cd infrastructure && terraform init && terraform apply -auto-approve

creds : 
	cd infrastructure && export RG=`terraform output AKS_RESOURCE_GROUP` && export AKS=`terraform output AKS_CLUSTER_NAME` && \
	az aks get-credentials -g ${RG} -n ${AKS} &&  \
	kubelogin convert-kubeconfig -l azurecli

manifests :
	cd src && draft create

container : 
	cd src && docker build -t ${ACR_NAME}/whatos:latest . && \
	az acr login -n ${ACR_NAME} && \
	docker push ${ACR_NAME}/whatos:latest && \


