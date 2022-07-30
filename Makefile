.PHONY: help environment cluster creds refresh manifests skaffold

help :
	@echo "Usage:"
	@echo "   make environment      - create a cluster and deploy the apps "
	@echo "   make cluster          - create a AKS cluster and gets credentials"
	@echo "   make refresh		    - updates infrastructure"
	@echo "   make delete           - delete the AKS cluster "
	@echo "   make creds            - updates AKS credential files "
	@echo "   make manifests        - re-generates application manifests "
	@echo "   make skaffold         - starts up skaffold "

environment : cluster creds skaffold

delete :
	cd infrastructure; terraform destroy -auto-approve
	rm -rf infrastructure/.terraform* && rm -rf infrastructure/terraform.*

cluster : infrastructure creds

infrastructure : 
	cd infrastructure; terraform init; terraform apply -auto-approve

refresh :
	cd infrastructure; terraform apply -auto-approve

creds : 
	cd infrastructure; export RG=`terraform output AKS_RESOURCE_GROUP`; export AKS=`terraform output AKS_CLUSTER_NAME` ;\
	az aks get-credentials -g $${RG} -n $${AKS} ;\
	kubelogin convert-kubeconfig -l azurecli

manifests :
	cd src; draft create

skaffold : 
	cd infrastructure ;\ 
	export SKAFFOLD_DEFAULT_REPO=`terraform output ACR_NAME | tr -d \"` ;\
	export APPLICATION_URI=`terraform output APPLICATION_URI | tr -d \"` ;\
	export CERTIFICATE_KV_URI=`terraform output CERTIFICATE_KV_URI | tr -d \"` ;\
	export WORKLOAD_IDENTITY=`terraform output WORKLOAD_IDENTITY | tr -d \"` ;\
	cd .. ;\
	envsubst < skaffold/overlays/templates/service.tmpl > skaffold/overlays/dev-a/service.yaml ;\
	envsubst < skaffold/overlays/templates/deployment.tmpl > skaffold/overlays/dev-a/deployment.yaml ;\
	cd skaffold ;\
	skaffold dev