#!/bin/sh

CDIR=$(cd `dirname "$0"` && pwd)
cd "$CDIR"

kubectl create configmap grafana-import-dashboards --from-file=grafana-import-dashboards-configmap --output json --dry-run > grafana-configmap.yaml

kubectl create configmap prometheus-rules --from-file=prometheus-rules --output yaml --dry-run > prometheus-rules-configmap.yaml

kubectl create configmap alertmanager-templates --from-file=alertmanager-templates --output json --dry-run > alertmanager-templates-configmap.yaml
