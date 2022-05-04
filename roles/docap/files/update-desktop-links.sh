#!/bin/bash

# Get and save links and credentials....

echo "Retrieveing Credentials"


JENKINS_URL=http://$(kubectl get svc --namespace tooling my-jenkins --template "{{ range (index .status.loadBalancer.ingress 0) }}{{ . }}{{ end }}"):8080/login
JENKINS_PASSWORD=$(kubectl get secret --namespace tooling my-jenkins -o jsonpath="{.data.jenkins-admin-password}" | base64 --decode)

SONARQUBE_URL=http://$(kubectl get svc --namespace tooling my-sonar-sonarqube -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'):9000/

PROMETHEUS_URL=http://$(kubectl get svc --namespace tooling my-prometheus-server -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')

GRAFANA_URL=http://$(kubectl get svc --namespace tooling my-grafana -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
GRAFANA_PASSWORD=$(kubectl get secret --namespace tooling my-grafana -o jsonpath="{.data.admin-password}" | base64 --decode)

ARGOCD_URL=http://$(kubectl get svc --namespace tooling my-argocd-server -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
ARGOCD_PASSWORD=$(kubectl get secret -n tooling argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)

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

cat << EOF > $HOME/Desktop/sonarqube.desktop
[Desktop Entry]
Encoding=UTF-8
Name=Link to SonarQube
Type=Link
URL=${SONARQUBE_URL}
Icon=text-html
EOF

cat << EOF > $HOME/Desktop/prometheus.desktop
[Desktop Entry]
Encoding=UTF-8
Name=Link to Prometheus
Type=Link
URL=${PROMETHEUS_URL}
Icon=text-html
EOF

cat << EOF > $HOME/Desktop/grafana.desktop
[Desktop Entry]
Encoding=UTF-8
Name=Link to Grafana
Type=Link
URL=${GRAFANA_URL}
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

SonarQube
URL: ${SONARQUBE_URL}
Username: admin
Password: admin

Prometheus
URL: ${PROMETHEUS_URL}
Username: Not needed
Password: Not needed

Grafana
URL: ${GRAFANA_URL}
Username: admin
Password: ${GRAFANA_PASSWORD}
EOF



echo "All Done."