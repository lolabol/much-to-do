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

## Prerequisites
- Docker
- Docker Compose
- Kind (Kubernetes in Docker)
- Kubectl

## Phase 1: Docker Setup

### Build the Docker image
./scripts/docker-build.sh

### Run with Docker Compose
./scripts/docker-run.sh

Access the app at: http://localhost:8080

### Health Check via Docker
curl http://localhost:8080/health

## Phase 2: Kubernetes Deployment

### Create the Kind cluster
kind create cluster --name startuptech

### Deploy to Kubernetes
./scripts/k8s-deploy.sh

### Verify deployment
kubectl get pods -n muchtodo
kubectl get services -n muchtodo

### Access the application
The app is accessible via NodePort at:
curl http://172.18.0.2:30080/health

Expected response: Cache: ok, database: ok

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
