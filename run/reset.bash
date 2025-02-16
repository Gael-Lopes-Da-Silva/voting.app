#!/bin/bash
echo "Suppression des conteneurs et volumes..."
docker compose -f compose.yml down -v
echo "Suppression terminée."
