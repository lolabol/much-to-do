#!/bin/bash
echo "Cleaning up Kubernetes resources..."
kubectl delete -f kubernetes/backend/
kubectl delete -f kubernetes/mongodb/
kubectl delete -f kubernetes/namespace.yaml
echo "Cleanup complete!"
