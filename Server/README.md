# MuchTodo - Backend Application

## Overview
MuchTodo is a Golang backend API connected to MongoDB, containerized with Docker and deployed to a local Kubernetes cluster using Kind. It provides basic CRUD operations for user management and includes a health check endpoint.

## Project Structure

container-assessment/
├── Dockerfile
├── docker-compose.yml
├── .dockerignore
├── kubernetes/
│   ├── namespace.yaml
│   ├── mongodb/
│   │   ├── mongodb-secret.yaml
│   │   ├── mongodb-configmap.yaml
│   │   ├── mongodb-pvc.yaml
│   │   ├── mongodb-deployment.yaml
│   │   └── mongodb-service.yaml
│   ├── backend/
│   │   ├── backend-secret.yaml
│   │   ├── backend-configmap.yaml
│   │   ├── backend-deployment.yaml
│   │   └── backend-service.yaml
│   └── ingress.yaml
├── scripts/
│   ├── docker-build.sh
│   ├── docker-run.sh
│   ├── k8s-deploy.sh
│   └── k8s-cleanup.sh
└── README.md


![](https://github.com/lolabol/much-to-do/blob/feature/backend-only/Server/tree.png?raw=true)



## Prerequisites
- Docker
- Docker Compose
- Kind (Kubernetes in Docker)
- Kubectl

## Phase 1: Docker Setup

### Build the Docker image
./scripts/docker-build.sh

![](https://github.com/lolabol/much-to-do/blob/feature/backend-only/Server/MuchToDo/evidence/docker%20compose%20build.png?raw=true)

docker images 

![](https://github.com/lolabol/much-to-do/blob/feature/backend-only/Server/MuchToDo/evidence/docker%20images.png?raw=true)

docker compose ps

![](https://github.com/lolabol/much-to-do/blob/feature/backend-only/Server/MuchToDo/evidence/docker%20compose%20ps.png?raw=true)

## Check Docker Logs 

docker compose logs

![](https://github.com/lolabol/much-to-do/blob/feature/backend-only/Server/MuchToDo/evidence/docker%20compose%20logs.png?raw=true)


### Run with Docker Compose
./scripts/docker-run.sh

Access the app at: http://localhost:8080

### Health Check via Docker
curl http://localhost:8080/health

## Phase 2: Kubernetes Deployment

### Create the Kind cluster
kind create cluster --name startuptech

![](https://github.com/lolabol/much-to-do/blob/feature/backend-only/Server/MuchToDo/evidence/kind%20get%20clusters.png?raw=true)

### Deploy to Kubernetes
./scripts/k8s-deploy.sh

### Verify deployment
kubectl get pods -n muchtodo
kubectl get services -n muchtodo

![](https://github.com/lolabol/much-to-do/blob/feature/backend-only/Server/MuchToDo/evidence/kubectl%20get%20pods.png?raw=true)

![](https://github.com/lolabol/much-to-do/blob/feature/backend-only/Server/MuchToDo/evidence/kubectl%20get%20services.png?raw=true)

### Access the application
The app is accessible via NodePort at:
curl http://172.18.0.2:30080/health

Expected response: Cache: ok, database: ok

![](https://github.com/lolabol/much-to-do/blob/feature/backend-only/Server/MuchToDo/evidence/App%20via%20docker%20compose.png?raw=true)

### Cleanup
./scripts/k8s-cleanup.sh

## Environment Variables

Variable        | Description
----------------|---------------------------
MONGO_URI       | MongoDB connection string
PORT            | Application port (default: 8080)

## Application Endpoints

Endpoint        | Method | Description
----------------|--------|------------------
/health         | GET    | Health check
/users          | GET    | Get all users
/users          | POST   | Create a user
/users/:id      | GET    | Get a user
/users/:id      | PUT    | Update a user
/users/:id      | DELETE | Delete a user

By Omolola Eyanuku -ALT/SOE/025/5119
