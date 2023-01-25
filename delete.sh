#!/bin/bash
helm uninstall prometheus -n monitoring
kubectl delete -f prometheus-pv.yaml
kubectl delete -f grafana-pv.yaml
