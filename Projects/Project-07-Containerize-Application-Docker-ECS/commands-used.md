# Project 07 - Commands Used

This document records the main commands used to containerize, test, deploy, monitor, scale, and validate the Project 07 application.

Environment:

- Windows PowerShell
- Docker Desktop
- AWS CLI
- AWS Region: `us-east-1`

---

## 1. Verify Docker

```powershell
docker --version
docker info
docker run --rm hello-world
```

---

## 2. Backend Local Testing

Navigate to the backend directory:

```powershell
cd app\backend
```

Install dependencies:

```powershell
npm.cmd install
```

Run the backend:

```powershell
node server.js
```

Test the health endpoint:

```powershell
curl.exe http://localhost:3000/health
```

Test the API:

```powershell
curl.exe http://localhost:3000/api/data
```

---

## 3. Build Backend Docker Image

From the backend directory:

```powershell
docker build -t project07-backend:latest .
```

Run the backend container:

```powershell
docker run -d `
  --name project07-backend-container `
  -p 3000:3000 `
  project07-backend:latest
```

Test:

```powershell
curl.exe http://localhost:3000/health
curl.exe http://localhost:3000/api/data
```

---

## 4. Create Docker Network

```powershell
docker network create project07-network
```

Connect the backend container:

```powershell
docker network connect project07-network project07-backend-container
```

---

## 5. Build Frontend Docker Image

Navigate to:

```powershell
cd ..\frontend
```

Build:

```powershell
docker build -t project07-frontend:latest .
```

Run:

```powershell
docker run -d `
  --name project07-frontend-container `
  --network project07-network `
  -p 8080:80 `
  project07-frontend:latest
```

Open:

```text
http://localhost:8080
```

---

## 6. Configure AWS Variables

```powershell
$AWS_REGION = "us-east-1"

$AWS_ACCOUNT_ID = aws sts get-caller-identity `
  --query Account `
  --output text

$ECR_REGISTRY = "$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com"
```

These variables prevent account-specific identifiers from being hardcoded into reusable commands.

---

## 7. Create ECR Repositories

```powershell
aws ecr create-repository `
  --repository-name project07-backend `
  --image-scanning-configuration scanOnPush=true `
  --region $AWS_REGION
```

```powershell
aws ecr create-repository `
  --repository-name project07-frontend `
  --image-scanning-configuration scanOnPush=true `
  --region $AWS_REGION
```

---

## 8. Authenticate Docker with ECR

```powershell
aws ecr get-login-password --region $AWS_REGION |
docker login `
  --username AWS `
  --password-stdin $ECR_REGISTRY
```

ECR authentication may need to be repeated if the authorization token expires.

---

## 9. Tag Images for ECR

Backend:

```powershell
docker tag project07-backend:latest `
  "$ECR_REGISTRY/project07-backend:latest"
```

Frontend:

```powershell
docker tag project07-frontend:latest `
  "$ECR_REGISTRY/project07-frontend:latest"
```

---

## 10. Push Images to ECR

```powershell
docker push "$ECR_REGISTRY/project07-backend:latest"
```

```powershell
docker push "$ECR_REGISTRY/project07-frontend:latest"
```

Verify:

```powershell
aws ecr describe-images `
  --repository-name project07-backend `
  --region $AWS_REGION `
  --query "imageDetails[].imageTags"
```

```powershell
aws ecr describe-images `
  --repository-name project07-frontend `
  --region $AWS_REGION `
  --query "imageDetails[].imageTags"
```

---

## 11. Create ECS Cluster

```powershell
aws ecs create-cluster `
  --cluster-name project07-cluster `
  --region $AWS_REGION
```

---

## 12. Create CloudWatch Log Groups

```powershell
aws logs create-log-group `
  --log-group-name /ecs/project07-backend `
  --region $AWS_REGION
```

```powershell
aws logs create-log-group `
  --log-group-name /ecs/project07-frontend `
  --region $AWS_REGION
```

Set seven-day retention:

```powershell
aws logs put-retention-policy `
  --log-group-name /ecs/project07-backend `
  --retention-in-days 7 `
  --region $AWS_REGION
```

```powershell
aws logs put-retention-policy `
  --log-group-name /ecs/project07-frontend `
  --retention-in-days 7 `
  --region $AWS_REGION
```

---

## 13. Retrieve Default VPC

```powershell
$VPC_ID = aws ec2 describe-vpcs `
  --filters "Name=is-default,Values=true" `
  --query "Vpcs[0].VpcId" `
  --output text `
  --region $AWS_REGION
