#!/bin/bash
echo "Rolling back deployment..."

# Variables
ECR_REPOSITORY=$1
PREVIOUS_TAG=$2
ASG_NAME="starttech-asg"
AWS_REGION="us-east-1"

if [ -z "$ECR_REPOSITORY" ] || [ -z "$PREVIOUS_TAG" ]; then
  echo "Usage: ./rollback.sh <ecr-repository-url> <previous-image-tag>"
  exit 1
fi

# Tag previous image as latest
echo "Rolling back to previous image: $PREVIOUS_TAG..."
docker pull $ECR_REPOSITORY:$PREVIOUS_TAG
docker tag $ECR_REPOSITORY:$PREVIOUS_TAG $ECR_REPOSITORY:latest
docker push $ECR_REPOSITORY:latest

# Trigger rolling update with previous image
echo "Triggering rollback deployment..."
aws autoscaling start-instance-refresh \
  --auto-scaling-group-name $ASG_NAME \
  --preferences MinHealthyPercentage=50 \
  --region $AWS_REGION

echo "Rollback triggered successfully!"
echo "Monitor the ASG for deployment status."
