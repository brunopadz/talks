# WIP

# Vault - Além do KV Store

> Os recursos criados não devem ser utilizados para ambientes produtivos!

## Pre-reqs

- Minikube / Kubernetes >= v1.20
- Helm

## Rodando

1. Construa a imagem e faça deploy para o Kubernetes com `make app`.
2. Suba a infra necessária com `make infra`. Esse comando fará deploy do Vault, External Secrets Operator e do Reloader.

