# StartTech Application

## Overview
StartTech is a full-stack application consisting of a React
frontend and Golang backend API, with MongoDB for data
persistence and Redis for caching.

## Repository Structure
starttech-application/
├── .github/
│   └── workflows/
│       ├── frontend-ci-cd.yml
│       └── backend-ci-cd.yml
├── Client/
│   ├── src/
│   ├── public/
│   ├── package.json
│   └── vite.config.ts
├── Server/
│   └── MuchToDo/
│       ├── cmd/
│       ├── internal/
│       ├── Dockerfile
│       └── go.mod
├── scripts/
│   ├── deploy-frontend.sh
│   ├── deploy-backend.sh
│   ├── health-check.sh
│   └── rollback.sh
└── README.md

## Prerequisites
- Node.js v18 or higher
- Go v1.21 or higher
- Docker
- AWS CLI
- MongoDB Atlas account

## Local Development

### Frontend
cd Client
npm install
npm run dev

Access at: http://localhost:5173

### Backend
cd Server/MuchToDo
go mod download
go run cmd/main.go

Access at: http://localhost:8080

## Environment Variables

### Frontend
VITE_API_URL=http://localhost:8080

### Backend
MONGODB_URI=mongodb+srv://username:password@cluster.mongodb.net/dbname
REDIS_URL=localhost:6379
PORT=8080

## CI/CD Pipelines

### Frontend Pipeline
Triggers on push to feature/full-stack branch
when changes are made in Client/ folder.

Steps:
1. Install dependencies
2. Run security scan
3. Build React app
4. Sync to S3
5. Invalidate CloudFront cache

### Backend Pipeline
Triggers on push to feature/full-stack branch
when changes are made in Server/ folder.

Steps:
1. Run Go tests
2. Run code quality checks
3. Build Docker image
4. Scan image with Trivy
5. Push to ECR
6. Trigger ASG rolling update
7. Run smoke tests

## Required GitHub Secrets
- AWS_ACCESS_KEY_ID
- AWS_SECRET_ACCESS_KEY
- S3_BUCKET_NAME
- CLOUDFRONT_DISTRIBUTION_ID
- VITE_API_URL
- ALB_DNS_NAME

## Deployment

### Deploy Frontend manually
./scripts/deploy-frontend.sh <s3-bucket-name> <cloudfront-id>

### Deploy Backend manually
./scripts/deploy-backend.sh <ecr-repository-url>

### Health Check
./scripts/health-check.sh <alb-dns-name>

### Rollback
./scripts/rollback.sh <ecr-repository-url> <previous-image-tag>
