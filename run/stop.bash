#!/bin/bash

# Arrêter les conteneurs
echo "Arrêt des conteneurs..."
docker compose -f compose.yml stop

echo "L'application est maintenant arrêté."