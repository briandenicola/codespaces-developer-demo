.PHONY: help environment cluster creds refresh manifests skaffold

help :
	@echo "Usage:"
	@echo "   make environment      - create a cluster and deploy the apps "
	@echo "   make refresh          - updates infrastructure"
	@echo "   make clean           	- delete the AKS cluster and cleans up"
	@echo "   make creds            - updates AKS credential files "
	@echo "   make manifests        - re-generates application manifests "
	@echo "   make skaffold         - starts up skaffold "

clean :
	cd infrastructure; export RG=`terraform output AKS_RESOURCE_GROUP | tr -d \"` ;\
	rm -rf .terraform.lock.hcl .terraform terraform.tfstate terraform.tfstate.backup .terraform.tfstate.lock.info ;\
	az group delete -n $${RG} --yes || true

environment: infra creds skaffold

infra : 
	cd infrastructure; terraform init; terraform apply -auto-approve

refresh :
	cd infrastructure; export RG=`terraform output AKS_RESOURCE_GROUP | tr -d \"`; export AKS=`terraform output AKS_CLUSTER_NAME | tr -d \"` ;\
	az aks update -g $${RG} -n $${AKS} --api-server-authorized-ip-ranges "";\
	terraform apply -auto-approve

creds : 
	cd infrastructure; export RG=`terraform output AKS_RESOURCE_GROUP | tr -d \"`; export AKS=`terraform output AKS_CLUSTER_NAME | tr -d \"` ;\
	az aks get-credentials -g $${RG} -n $${AKS} ;\
	kubelogin convert-kubeconfig -l azurecli

manifests :
	cd src; draft create

skaffold : 
	cd infrastructure; export SKAFFOLD_DEFAULT_REPO=`terraform output ACR_NAME | tr -d \"` ;\
	export APPLICATION_URI=`terraform output APPLICATION_URI | tr -d \"` ;\
	export CERTIFICATE_KV_URI=`terraform output CERTIFICATE_KV_URI | tr -d \"` ;\
	export WORKLOAD_IDENTITY=`terraform output WORKLOAD_IDENTITY | tr -d \"` ;\
	cd .. ;\
	az acr login -n $${SKAFFOLD_DEFAULT_REPO} ;\
	envsubst < skaffold/overlays/templates/service.tmpl > skaffold/overlays/dev-a/service.yaml ;\
	#envsubst < skaffold/overlays/templates/deployment.tmpl > skaffold/overlays/dev-a/deployment.yaml ;\
	cd skaffold ;\
	skaffold dev