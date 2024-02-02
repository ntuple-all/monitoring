#!/bin/bash
rm -rf .git
kubectl apply -f prometheus-pv.yaml
kubectl apply -f grafana-pv.yaml
helm install prometheus . -n monitoring -f values.yaml
