# Project 07 - Lessons Learned

## Overview

Project 07 provided practical experience with Docker containerization, Amazon ECR, Amazon ECS Fargate, Application Load Balancers, CloudWatch, IAM, networking, high availability, troubleshooting, and auto scaling.

The project also demonstrated that successfully running an application locally does not automatically mean it will work unchanged in a cloud environment.

---

## 1. Containerization Creates Consistent Application Environments

Docker packages an application together with its runtime and dependencies.

The Node.js backend and Nginx frontend were packaged as separate container images, allowing each service to run independently.

This reinforced the importance of separating application components into clearly defined services.

---

## 2. Docker Images and Containers Are Different

A Docker image is the packaged application template.

A container is a running instance of that image.

The project demonstrated the workflow:

```text
Source Code
    ↓
Dockerfile
    ↓
Docker Image
    ↓
Docker Container
```

Amazon ECR stores the images, while Amazon ECS runs containers from those images.

---

## 3. Docker Build Context Matters

Docker interprets file paths relative to the build context supplied to:

```powershell
docker build
```

Running a command from the wrong directory can therefore cause missing-file or invalid-path errors.

Checking the current directory before building is an important troubleshooting habit.

---

## 4. Local Container Networking Is Different from ECS Networking

This was one of the most important lessons from the project.

Locally, the frontend and backend belonged to the same Docker network, allowing Nginx to reach the backend using its container hostname.

In AWS, the frontend and backend were deployed as independent ECS services.

The local Docker hostname could not simply be reused.

The final AWS architecture instead used the Application Load Balancer:

```text
/      → Frontend ECS Service
/api/* → Backend ECS Service
```

Application networking must therefore be designed for the environment where the application will actually run.

---

## 5. Load Balancers Can Perform More Than Traffic Distribution

The Application Load Balancer did more than provide a public endpoint.

It also performed path-based routing.

Requests to the application frontend were routed to one ECS service, while API requests were routed to another.

This demonstrated how an ALB can act as the central entry point for multiple application services.

---

## 6. Health Checks Are Essential

The project used separate health checks for the frontend and backend.

The backend exposed:

```text
/health
```

This allowed the target group to determine whether a backend task was ready to receive traffic.

A running container does not automatically mean the application inside it is healthy.

---

## 7. CloudWatch Logs Are Critical for ECS Troubleshooting

ECS showed that the frontend task had stopped, but that information alone did not explain the application failure.

CloudWatch logs revealed the actual Nginx error:

```text
host not found in upstream "project07-backend-container"
```

This showed the importance of centralized logging.

When an ECS task fails, container logs should be one of the first places investigated.

---

## 8. ECR Authentication Is Temporary

Docker authentication to Amazon ECR can expire.

When the corrected frontend image failed to push because the authorization token had expired, authenticating again solved the problem.

This reinforced the difference between permanent application configuration and temporary authentication sessions.

---

## 9. IAM Roles Are Better Than Embedding AWS Credentials

The ECS task execution role allowed ECS to perform required AWS operations without placing AWS access keys inside the application or Docker images.

This reinforced an important cloud security principle:

```text
Prefer temporary role-based permissions over embedded long-term credentials.
```

---

## 10. Security Groups Should Restrict Traffic by Purpose

The ALB was allowed to receive HTTP traffic from the internet.

The ECS application ports were configured to accept inbound traffic from the ALB security group.

This created a clearer traffic flow:

```text
Internet
   ↓
ALB
   ↓
ECS Tasks
```

Rather than intentionally opening the ECS application ports directly to arbitrary internet clients.

---

## 11. High Availability Requires Multiple Tasks

Running only one task creates a single application instance.

The frontend and backend services were therefore configured with two desired tasks each.

The final service state showed:

```text
Backend  → 2 desired / 2 running
Frontend → 2 desired / 2 running
```

This demonstrated how ECS services maintain a desired number of application instances.

---

## 12. Auto Scaling and High Availability Are Different Concepts

