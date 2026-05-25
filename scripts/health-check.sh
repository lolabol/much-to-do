#!/bin/bash
echo "Running health check..."

# Variables
ALB_DNS=$1

if [ -z "$ALB_DNS" ]; then
  echo "Usage: ./health-check.sh <alb-dns-name>"
  exit 1
fi

# Check health endpoint
MAX_RETRIES=5
RETRY_COUNT=0

while [ $RETRY_COUNT -lt $MAX_RETRIES ]; do
  RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" http://$ALB_DNS/health)

  if [ $RESPONSE -eq 200 ]; then
    echo "Health check passed! Application is running."
    exit 0
  else
    echo "Health check failed. Retrying in 10 seconds..."
    RETRY_COUNT=$((RETRY_COUNT + 1))
    sleep 10
  fi
done

echo "Health check failed after $MAX_RETRIES retries!"
exit 1
