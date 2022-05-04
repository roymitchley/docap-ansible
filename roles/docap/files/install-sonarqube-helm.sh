#!/bin/bash

helm repo add oteemo https://oteemo.github.io/charts/
helm repo update

NAMESPACE="tooling"

# Create a new namespace for our tool software
kubectl create namespace ${NAMESPACE}


# SonarQube
helm install my-sonar \
    -n ${NAMESPACE} \
    --version 9.1.0 \
    -f values/sonarqube-values.yml \
    oteemo/sonarqube


echo "Waiting 60 seconds"
sleep 60


SONARQUBE_URL=http://$(kubectl get svc --namespace ${NAMESPACE} my-sonar-sonarqube -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'):9000/

###########

echo "Creating desktop links"


cat << EOF > $HOME/Desktop/sonarqube-new.desktop
[Desktop Entry]
Encoding=UTF-8
Name=Link to SonarQube
Type=Link
URL=${SONARQUBE_URL}
Icon=text-html
EOF

###########

echo "Saving passwords to $HOME/Desktop/sonarqube.txt"

cat << EOF > $HOME/Desktop/sonarqube.txt
Summary

SonarQube
URL: ${SONARQUBE_URL}
Username: admin
Password: admin

EOF

echo "Job's a good 'n'"