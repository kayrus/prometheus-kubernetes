#!/bin/sh

CDIR=$(cd `dirname "$0"` && pwd)
cd "$CDIR"

#KUBECTL_PARAMS="--context=foo"
NAMESPACE=${NAMESPACE:-monitoring}
KUBECTL="kubectl ${KUBECTL_PARAMS} --namespace=\"${NAMESPACE}\""

eval "${KUBECTL} create configmap grafana-import-dashboards --from-file=grafana-import-dashboards-configmap -o json --dry-run" | eval "${KUBECTL} replace -f -"
echo "New dashboards will be applied only on new Grafana deployment"
