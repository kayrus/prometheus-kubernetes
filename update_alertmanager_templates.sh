#!/bin/sh

CDIR=$(cd `dirname "$0"` && pwd)
cd "$CDIR"

#KUBECTL_PARAMS="--context=foo"
NAMESPACE=${NAMESPACE:-monitoring}
KUBECTL="kubectl ${KUBECTL_PARAMS} --namespace=\"${NAMESPACE}\""

eval "${KUBECTL} create configmap alertmanager-templates --from-file=alertmanager-templates -o json --dry-run" | eval "${KUBECTL} replace -f -" &
echo "Waiting for configmap volume to be updated..."
eval "${KUBECTL} exec $(eval "${KUBECTL} get pods -l app=alertmanager -o jsonpath={.items..metadata.name}") -- sh -c 'A=\`stat -Lc %Z /etc/alertmanager-templates/..data\`; while true; do B=\`stat -Lc %Z /etc/alertmanager-templates/..data\`; [ \$A != \$B ] && break || printf . && sleep 0.5; done; killall -HUP alertmanager'"
echo "Updated"
