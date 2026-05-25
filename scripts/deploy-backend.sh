#!/bin/bash
echo "Deploying backend to EC2..."

# Variables
ECR_REPOSITORY=$1
AWS_REGION="us-east-1"
ASG_NAME="starttech-asg"

if [ -z "$ECR_REPOSITORY" ]; then
  echo "Usage: ./deploy-backend.sh <ecr-repository-url>"
  exit 1
fi

# Build and push Docker image
echo "Building Docker image..."
cd ../Server/MuchToDo
docker build -t backend:latest .
docker tag backend:latest $ECR_REPOSITORY:latest

# Login to ECR
echo "Logging in to ECR..."
aws ecr get-login-password --region $AWS_REGION | \
  docker login --username AWS --password-stdin $ECR_REPOSITORY

# Push image
echo "Pushing image to ECR..."
docker push $ECR_REPOSITORY:latest

# Trigger rolling update
echo "Triggering rolling update..."
aws autoscaling start-instance-refresh \
  --auto-scaling-group-name $ASG_NAME \
  --preferences MinHealthyPercentage=50

echo "Backend deployment triggered successfully!"
