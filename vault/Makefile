#
# Configure GKE
#

configure-gke:
	@echo --------------------------------------
	@echo Creating resources to allow Vault
	@echo --------------------------------------
	kubectl apply -f .infra/k8s-integration-vault/resources.yml
	@echo --------------------------------------
	@echo Configuring GKE
	@echo --------------------------------------
	kubectl create clusterrolebinding cluster-admin-binding \
      --clusterrole cluster-admin \
      --user $$(gcloud config get-value account)

#
# Deploy apps
#

build-app-image:
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

build-consumer-image:
	@echo --------------------------------------
	@echo Building consumer image
	@echo --------------------------------------
	docker build ./consumer -f ./consumer/Dockerfile -t vault-demo-consumer:latest
	@echo
	@echo Done!

deploy-consumer:
	@echo --------------------------------------
	@echo Deploying consumer
	@echo --------------------------------------
	kubectl apply -f .infra/consumer/install.yml
	@echo
	@echo Done!

#
# Infra
#

deploy-busybox:
	kubectl apply -f .infra/busybox/provision.yaml

deploy-nginx:
	helm upgrade --install ingress-nginx ingress-nginx \
      --repo https://kubernetes.github.io/ingress-nginx \
      --namespace ingress-nginx --create-namespace

deploy-secrets-infra:
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
	helm install external-secrets external-secrets/external-secrets \
		-n external-secrets --create-namespace -f .infra/external-secrets/values.yaml
	@echo --------------------------------------
	@echo Installing Reloader
	@echo --------------------------------------
	helm install reloader stakater/reloader -n reloader --create-namespace
	@echo
	@echo Done!

#
# Vault
#

deploy-vault:
	@echo --------------------------------------
	@echo Installing Vault
	@echo --------------------------------------
	helm install vault hashicorp/vault -n vault --create-namespace -f .infra/vault/values.yml
	@echo
	@echo Done!

configure-vault-integration:
	@echo --------------------------------------
	@echo Configuring integration between Vault and Kubernetes
	@echo --------------------------------------
	.infra/k8s-integration-vault/config.sh
	@echo
	@echo Done!

configure-vault-secrets-paths:
	@echo --------------------------------------
	@echo Enabling secrets paths
	@echo --------------------------------------
	vault secrets enable -path=app kv-v2
	vault secrets enable database

configure-vault-auth:
	@echo --------------------------------------
	@echo Creating policy
	@echo --------------------------------------
	 vault policy write policy_app .infra/vault/policy.hcl
	@echo --------------------------------------
	@echo Creating policy
	@echo --------------------------------------
	 vault write auth/k8s/role/role_app \
            bound_service_account_names=sa-app \
            bound_service_account_namespaces=app,external-secrets \
            policies=policy_app \
            ttl=24h
	@echo --------------------------------------
	@echo Configure userpass auth method
	@echo --------------------------------------
	 vault auth enable userpass

configure-vault-pg:
	@echo --------------------------------------
	@echo Configure Vault database creds
	@echo --------------------------------------
     vault write database/config/pgsql \
    	allowed_roles="*" \
        plugin_name=postgresql-database-plugin \
        connection_url="postgres://{{username}}:{{password}}@pgsql-postgresql.default:5432" \
        username="postgres" \
        password="CxPYzeoLE5"

     vault write database/roles/pg_role \
        db_name=pgsql \
        creation_statements="CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}'; \
            GRANT SELECT ON ALL TABLES IN SCHEMA public TO \"{{name}}\";" \
        default_ttl="1h" \
        max_ttl="24h"

     vault write database/roles/lab \
        db_name=pgsql \
        creation_statements=@.infra/vault/readonly.sql \
        default_ttl=1m \
        rotation_period=86400

create-vault-user:
	@echo --------------------------------------
	@echo Creating user in Vault
	@echo --------------------------------------
     vault write auth/userpass/user1 \
    password=password1

## Helper
update-vault-config:
	@echo --------------------------------------
	@echo Updating Vault config
	@echo --------------------------------------
	helm upgrade vault hashicorp/vault -n vault --create-namespace -f .infra/vault/values.yml
	@echo
	@echo Done!

#
# Postgres
#

deploy-pgsql:
	@echo --------------------------------------
	@echo Deploy pgsql
	@echo --------------------------------------
	helm repo add bitnami https://charts.bitnami.com/bitnami
	helm install pgsql bitnami/postgresql -f .infra/pg/values.yaml

update-pgsql-config:
	@echo --------------------------------------
	@echo Updating pgsql config
	@echo --------------------------------------
	helm upgrade pgsql bitnami/postgresql -f .infra/pg/values.yaml
	@echo
	@echo Done!