High availability and auto scaling solve related but different problems.

High availability keeps multiple application instances running to reduce dependency on a single task.

Auto scaling changes the number of tasks according to workload.

For the backend service:

```text
Minimum Tasks: 2
Maximum Tasks: 10
CPU Target: 70%
```

The minimum maintains the baseline service capacity, while auto scaling allows the service to increase or decrease its desired task count within the configured limits.

---

## 13. PowerShell Requires Careful JSON Handling

Complex JSON passed directly to the AWS CLI can become difficult to quote correctly in PowerShell.

Using a temporary JSON file with:

```text
file://filename.json
```

proved more reliable for the auto-scaling configuration.

This is a useful technique for future AWS CLI automation.

---

## 14. Public IP Does Not Automatically Mean Unrestricted Inbound Access

The learning architecture used public subnets and public IP assignment for Fargate tasks to avoid adding a NAT Gateway.

However, inbound application access was controlled by security groups so that the ALB security group was the permitted source for the application ports.

This reinforced the difference between:

```text
Network reachability
```

and:

```text
Security-group authorization
```

For production workloads, private application subnets would generally provide a stronger architecture.

---

## 15. Cost Is Part of Cloud Architecture

Architecture decisions are not based only on technical capability.

They also involve cost.

For this learning project, introducing resources such as a NAT Gateway would have increased cost.

The project therefore used a simpler architecture while documenting how a production design could be improved.

Resources such as Application Load Balancers and running Fargate tasks should also be removed after validation when they are no longer needed.

---

## 16. Troubleshooting Should Be Evidence-Driven

A major lesson from this project was to avoid changing configurations randomly.

The troubleshooting process became:

```text
Observe
   ↓
Inspect
   ↓
Read Logs
   ↓
Identify Root Cause
   ↓
Fix
   ↓
Redeploy
   ↓
Validate
```

This was especially important when diagnosing the failed frontend ECS tasks.

---

## 17. Cloud Deployments Need Production-Specific Configuration

The same configuration is not always suitable for local development and cloud deployment.

The local Nginx configuration depended on Docker networking.

The AWS architecture depended on ALB routing.

Future applications should clearly separate environment-specific configuration where necessary.

---

## 18. Immutable Image Versions Would Improve Deployments

The project used the `latest` image tag during development.

Although convenient for learning, immutable version tags such as:

```text
v1.0.0
v1.0.1
```

or image digests would make production deployments easier to track and roll back.

---

## 19. Container Security Starts During Image Creation

The backend Dockerfile runs the application as the non-root `node` user and installs only production dependencies.

This showed that container security begins before deployment.

Important practices include:

- Using minimal base images
- Running applications as non-root users where possible
- Avoiding credentials in images
- Installing only required dependencies
- Scanning container images
- Keeping base images updated

---

## 20. The Entire Deployment Is a System

Project 07 showed that a containerized cloud application depends on several connected layers:

```text
Application Code
      ↓
Docker Image
      ↓
Amazon ECR
      ↓
ECS Task Definition
      ↓
ECS Service
      ↓
Networking
      ↓
Target Group
      ↓
Application Load Balancer
      ↓
Monitoring and Auto Scaling
```

A problem at any one of these layers can affect the complete application.

Understanding the relationships between the services is therefore more important than simply memorizing deployment commands.

---

## Final Reflection

Project 07 strengthened practical skills in:

- Docker
- Container networking
- Amazon ECR
- Amazon ECS Fargate
- Application Load Balancers
- Path-based routing
- IAM roles
- Security groups
- CloudWatch logging
- ECS health checks
- High availability
- ECS Service Auto Scaling
- AWS CLI
- PowerShell troubleshooting

The most valuable lesson was learning how to move from a working local multi-container application to an AWS architecture and then diagnose the differences when the first cloud deployment failed.

The project demonstrated that cloud engineering involves not only deploying resources, but also understanding networking, security, observability, scalability, cost, and troubleshooting.