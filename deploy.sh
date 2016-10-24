#!/bin/sh

CDIR=$(cd `dirname "$0"` && pwd)
cd "$CDIR"

print_red() {
  printf '%b' "\033[91m$1\033[0m\n"
}

print_green() {
  printf '%b' "\033[92m$1\033[0m\n"
}

#KUBECTL_PARAMS="--context=foo"
NAMESPACE=${NAMESPACE:-monitoring}
KUBECTL="kubectl ${KUBECTL_PARAMS} --namespace=\"${NAMESPACE}\""
EXTERNAL_URL=${EXTERNAL_URL:-https://prometheus.example.com}

eval "kubectl ${KUBECTL_PARAMS} create namespace \"${NAMESPACE}\""

eval "${KUBECTL} create configmap external-url --from-literal=url=${EXTERNAL_URL} --dry-run -o yaml" | eval "${KUBECTL} apply -f -"

print_green "Set ${EXTERNAL_URL} as an external url"

eval "${KUBECTL} create configmap grafana-import-dashboards --from-file=grafana-import-dashboards-configmap -o json --dry-run" | eval "${KUBECTL} apply -f -"
eval "${KUBECTL} create configmap prometheus-rules --from-file=prometheus-rules -o yaml --dry-run" | eval "${KUBECTL} apply -f -"
eval "${KUBECTL} create configmap alertmanager-templates --from-file=alertmanager-templates -o json --dry-run" | eval "${KUBECTL} apply -f -"

for yaml in *.yaml; do
  eval "${KUBECTL} create -f \"${yaml}\""
done

eval "${KUBECTL} get pods $@"