```

The project used two default-VPC subnets in different Availability Zones.

---

## 14. Application Load Balancer

An internet-facing Application Load Balancer named:

```text
project07-alb
```

was created across two subnets.

Two target groups were created:

```text
project07-frontend-tg
project07-backend-tg
```

Frontend configuration:

```text
Protocol: HTTP
Port: 80
Target type: IP
Health check: /
```

Backend configuration:

```text
Protocol: HTTP
Port: 3000
Target type: IP
Health check: /health
```

---

## 15. ALB Routing

Listener:

```text
HTTP :80
```

Default action:

```text
/ → project07-frontend-tg
```

Path-based rule:

```text
/api/* → project07-backend-tg
```

---

## 16. ECS Services

Backend service:

```text
project07-backend-service
```

Frontend service:

```text
project07-frontend-service
```

Both services use:

```text
Launch type: FARGATE
Network mode: awsvpc
Public IP: Enabled
```

Application inbound traffic was restricted through security-group rules so the ALB security group was the allowed source for the ECS application ports.

---

## 17. Inspect ECS Services

```powershell
aws ecs describe-services `
  --cluster project07-cluster `
  --services project07-backend-service project07-frontend-service `
  --region $AWS_REGION `
  --query "services[].{Service:serviceName,Desired:desiredCount,Running:runningCount,Pending:pendingCount}" `
  --output table
```

Final validation showed:

```text
Backend  - Desired: 2, Running: 2
Frontend - Desired: 2, Running: 2
```

---

## 18. Inspect Stopped Tasks

During troubleshooting:

```powershell
aws ecs list-tasks `
  --cluster project07-cluster `
  --service-name project07-frontend-service `
  --desired-status STOPPED `
  --region $AWS_REGION
```

Stopped task details were inspected with:

```powershell
aws ecs describe-tasks `
  --cluster project07-cluster `
  --tasks <TASK-ARN> `
  --region $AWS_REGION
```

The failed frontend container returned exit code `1`.

---

## 19. CloudWatch Troubleshooting

Frontend logs revealed the Nginx error:

```text
host not found in upstream "project07-backend-container"
```

This showed that a hostname used in the local Docker network could not be used in the separate ECS service architecture.

The Nginx configuration was corrected and the frontend image rebuilt.

---

## 20. Redeploy Corrected Frontend

Rebuild:

```powershell
docker build -t project07-frontend:latest .
```

Tag:

```powershell
docker tag project07-frontend:latest `
  "$ECR_REGISTRY/project07-frontend:latest"
```

Authenticate again if required:

```powershell
aws ecr get-login-password --region $AWS_REGION |
docker login `
  --username AWS `
  --password-stdin $ECR_REGISTRY
```

Push:

```powershell
docker push "$ECR_REGISTRY/project07-frontend:latest"
```

Force a new ECS deployment:

```powershell
aws ecs update-service `
  --cluster project07-cluster `
  --service project07-frontend-service `
  --force-new-deployment `
  --region $AWS_REGION
```

---

## 21. Validate Target Health

Target health was checked using:

```powershell
aws elbv2 describe-target-health `
  --target-group-arn $FRONTEND_TG_ARN `
  --region $AWS_REGION
```

```powershell
aws elbv2 describe-target-health `
  --target-group-arn $BACKEND_TG_ARN `
  --region $AWS_REGION
```

Healthy targets confirmed successful ALB-to-ECS communication.

---

## 22. Retrieve ALB DNS Name

```powershell
$ALB_DNS = aws elbv2 describe-load-balancers `
  --names project07-alb `
  --query "LoadBalancers[0].DNSName" `
  --output text `
  --region $AWS_REGION
```

Test frontend:

```powershell
curl.exe "http://$ALB_DNS/"
```

Test backend through ALB:

```powershell
curl.exe "http://$ALB_DNS/api/data"
```

Open application:

```powershell
Start-Process "http://$ALB_DNS"
```

---

## 23. Configure Backend Auto Scaling

Register the backend ECS service as a scalable target:

```powershell
aws application-autoscaling register-scalable-target `
  --service-namespace ecs `
  --resource-id service/project07-cluster/project07-backend-service `
  --scalable-dimension ecs:service:DesiredCount `
  --min-capacity 2 `
  --max-capacity 10 `
  --region $AWS_REGION
```

A target-tracking policy was configured with:

```text
Metric: ECSServiceAverageCPUUtilization
Target: 70%
Minimum tasks: 2
Maximum tasks: 10
```

---

## 24. Verify Auto Scaling Policy

```powershell
aws application-autoscaling describe-scaling-policies `
  --service-namespace ecs `
  --resource-id service/project07-cluster/project07-backend-service `
  --scalable-dimension ecs:service:DesiredCount `
  --region $AWS_REGION `
  --query "ScalingPolicies[].{Policy:PolicyName,Metric:TargetTrackingScalingPolicyConfiguration.PredefinedMetricSpecification.PredefinedMetricType,TargetCPU:TargetTrackingScalingPolicyConfiguration.TargetValue}" `
  --output table
```

The verified policy was:

```text
Policy: project07-backend-cpu-scaling
Metric: ECSServiceAverageCPUUtilization
Target CPU: 70%
```

---

## 25. Git Inspection

Before publishing:

```powershell
git status
git status --short
```

Project 07 files and screenshots should be staged explicitly instead of using `git add .` when unrelated working-tree modifications exist elsewhere in the repository.

---

## Important Notes

AWS account IDs, ARNs, subnet IDs, task ARNs, target group ARNs, and ALB DNS values are intentionally not hardcoded in this document.

Variables and placeholders are used so the commands remain reusable and the portfolio documentation does not unnecessarily expose account-specific identifiers.