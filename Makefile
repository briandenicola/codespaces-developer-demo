.PHONY: help environment cluster creds refresh manifests skaffold

include ./scripts/setup-env.sh

help :
	@echo "Usage:"
	@echo "   make environment      - create a cluster and deploy the apps "
	@echo "   make refresh          - updates infrastructure"
	@echo "   make clean           	- delete the AKS cluster and cleans up"
	@echo "   make creds            - updates AKS credential files "
	@echo "   make manifests        - re-generates application manifests "
	@echo "   make skaffold         - starts up skaffold "

clean :
	cd infrastructure ;\
	rm -rf .terraform.lock.hcl .terraform terraform.tfstate terraform.tfstate.backup .terraform.tfstate.lock.info ;\
	az group delete -n $${RG} --yes || true

environment: infra creds skaffold

infra : 
	cd infrastructure ;\
	terraform init; terraform apply -auto-approve

refresh :
	cd infrastructure ;\
	az aks update -g $${RG} -n $${AKS} --api-server-authorized-ip-ranges "";\
	terraform apply -auto-approve

creds : 
	cd infrastructure ;\
	az aks get-credentials -g $${RG} -n $${AKS} ;\
	kubelogin convert-kubeconfig -l azurecli

manifests :
	cd src; draft create

skaffold : 
	az acr login -n $${SKAFFOLD_DEFAULT_REPO} ;\
	envsubst < manifests/overlays/templates/service.tmpl > manifests/overlays/dev-a/service.yaml ;\
	envsubst < manifests/overlays/templates/deployment.tmpl > manifests/overlays/dev-a/deployment.yaml ;\
	cd manifests ;\
	skaffold dev