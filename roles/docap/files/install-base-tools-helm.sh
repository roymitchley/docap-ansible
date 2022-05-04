#!/bin/bash

helm repo add stable https://kubernetes-charts.storage.googleapis.com/
helm repo add argo https://argoproj.github.io/argo-helm
helm repo add oteemo https://oteemo.github.io/charts/
helm repo add jenkins https://charts.jenkins.io
helm repo add grafana https://grafana.github.io/helm-charts
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

# Create a new namespace for our tool software
kubectl create namespace tooling

# Jenkins
helm install my-jenkins \
    -n tooling \
    -f values/jenkins-values.yml \
    jenkins/jenkins

# ArgoCD
helm install my-argocd \
   -n tooling \
   -f values/argocd-values.yml \
   argo/argo-cd

echo "Waiting 60 seconds"
sleep 60

JENKINS_URL=http://$(kubectl get svc --namespace tooling my-jenkins --template "{{ range (index .status.loadBalancer.ingress 0) }}{{ . }}{{ end }}"):8080/login
JENKINS_PASSWORD=$(kubectl get secret --namespace tooling my-jenkins -o jsonpath="{.data.jenkins-admin-password}" | base64 --decode)

ARGOCD_URL=http://$(kubectl get svc --namespace tooling my-argocd-server -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
ARGOCD_PASSWORD=$(kubectl get pods --namespace tooling -l app.kubernetes.io/name=argocd-server -o name | cut -d'/' -f 2)

# echo "Creating DNS entries"
# cli53 rrcreate ${DOMAIN} 'prometheus AWS ALIAS A '"$PROMETHEUS_URL"' Z32O12XQLNTSW2 false' --replace

###########

echo "Creating desktop links"

cat << EOF > $HOME/Desktop/jenkins.desktop
[Desktop Entry]
Encoding=UTF-8
Name=Link to Jenkins
Type=Link
URL=${JENKINS_URL}
Icon=text-html
EOF

cat << EOF > $HOME/Desktop/argocd.desktop
[Desktop Entry]
Encoding=UTF-8
Name=Link to ArgoCD
Type=Link
URL=${ARGOCD_URL}
Icon=text-html
EOF

###########

echo "Saving passwords to $HOME/Desktop/passwords.txt"

cat << EOF > $HOME/Desktop/passwords.txt
Summary

Jenkins
URL: ${JENKINS_URL}
Username: admin
Password: ${JENKINS_PASSWORD}

ArgoCD
URL: ${ARGOCD_URL}
Username: admin
Password: ${ARGOCD_PASSWORD}

EOF

echo "Job's a good 'n'"