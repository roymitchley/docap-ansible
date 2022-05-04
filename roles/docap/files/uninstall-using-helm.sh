#!/bin/bash

# Jenkins
helm delete my-jenkins \
    -n tooling 

# SonarQube
helm delete my-sonar \
    -n tooling \

# Prometheus
helm delete my-prometheus \
    -n tooling \

# Grafana
helm delete my-grafana \
    -n tooling \

# ArgoCD
helm delete my-argocd \
   -n tooling \

# Delete namespace for our tool software
kubectl delete namespace tooling

echo "Creating desktop links"

rm $HOME/Desktop/jenkins.desktop

rm $HOME/Desktop/argocd.desktop

rm $HOME/Desktop/sonarqube.desktop

rm $HOME/Desktop/prometheus.desktop

rm $HOME/Desktop/grafana.desktop

rm $HOME/Desktop/passwords.txt

echo "Alle cleaned up'"