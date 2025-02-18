# Déploiement de l'application de vote avec Docker Swarm

## Introduction
Ce document décrit le processus de déploiement de l’application de vote distribuée avec Docker Swarm.
Il couvre l’installation du cluster, le déploiement des services et la gestion des réseaux et volumes.

## 1. Configuration du Cluster Docker Swarm

### 1.1 Initialisation du Swarm
Sur le nœud principal (manager), exécute la commande suivante pour initier le cluster : docker swarm init --advertise-addr <IP_MANAGER>

Note : Remplace `<IP_MANAGER>` par l’adresse IP du manager.

Cette commande affichera une clé de jonction pour ajouter des nœuds workers au cluster.

### 1.2 Ajouter des nœuds workers
Sur chaque nœud worker, exécute : docker swarm join --token <TOKEN> <IP_MANAGER>:2377

Note : Remplace `<TOKEN>` et `<IP_MANAGER>` avec les valeurs affichées lors de l'initialisation.

Pour vérifier que les nœuds sont bien ajoutés, exécute sur le manager : docker node ls

## 2. Déploiement de l’Application avec Docker Swarm

### 2.1 Convertir `docker-compose.yml` en `docker stack`
Docker Swarm utilise `docker stack deploy` pour orchestrer les services à partir d’un fichier Compose compatible Swarm.

Renomme ton fichier `compose.yml` en `docker-stack.yml`, et assure-toi que les services sont bien configurés pour Swarm.

### 2.2 Lancer l’application avec Docker Stack
Sur le nœud manager, exécute : docker stack deploy -c docker-stack.yml voting_app

Cela déploie tous les services définis dans `docker-stack.yml` sur le cluster Swarm.

Pour vérifier le statut des services : docker stack services voting_app

## 3. Configuration du fichier `docker-stack.yml`

### Exemple de `docker-stack.yml` optimisé pour Swarm :

```yaml
services:
  vote_app:
    image: voting-app_vote
    deploy:
      replicas: 2
      restart_policy:
        condition: on-failure
    ports:
      - "8080:8080"
    networks:
      - app_network
    environment:
      - REDIS_HOST=redis_db

  result_app:
    image: voting-app_result
    deploy:
      replicas: 2
      restart_policy:
        condition: on-failure
    ports:
      - "8888:8888"
    networks:
      - app_network
    environment:
      - POSTGRES_HOST=postgres_db

  worker_app:
    image: voting-app_worker
    deploy:
      replicas: 1
      restart_policy:
        condition: on-failure
    networks:
      - app_network
    environment:
      - REDIS_HOST=redis_db
      - POSTGRES_HOST=postgres_db

  redis_db:
    image: redis:latest
    deploy:
      replicas: 1
      restart_policy:
        condition: on-failure
    networks:
      - app_network
    volumes:
      - redis_data:/data

  postgres_db:
    image: postgres:latest
    deploy:
      replicas: 1
      restart_policy:
        condition: on-failure
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
      POSTGRES_DB: postgres
    networks:
      - app_network
    volumes:
      - postgres_data:/var/lib/postgresql/data

networks:
  app_network:
    driver: overlay

volumes:
  redis_data:
  postgres_data:
```

Ce fichier garantit :
- Réplication des services (`replicas` pour assurer la haute disponibilité)
- Redémarrage automatique en cas d’échec (`restart_policy`)
- Utilisation du réseau overlay pour la communication entre les services sur plusieurs nœuds

## 4. Gestion et Monitoring du Cluster

### 4.1 Vérifier les services en cours
docker service ls

### 4.2 Voir les logs d’un service
docker service logs voting_app_vote

### 4.3 Mise à jour d’un service
Si tu veux mettre à jour une image sans arrêter le service, utilise : docker service update --image voting-app_vote:latest voting_app_vote

### 4.4 Supprimer un stack Swarm
Pour supprimer complètement l’application du cluster : docker stack rm voting_app

## Conclusion
Ce guide t’a montré comment déployer l’application de vote avec Docker Swarm, gérer les nœuds, configurer un fichier `docker-stack.yml`, et surveiller l’état du cluster.

Tu es maintenant prêt à scaler et administrer ton application sur un environnement distribué !

