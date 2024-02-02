#!/bin/bash
helm uninstall prometheus -n monitoring
sleep 10s
kubectl delete -f grafana-pv.yaml
kubectl delete pvc prometheus-prometheus-kube-prometheus-prometheus-db-prometheus-prometheus-kube-prometheus-prometheus-0 -n monitoring
kubectl delete -f prometheus-pv.yaml
