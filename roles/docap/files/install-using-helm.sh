#!/bin/bash

helm repo add stable https://charts.helm.sh/stable
helm repo add argo https://argoproj.github.io/argo-helm
helm repo add oteemo https://oteemo.github.io/charts/
helm repo add jenkins https://charts.jenkins.io
helm repo add grafana https://grafana.github.io/helm-charts
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add kube-state-metrics https://kubernetes.github.io/kube-state-metrics
helm repo update

# Create a new namespace for our tool software
kubectl create namespace tooling

# Jenkins
helm install my-jenkins \
    -n tooling \
    -f values/jenkins-values.yml \
    jenkins/jenkins

# SonarQube
# Using version 9.1.0 as 9.1.1 has bug in installin plugins
#     --version 9.1.0 \
helm install my-sonar \
    -n tooling \
    -f values/sonarqube-values.yml \
    oteemo/sonarqube

# Prometheus
helm install my-prometheus \
    -n tooling \
    -f values/prometheus-values.yml \
    prometheus-community/prometheus

# Grafana
helm install my-grafana \
    -n tooling \
    -f values/grafana-values.yml \
    grafana/grafana

# ArgoCD
helm install my-argocd \
   -n tooling \
   -f values/argocd-values.yml \
   argo/argo-cd

# Dashboard - Optional part of the course and done by hand
# helm install my-dashboard \
#     --namespace kube-system \
#     --set rbac.clusterAdminRole=true \
#     stable/kubernetes-dashboard

echo "Waiting 60 seconds"
sleep 60

# Drop creds to desktop (Split out to make it runnable by teammates in group)
./update-desktop-links.sh


################################################################



echo "Job's a good 'n'"
