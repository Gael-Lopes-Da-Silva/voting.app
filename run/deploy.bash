#!/bin/bash

# Arrêter et supprimer les anciens conteneurs
echo "Arrêt et suppression des anciens conteneurs..."
docker compose -f compose.yml down

echo "Lancement des nouveaux conteneurs avec Docker Compose..."
docker compose -f compose.yml up -d --build

echo "L'application est maintenant déployée avec Docker Compose."

# Option de reset total des conteneurs et volumes
echo "Création d'un script de reset..."
cat <<EOL > run/reset.bash
#!/bin/bash
echo "Suppression des conteneurs et volumes..."
docker compose -f compose.yml down -v
echo "Suppression terminée."
EOL
chmod +x run/reset.bash

echo "Tout est prêt !"
