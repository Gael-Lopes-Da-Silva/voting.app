# Deploying the Voting Application with Docker Swarm

## Introduction
This document describes the deployment process of the distributed voting application using Docker Swarm.
It covers the installation of the cluster, service deployment, and the management of networks and volumes.

## 1. Configuring the Docker Swarm Cluster

### 1.1 Initializing the Swarm
On the main node (manager), run the following command to initialize the cluster:

```sh
docker swarm init --advertise-addr <IP_MANAGER>
```

Note: Replace `<IP_MANAGER>` with the manager's IP address.

This command will display a join key to add worker nodes to the cluster.

### 1.2 Adding Worker Nodes
On each worker node, run:

```sh
docker swarm join --token <TOKEN> <IP_MANAGER>:2377
```

Note: Replace `<TOKEN>` and `<IP_MANAGER>` with the values displayed during initialization.

To verify that the nodes are successfully added, run the following on the manager:

```sh
docker node ls
```

## 2. Deploying the Application with Docker Swarm

### 2.1 Converting `docker-compose.yml` to `docker stack`
Docker Swarm uses `docker stack deploy` to orchestrate services from a Compose file compatible with Swarm.

Rename your `compose.yml` file to `docker-stack.yml` and ensure that services are properly configured for Swarm.

### 2.2 Deploying the Application with Docker Stack
On the manager node, run:

```sh
docker stack deploy -c docker-stack.yml voting_app
```

This deploys all services defined in `docker-stack.yml` across the Swarm cluster.

To check the status of the services:

```sh
docker stack services voting_app
```

## 3. Configuring the `docker-stack.yml` File

### Example of an Optimized `docker-stack.yml` for Swarm:

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
      - frontend
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
      - backend
    environment:
      - POSTGRES_HOST=postgres_db

  worker_app:
    image: voting-app_worker
    deploy:
      replicas: 1
      restart_policy:
        condition: on-failure
    networks:
      - frontend
      - backend
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
      - frontend
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
      - backend
    volumes:
      - postgres_data:/var/lib/postgresql/data

networks:
  frontend:
    name: frontend
    driver: overlay
  backend:
    name: backend
    driver: overlay

volumes:
  redis_data:
    name: redis_data
  postgres_data:
    name: postgres_data
```

This file ensures:
- Service replication (`replicas` to guarantee high availability)
- Automatic restart in case of failure (`restart_policy`)
- Use of the overlay network for communication between services across multiple nodes

## 4. Managing and Monitoring the Cluster

### 4.1 Checking Running Services

```sh
docker service ls
```

### 4.2 Viewing Logs of a Service

```sh
docker service logs voting_app_vote
```

### 4.3 Updating a Service
If you want to update an image without stopping the service, use:

```sh
docker service update --image voting-app_vote:latest voting_app_vote
```

### 4.4 Removing a Swarm Stack
To completely remove the application from the cluster:

```sh
docker stack rm voting_app
```

## Conclusion
This guide has shown you how to deploy the voting application with Docker Swarm, manage nodes, configure a `docker-stack.yml` file, and monitor the cluster state.

You are now ready to scale and administer your application in a distributed environment!
