#!/bin/bash

echo "Vérification de l'application..."

systemctl is-active --quiet devops-app
SERVICE_OK=$?
curl -s http://localhost:8080 > /dev/null
CURL_OK=$?

if [ "$SERVICE_OK" -eq 0 ] && [ "$CURL_OK" -eq 0 ]; then
     echo "Application OK"
else
     echo "ERREUR : application indisponible"
fi
