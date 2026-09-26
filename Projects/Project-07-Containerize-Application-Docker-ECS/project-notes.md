# Project 07 - Containerize Application with Docker and Amazon ECS

## Project Objective

The objective of this project was to containerize a multi-service web application using Docker and deploy it to AWS using Amazon ECR, Amazon ECS Fargate, an Application Load Balancer, CloudWatch Logs, and ECS Service Auto Scaling.

The project demonstrates containerization, container networking, image management, load balancing, high availability, monitoring, troubleshooting, and automatic scaling.

---

## Architecture

### Local Environment

Browser
→ Nginx Frontend Container
→ Node.js Backend Container

The containers communicated through a custom Docker network.

### AWS Environment

Internet
→ Application Load Balancer
→ Path-Based Routing

- `/` → Frontend Target Group → ECS Fargate Nginx Tasks
- `/api/*` → Backend Target Group → ECS Fargate Node.js Tasks

Container Images
→ Amazon ECR

Application Logs
→ Amazon CloudWatch Logs

Backend Service
→ ECS Service Auto Scaling

---

## Technologies Used

- Docker
- Docker Desktop
- WSL 2
- Node.js
- Express.js
- Nginx
- AWS CLI
- Amazon Elastic Container Registry (ECR)
- Amazon Elastic Container Service (ECS)
- AWS Fargate
- Application Load Balancer (ALB)
- Amazon CloudWatch Logs
- AWS IAM
- Application Auto Scaling
- Git
- GitHub
- Windows PowerShell

---

## Implementation Progress

### 1. Docker Environment

- Installed and configured Docker Desktop.
- Enabled CPU virtualization in BIOS.
- Repaired Windows optional-feature functionality.
- Enabled Windows Subsystem for Linux and Virtual Machine Platform.
- Updated WSL.
- Verified Docker Engine operation using the `hello-world` container.

### 2. Backend Application

Created a Node.js and Express backend service.

Implemented:

- `/`
- `/health`
- `/api/data`

The backend was tested locally on port 3000.

### 3. Backend Container

Created a Dockerfile using the Node.js Alpine image.

Security and optimization decisions included:

- Installing only production dependencies.
- Running the application as the non-root `node` user.
- Using a `.dockerignore` file.
- Exposing only the required application port.

The backend container was successfully built and tested.

### 4. Frontend Application

Created a simple frontend served by Nginx.

The frontend communicates with the backend through the `/api/data` endpoint.

### 5. Local Multi-Container Deployment

Created a custom Docker network.

Connected:

- Frontend container
- Backend container

Verified that the frontend could communicate with the backend successfully.

### 6. Amazon ECR

Created two private ECR repositories:

- `project07-backend`
- `project07-frontend`

Image scanning on push was enabled.

Authenticated Docker with ECR, tagged the local images, and pushed both container images successfully.

### 7. Amazon ECS and CloudWatch

Created the ECS cluster:

`project07-cluster`

Created CloudWatch log groups for the frontend and backend with seven-day log retention.

Created an ECS task execution IAM role and attached the required managed execution policy.

### 8. ECS Task Definitions

Registered separate Fargate task definitions for:

- Backend
- Frontend

Both used:

- Fargate launch type
- `awsvpc` networking
- 256 CPU units
- 512 MiB memory
- CloudWatch logging

Backend container port: `3000`

Frontend container port: `80`

### 9. Load Balancer

Created an internet-facing Application Load Balancer.

Created separate target groups for the frontend and backend.

Routing configuration:

- `/` → Frontend
- `/api/*` → Backend

Backend health checks use:

`/health`

### 10. Security Groups

The Application Load Balancer accepts HTTP traffic on port 80.

The ECS security group permits application traffic from the ALB security group instead of allowing unrestricted inbound access directly to the ECS tasks.

The backend application port is therefore not intentionally exposed directly to arbitrary internet clients through the security group.

### 11. ECS Services

Created separate ECS Fargate services for:

- `project07-backend-service`
- `project07-frontend-service`

The services were deployed across two subnets.

Both services were scaled to two running tasks:

- Backend: Desired 2 / Running 2
- Frontend: Desired 2 / Running 2

This demonstrated service-level redundancy.

### 12. ECS Networking Troubleshooting

The initial frontend ECS deployment failed.

CloudWatch showed:

`host not found in upstream "project07-backend-container"`

The Nginx configuration had been designed for the local Docker network, where the backend container name could be resolved as a hostname.

The frontend and backend were deployed as separate ECS services, so this local Docker hostname was not available in the ECS architecture.

The solution was to remove the backend proxy configuration from the production Nginx configuration and use the Application Load Balancer for path-based routing.

The corrected architecture became:

`/` → Frontend ECS Service

`/api/*` → Backend ECS Service

The frontend image was rebuilt, pushed to ECR, and the ECS frontend service was force-deployed.

The new frontend tasks became healthy.

### 13. Application Validation

Verified:

- Frontend loads through the ALB.
- Backend API responds through `/api/data`.
- Frontend successfully retrieves backend data.
- Backend target is healthy.
- Frontend target is healthy.
- CloudWatch receives application logs.

### 14. High Availability

Both services were configured with a desired count of two tasks.

Final service state:

- Backend: 2 desired / 2 running
- Frontend: 2 desired / 2 running

### 15. Backend Auto Scaling

Configured ECS Service Auto Scaling for the backend.

Configuration:

- Minimum tasks: 2
- Maximum tasks: 10
- Metric: ECS Service Average CPU Utilization
- Target utilization: 70%
- Scale-out cooldown: 60 seconds
- Scale-in cooldown: 60 seconds

Scaling policy:

`project07-backend-cpu-scaling`

The policy was successfully verified through the AWS CLI.

---

## Security Decisions

The project incorporated the following security practices:

- Private ECR repositories.
- ECR image scanning on push.
- ECS tasks restricted by security groups.
- ECS inbound application traffic restricted to the ALB security group.
- Separate frontend and backend services.
- Dedicated ECS task execution IAM role.
- No AWS credentials embedded in application source code or Docker images.
- Backend container runs as a non-root user.
- CloudWatch logging enabled.
- Temporary AWS configuration files excluded from Git.
- Environment files excluded through `.gitignore`.

---

## Cost-Conscious Design

This was a learning environment, so the deployment used public subnets with public IP assignment for Fargate tasks to avoid introducing a NAT Gateway.

Inbound application traffic remained restricted by security groups to the Application Load Balancer.

For a production architecture, the ECS tasks should normally be placed in private subnets with appropriate outbound connectivity through NAT or VPC endpoints.

---

## Production Improvements

Future improvements could include:

- HTTPS using AWS Certificate Manager.
- Custom domain name.
- Private ECS subnets.
- VPC endpoints for AWS services where appropriate.
- Immutable image tags instead of `latest`.
- Container image digest pinning.
- Infrastructure as Code using Terraform.
- CI/CD deployment automation.
- AWS WAF.
- More detailed CloudWatch alarms and dashboards.
- ECS deployment health monitoring.

---

## Final Result

Project 07 successfully demonstrated the complete container deployment lifecycle:

Application Development
→ Docker Containerization
→ Local Testing
→ Amazon ECR
→ ECS Fargate
→ Application Load Balancer
→ Health Checks
→ CloudWatch Logging
→ High Availability
→ Auto Scaling
→ Troubleshooting
→ Validation
→ Documentation