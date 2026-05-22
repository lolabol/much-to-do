#!/bin/bash
echo "Deploying to Kubernetes..."
kubectl apply -f kubernetes/namespace.yaml
kubectl apply -f kubernetes/mongodb/
kubectl apply -f kubernetes/backend/
echo "Waiting for pods to be ready..."
kubectl wait --for=condition=ready pod -l app=backend -n muchtodo --timeout=120s
echo "Deployment complete!"
echo "Access the app at http://172.18.0.2:8080"
