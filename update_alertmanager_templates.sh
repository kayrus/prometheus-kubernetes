#!/bin/sh

CDIR=$(cd `dirname "$0"` && pwd)
cd "$CDIR"

NAMESPACE="monitoring"

kubectl ${CONTEXT} --namespace="${NAMESPACE}" apply --record -f alertmanager-templates-configmap.yaml &
echo "Waiting for configmap volume to be updated..."
kubectl ${CONTEXT} --namespace="${NAMESPACE}" exec $(kubectl ${CONTEXT} --namespace="${NAMESPACE}" get pods -l app=alertmanager -o jsonpath={.items..metadata.name}) -- sh -c 'A=`stat -Lc %Z /etc/alertmanager-templates/..data`; while true; do B=`stat -Lc %Z /etc/alertmanager-templates/..data` ; [ $A != $B ] && break || echo -n "." && sleep 0.5; done; killall -HUP alertmanager'
echo "Updated"
