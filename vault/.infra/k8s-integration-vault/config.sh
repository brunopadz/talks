VAULT_ADDR="http://vault.mydomain.com"
TOKEN_REVIEW_JWT=$(kubectl get secret vault-auth -o go-template='{{ .data.token }}' | base64 --decode)
KUBE_CA_CERT=$(kubectl config view --raw --minify --flatten -o jsonpath='{.clusters[].cluster.certificate-authority-data}' | base64 --decode)
KUBE_HOST=$(kubectl config view --raw --minify --flatten -o jsonpath='{.clusters[].cluster.server}')

VAULT_ADDR=$VAULT_ADDR vault auth enable --path="k8s" kubernetes
VAULT_ADDR=$VAULT_ADDR vault write auth/k8s/config token_reviewer_jwt="$TOKEN_REVIEW_JWT" kubernetes_host="$KUBE_HOST" kubernetes_ca_cert="$KUBE_CA_CERT"
