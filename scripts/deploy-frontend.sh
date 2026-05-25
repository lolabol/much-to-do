#!/bin/bash
echo "Deploying frontend to S3..."

# Variables
S3_BUCKET=$1
CLOUDFRONT_ID=$2

if [ -z "$S3_BUCKET" ] || [ -z "$CLOUDFRONT_ID" ]; then
  echo "Usage: ./deploy-frontend.sh <s3-bucket-name> <cloudfront-id>"
  exit 1
fi

# Build frontend
echo "Building frontend..."
cd ../Client
npm ci
npm run build

# Sync to S3
echo "Syncing to S3..."
aws s3 sync dist/ s3://$S3_BUCKET --delete

# Invalidate CloudFront
echo "Invalidating CloudFront cache..."
aws cloudfront create-invalidation \
  --distribution-id $CLOUDFRONT_ID \
  --paths "/*"

echo "Frontend deployed successfully!"
