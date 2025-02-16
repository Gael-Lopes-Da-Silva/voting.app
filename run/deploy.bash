#!/bin/bash

# Arrêter et supprimer les anciens conteneurs
echo "Arrêt et suppression des anciens conteneurs..."
docker compose -f compose.yml down

echo "Lancement des nouveaux conteneurs avec Docker Compose..."
docker compose -f compose.yml up -d --build

echo "L'application est maintenant déployée avec Docker Compose."
