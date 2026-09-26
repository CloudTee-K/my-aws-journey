# Project 07 - Containerize Application with Docker and Amazon ECS

## Overview

This project demonstrates how to containerize a multi-service web application with Docker and deploy it to AWS using Amazon ECR and Amazon ECS Fargate.

The application consists of:

- An Nginx frontend
- A Node.js/Express backend
- Amazon ECR for container image storage
- Amazon ECS Fargate for container orchestration
- An Application Load Balancer for traffic distribution and path-based routing
- Amazon CloudWatch for container logging
- ECS Service Auto Scaling for backend scalability

The project was first built and tested locally with Docker before being deployed to AWS.

---

## Architecture

### Local Docker Architecture

```text
Browser
   |
   | :8080
   v
Nginx Frontend Container
   |
   | Docker Network
   v
Node.js Backend Container
   |
   | :3000
   v
Express API
```

### AWS Architecture

```text
                         Internet
                            |
                            v
                Application Load Balancer
                            |
                 +----------+----------+
                 |                     |
                 | /                   | /api/*
                 v                     v
          Frontend Target        Backend Target
              Group                  Group
                 |                     |
          +------+------+       +------+------+
          |             |       |             |
          v             v       v             v
       Frontend       Frontend Backend       Backend
       Fargate        Fargate  Fargate       Fargate
       Task            Task     Task           Task
          |             |       |             |
          +------+------+       +------+------+
                 |                     |
                 +----------+----------+
                            |
                            v
                     CloudWatch Logs

Amazon ECR
    |
    +---- Frontend Image
    |
    +---- Backend Image
```

---

## AWS Services Used

| Service | Purpose |
|---|---|
| Amazon ECR | Stores private Docker images |
| Amazon ECS | Manages containerized services |
| AWS Fargate | Runs containers without managing EC2 servers |
| Application Load Balancer | Public entry point and path-based routing |
| CloudWatch Logs | Stores frontend and backend container logs |
| IAM | Provides ECS task execution permissions |
| Application Auto Scaling | Scales the backend ECS service |
| VPC | Provides application networking |
| Security Groups | Controls inbound and outbound network traffic |

---

## Application Components

### Backend

The backend was built using:

- Node.js
- Express.js

Endpoints:

```text
GET /
GET /health
GET /api/data
```

The `/health` endpoint is also used by the backend target group health check.

### Frontend

The frontend is served by Nginx.

It provides a simple interface that sends a request to:

```text
/api/data
```

and displays the response returned by the backend service.

---

## Docker Containerization

Separate Docker images were created for the frontend and backend.

### Backend Dockerfile

```dockerfile
FROM node:24-alpine

WORKDIR /app

COPY package*.json ./

RUN npm ci --omit=dev

COPY server.js ./

EXPOSE 3000

USER node

CMD ["node", "server.js"]
```

The backend container runs as the non-root `node` user.

### Frontend Dockerfile

```dockerfile
FROM nginx:alpine

COPY index.html /usr/share/nginx/html/index.html

COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
```

---

## Local Docker Testing

A custom Docker network was created:

```text
project07-network
```

The frontend and backend containers were connected to the network.

The application was tested through:

```text
http://localhost:8080
```

The frontend successfully retrieved data from the backend container.

---

## Amazon ECR

Two private repositories were created:

```text
project07-backend
project07-frontend
```

Image scanning on push was enabled.

The local Docker images were tagged and pushed to their respective ECR repositories.

No AWS credentials were embedded inside the container images.

---

## Amazon ECS

An ECS cluster was created:

```text
project07-cluster
```

Separate Fargate task definitions were registered for the frontend and backend.

Both task definitions use:

```text
Launch Type: Fargate
Network Mode: awsvpc
CPU: 256
Memory: 512 MiB
```

Container ports:

```text
Frontend: 80
Backend: 3000
```

---

## Application Load Balancer

An internet-facing Application Load Balancer was used as the public entry point.

Two target groups were configured:

```text
Frontend Target Group → Port 80
Backend Target Group  → Port 3000
```

Routing:

```text
/       → Frontend ECS Service
/api/*  → Backend ECS Service
```

Backend health checks use:

```text
/health
```

This allows the frontend and backend to operate as separate ECS services.

---

## High Availability

Both ECS services were configured to maintain two tasks.

Final validation:

```text
Backend  → Desired: 2 | Running: 2
Frontend → Desired: 2 | Running: 2
```

This provides service-level redundancy compared with running a single task.

---

## Backend Auto Scaling

ECS Service Auto Scaling was configured for the backend service.

Configuration:

```text
Minimum Capacity: 2 tasks
Maximum Capacity: 10 tasks
Metric: ECSServiceAverageCPUUtilization
Target CPU Utilization: 70%
Scale-Out Cooldown: 60 seconds
Scale-In Cooldown: 60 seconds
```

Scaling policy:

```text
project07-backend-cpu-scaling
```

This allows ECS to adjust backend capacity according to average CPU utilization while maintaining a minimum of two tasks.

