#!/bin/bash
helm upgrade prometheus -n monitoring . -f values.yaml
