#!/bin/bash
helm uninstall prometheus -n monitoring
sleep 5s
kubectl delete -f prometheus-pv.yaml
kubectl delete -f grafana-pv.yaml
