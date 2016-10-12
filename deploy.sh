#!/bin/bash

CDIR=$(cd `dirname "$0"` && pwd)
cd "$CDIR"

print_red() {
  printf '%b' "\033[91m$1\033[0m\n"
}

print_green() {
  printf '%b' "\033[92m$1\033[0m\n"
}

CONTEXT=""
#CONTEXT="--context=foo"
NAMESPACE="monitoring"
EXTERNAL_URL=${EXTERNAL_URL:-https://prometheus.example.com}

kubectl ${CONTEXT} --namespace="${NAMESPACE}" create configmap external-url --from-literal=url=${EXTERNAL_URL} --dry-run -o yaml | kubectl ${CONTEXT} --namespace="${NAMESPACE}" apply -f -

print_green "Set ${EXTERNAL_URL} as an external url"

for yaml in *.yaml; do
  kubectl ${CONTEXT} --namespace="${NAMESPACE}" create -f "${yaml}"
done

kubectl ${CONTEXT} --namespace="${NAMESPACE}" get pods --watch
