app: build-image deploy-app

infra: deploy-vault deploy-infra

build-image:
	@echo --------------------------------------
	@echo Building app image
	@echo --------------------------------------
	docker build ./app -f ./app/Dockerfile -t vault-demo-app:latest
	@echo
	@echo Done!

deploy-app:
	@echo --------------------------------------
	@echo Deploying app
	@echo --------------------------------------
	kubectl apply -f .infra/app/install.yml
	@echo
	@echo Done!

deploy-infra:
	@echo --------------------------------------
	@echo Deploying external-secrets operator and reloader
	@echo --------------------------------------
	@echo
	@echo --------------------------------------
	@echo Adding Helm repositories
	@echo --------------------------------------
	helm repo add external-secrets https://charts.external-secrets.io
	helm repo add stakater https://stakater.github.io/stakater-charts
	helm repo update
	@echo --------------------------------------
	@echo Installing external-secrets operator
	@echo --------------------------------------
	helm install external-secrets external-secrets/external-secrets -n external-secrets --create-namespace --set installCRDs=true
	@echo --------------------------------------
	@echo Installing Reloader
	@echo --------------------------------------
	helm install reloader stakater/reloader -n reloader --create-namespace
	@echo
	@echo Done!

deploy-vault:
	@echo --------------------------------------
	@echo Installing Vault
	@echo --------------------------------------
	helm install vault hashicorp/vault -n vault --create-namespace -f .infra/vault/values.yml
	@echo
	@echo Done!

configure-k8s:
	@echo --------------------------------------
	@echo Creating resources to allow Vault
	@echo --------------------------------------
	kubectl apply -f .infra/k8s-integration-vault/resources.yml
	@echo
	@echo --------------------------------------
	@echo Configuring integration between Vault and Kubernetes
	@echo --------------------------------------
	.infra/k8s-integration-vault/config.sh
	@echo
	@echo Done!
