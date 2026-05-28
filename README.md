# StartTech Application

## Overview
StartTech is a full-stack todo application consisting of a React frontend 
and Golang backend API, with MongoDB Atlas for data persistence and 
ElastiCache Redis for caching and session management.

## Live URLs

| Service | URL |
|---------|-----|
| Frontend | https://starttech-frontend.pages.dev |
| Backend API | http://starttech-alb-1520060583.us-east-1.elb.amazonaws.com |
| Health Check | http://starttech-alb-1520060583.us-east-1.elb.amazonaws.com/health |

## Repository Structure
```
starttech-application/
├── .github/
│   └── workflows/
│       ├── frontend-ci-cd.yml    # React build and S3 deploy
│       └── backend-ci-cd.yml     # Docker build and EC2 deploy
├── Client/                       # React frontend
│   ├── src/
│   ├── public/
│   ├── package.json
│   └── vite.config.ts
├── Server/
│   └── MuchToDo/                 # Golang backend
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
```

## Tech Stack
- **Frontend**: React + Vite, deployed to S3, served via CloudFlare Pages
- **Backend**: Golang (Gin framework), deployed to EC2 via Docker
- **Database**: MongoDB Atlas
- **Cache**: AWS ElastiCache Redis
- **Container Registry**: AWS ECR
- **Load Balancer**: AWS ALB

## Prerequisites
- Node.js v18 or higher
- Go v1.21 or higher
- Docker
- AWS CLI configured
- MongoDB Atlas account

## Local Development

### Frontend
```bash
cd Client
npm install
npm run dev
```
Access at: http://localhost:5173

### Backend
```bash
cd Server/MuchToDo
go mod download
go run cmd/api/main.go
```
Access at: http://localhost:8080

## Environment Variables

### Frontend
```
VITE_API_URL=http://localhost:8080
```

### Backend
```
MONGO_URI=mongodb+srv://username:password@cluster.mongodb.net/dbname
DB_NAME=muchtodo
JWT_SECRET_KEY=your-secret-key
REDIS_ADDR=localhost:6379
ENABLE_CACHE=false
PORT=8080
```

## CI/CD Pipelines

### Frontend Pipeline (`frontend-ci-cd.yml`)
Triggers on push to main when changes are made in `Client/` folder.

Steps:
1. Install Node.js dependencies
2. Run security scan (`npm audit`)
3. Build production React bundle
4. Sync build files to S3 bucket
5. Invalidate CloudFlare cache

### Backend Pipeline (`backend-ci-cd.yml`)
Triggers on push to main when changes are made in `Server/` folder.

Steps:
1. Run Go unit tests
2. Run code quality checks
3. Build Docker image
4. Scan image with Trivy for vulnerabilities
5. Push image to AWS ECR
6. Trigger ASG instance refresh (rolling update)
7. Run smoke tests against health endpoint

## Required GitHub Secrets

| Secret | Description |
|--------|-------------|
| `AWS_ACCESS_KEY_ID` | AWS access key |
| `AWS_SECRET_ACCESS_KEY` | AWS secret key |
| `S3_BUCKET_NAME` | S3 bucket for frontend |
| `ECR_REPOSITORY` | ECR repository URL |
| `ALB_DNS_NAME` | ALB DNS for smoke tests |
| `MONGO_URI` | MongoDB Atlas connection string |
| `DB_NAME` | MongoDB database name |
| `JWT_SECRET_KEY` | JWT signing secret |
| `REDIS_ADDR` | ElastiCache Redis address |
| `VITE_API_URL` | Backend API URL for frontend build |

## Manual Deployment

### Deploy Frontend
```bash
./scripts/deploy-frontend.sh <s3-bucket-name>
```

### Deploy Backend
```bash
./scripts/deploy-backend.sh <ecr-repository-url>
```

### Health Check
```bash
./scripts/health-check.sh starttech-alb-1520060583.us-east-1.elb.amazonaws.com
```

### Rollback Backend
```bash
./scripts/rollback.sh <ecr-repository-url> <previous-image-tag>
```

## Monitoring
- Application logs available in **CloudWatch** under `/starttech/backend`
- ALB health checks run every 30 seconds against `/health` endpoint
- Auto Scaling Group maintains between 1-3 EC2 instances

## Security
- All secrets stored in GitHub Actions secrets — never hardcoded
- Docker images scanned for vulnerabilities before deployment
- Backend only accessible through ALB — no direct EC2 access needed
- JWT authentication on all protected API endpoints
