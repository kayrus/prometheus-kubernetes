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

INSTANCES=(daemonset/node-exporter job/grafana-import-dashboards deployment/alertmanager deployment/grafana deployment/prometheus-deployment service/alertmanager service/grafana service/prometheus-svc configmap/alertmanager configmap/alertmanager-templates configmap/grafana-import-dashboards configmap/prometheus-configmap configmap/prometheus-rules configmap/external-url)

for instance in ${INSTANCES[@]}; do
  kubectl ${CONTEXT} --namespace="${NAMESPACE}" delete "${instance}"
done

PODS=$(kubectl ${CONTEXT} --namespace="${NAMESPACE}" get pods -o name | awk '/^pod\/(alertmanager|grafana|prometheus-deployment|node-exporter)-/ {print $1}' | tr '\n' ' ')
while [ ! "${PODS}" = "" ]; do
  echo "Waiting 1 second for ${PODS}pods to shutdown..."
  sleep 1
  PODS=$(kubectl ${CONTEXT} --namespace="${NAMESPACE}" get pods -o name | awk '/^pod\/(alertmanager|grafana|prometheus-deployment|node-exporter)-/ {print $1}' | tr '\n' ' ')
done