---

## Monitoring and Logging

Separate CloudWatch log groups were created:

```text
/ecs/project07-backend
/ecs/project07-frontend
```

Log retention:

```text
7 days
```

CloudWatch played an important role in troubleshooting the frontend ECS deployment.

---

## Major Troubleshooting Scenario

The initial frontend ECS deployment repeatedly failed.

ECS reported:

```text
EssentialContainerExited
```

The frontend container exited with:

```text
ExitCode: 1
```

CloudWatch logs revealed:

```text
host not found in upstream "project07-backend-container"
```

### Root Cause

The original Nginx configuration used the backend Docker container hostname.

That hostname worked locally because both containers belonged to the same Docker network.

The AWS deployment used separate ECS services, so the local Docker hostname was not available.

### Solution

The production Nginx configuration was changed so that the Application Load Balancer handled API routing:

```text
/       → Frontend
/api/*  → Backend
```

The frontend image was rebuilt and pushed to ECR.

A new ECS deployment was forced.

The replacement tasks became healthy and the full application worked successfully through the ALB.

See:

```text
troubleshooting.md
```

for the complete troubleshooting history.

---

## Security Considerations

Security practices implemented in this project include:

- Private ECR repositories
- ECR image scanning on push
- No AWS credentials embedded in application code or Docker images
- ECS task execution through an IAM role
- Backend Docker container running as a non-root user
- Security-group-based traffic restrictions
- ECS application ports accepting inbound traffic from the ALB security group
- Separate frontend and backend services
- CloudWatch logging
- `.env` files excluded from Git
- `node_modules` excluded from Git
- Temporary AWS configuration files excluded from Git

---

## Cost-Conscious Architecture

This project was designed as a learning environment.

Fargate tasks were deployed in public subnets with public IP assignment so that they could retrieve required resources without introducing a NAT Gateway.

Inbound application traffic was still restricted using security groups so that the Application Load Balancer was the intended public entry point.

For production workloads, the ECS tasks would normally be moved to private subnets with controlled outbound connectivity using NAT or appropriate VPC endpoints.

---

## Production Improvements

A production version could include:

- HTTPS using AWS Certificate Manager
- Route 53 custom domain
- Private ECS subnets
- VPC endpoints
- AWS WAF
- Immutable image tags
- Image digest pinning
- Automated CI/CD
- Terraform infrastructure deployment
- CloudWatch alarms and dashboards
- Deployment rollback strategies
- Enhanced container vulnerability management

---

## Project Structure

```text
Project-07-Containerize-Application-Docker-ECS/
|
|-- app/
|   |-- backend/
|   |   |-- Dockerfile
|   |   |-- .dockerignore
|   |   |-- package.json
|   |   |-- package-lock.json
|   |   `-- server.js
|   |
|   `-- frontend/
|       |-- Dockerfile
|       |-- .dockerignore
|       |-- index.html
|       |-- nginx.conf
|
|-- .gitignore
|-- README.md
|-- architecture.md
|-- commands-used.md
|-- lessons-learned.md
|-- project-notes.md
`-- troubleshooting.md
```

---

## Documentation

Detailed documentation is available in:

- `project-notes.md` - chronological implementation notes
- `architecture.md` - local and AWS architecture
- `commands-used.md` - important PowerShell, Docker, and AWS CLI commands
- `troubleshooting.md` - problems, root causes, and fixes
- `lessons-learned.md` - technical lessons from the project

---

## Skills Demonstrated

This project demonstrates practical experience with:

- Docker
- Docker networking
- Node.js
- Express.js
- Nginx
- Amazon ECR
- Amazon ECS
- AWS Fargate
- Application Load Balancers
- Path-based routing
- IAM roles
- Security groups
- CloudWatch Logs
- ECS health checks
- High availability
- ECS Service Auto Scaling
- AWS CLI
- Windows PowerShell
- Cloud troubleshooting

---

## Project Result

The project successfully progressed through the complete container deployment lifecycle:

```text
Develop
   ↓
Containerize
   ↓
Test Locally
   ↓
Push to ECR
   ↓
Deploy to ECS Fargate
   ↓
Configure ALB Routing
   ↓
Monitor with CloudWatch
   ↓
Troubleshoot
   ↓
Scale for High Availability
   ↓
Configure Auto Scaling
   ↓
Validate
```

The final application successfully ran as separate frontend and backend ECS Fargate services behind an Application Load Balancer.

---

## Cleanup

AWS resources created for this project should be removed after validation to prevent unnecessary charges.

Resources include:

- ECS services
- ECS cluster
- Application Load Balancer
- Target groups
- ECR repositories
- CloudWatch log groups
- Project IAM role
- Project security groups
- Application Auto Scaling configuration

The default VPC and its default subnets must not be deleted.

---

## Disclaimer

This project was created for educational and portfolio purposes.

The architecture intentionally balances AWS learning objectives, security practices, and cost considerations. Additional controls would be required before using the design for a production workload.