#!/bin/bash

echo "Vérification de l'application..."

curl -s http://localhost:8080 > /dev/null

if [ $? -eq 0 ]; then
     echo "Application OK"
else
     echo "ERREUR : application indisponible"
fi
