#!/bin/sh

CDIR=$(cd `dirname "$0"` && pwd)
cd "$CDIR"

NAMESPACE=${NAMESPACE:-monitoring}
KUBECTL="kubectl ${KUBECTL_PARAMS} --namespace=\"${NAMESPACE}\""

eval "${KUBECTL} replace -f alertmanager-configmap.yaml" &
echo "Waiting for configmap volume to be updated..."
eval "${KUBECTL} exec $(eval "${KUBECTL} get pods -l app=alertmanager -o jsonpath={.items..metadata.name}") -- sh -c 'A=\`stat -Lc %Z /etc/alertmanager/..data\`; while true; do B=\`stat -Lc %Z /etc/alertmanager/..data\`; [ \$A != \$B ] && break || printf . && sleep 0.5; done; killall -HUP alertmanager'"
echo "Updated"
