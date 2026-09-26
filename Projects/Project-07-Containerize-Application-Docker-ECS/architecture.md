# Project 07 Architecture

## Overview

Project 07 deploys a containerized two-service web application using Docker, Amazon ECR, Amazon ECS Fargate, an Application Load Balancer, and Amazon CloudWatch.

The application consists of:

- Nginx frontend
- Node.js/Express backend

---

## Local Docker Architecture

```text
User Browser
     |
     | HTTP :8080
     v
+-----------------------+
| Frontend Container    |
| Nginx                 |
| Port 80               |
+-----------+-----------+
            |
            | /api/*
            | Docker Network
            v
+-----------------------+
| Backend Container     |
| Node.js + Express     |
| Port 3000             |
+-----------------------+

Both containers communicate through the custom Docker network:

project07-network

During local development, Nginx could resolve the backend using the Docker container hostname.


AWS Architecture

                         Internet
                            |
                            | HTTP :80
                            v
                +-------------------------+
                | Application Load        |
                | Balancer (ALB)          |
                +------------+------------+
                             |
               +-------------+-------------+
               |                           |
               | /                         | /api/*
               v                           v
     +--------------------+      +--------------------+
     | Frontend Target    |      | Backend Target     |
     | Group :80          |      | Group :3000        |
     +---------+----------+      +---------+----------+
               |                           |
        +------+------+             +------+------+
        |             |             |             |
        v             v             v             v
   Frontend       Frontend      Backend        Backend
   Fargate        Fargate       Fargate        Fargate
   Task 1         Task 2        Task 1         Task 2
   Nginx          Nginx         Node.js         Node.js
        |             |             |             |
        +------+------+             +------+------+
               |                           |
               +-------------+-------------+
                             |
                             v
                    Amazon CloudWatch
                         Logs



Container Image Flow

Application Source Code
          |
          v
      Docker Build
          |
          v
    Local Docker Images
          |
          | docker push
          v
+-------------------------+
| Amazon ECR              |
|                         |
| project07-frontend      |
| project07-backend       |
+------------+------------+
             |
             v
       ECS Task Definitions
             |
             v
       ECS Fargate Services



       Amazon ECR stores the container images used by the ECS task definitions.

Load Balancer Routing

The Application Load Balancer provides the application's public entry point.

Routing rules:

Request	Destination
/	Frontend target group on port 80
/api/*	Backend target group on port 3000

The backend target group uses /health for health checks.

This design allows the frontend and backend to run as independent ECS services.

ECS Services

Two ECS services were deployed:

Frontend Service
Container: Nginx
Port: 80
Desired tasks: 2
Launch type: AWS Fargate
Backend Service
Container: Node.js/Express
Port: 3000
Desired tasks: 2
Launch type: AWS Fargate
Auto Scaling enabled

Both services use awsvpc networking.

Auto Scaling Architecture

The backend service uses ECS Service Auto Scaling.

CloudWatch CPU Metric
        |
        v
ECSServiceAverageCPUUtilization
        |
        | Target = 70%
        v
Application Auto Scaling
        |
        v
Backend ECS Service
        |
        +---- Minimum: 2 tasks
        |
        +---- Maximum: 10 tasks

This allows ECS to adjust the desired backend task count according to average CPU utilization.

Security Group Flow
Internet
   |
   | TCP 80
   v
ALB Security Group
   |
   +-------- TCP 80 --------> Frontend Tasks
   |
   +-------- TCP 3000 ------> Backend Tasks

The ECS security group accepts application traffic from the ALB security group.

The backend application port is therefore not intentionally opened directly to arbitrary internet clients through its inbound security-group rules.

Logging

Frontend and backend containers send logs to separate Amazon CloudWatch log groups.

Frontend ECS Tasks
       |
       v
/ecs/project07-frontend

Backend ECS Tasks
       |
       v
/ecs/project07-backend

Log retention was configured for seven days.

CloudWatch logs were also used to troubleshoot the failed initial frontend deployment.

Local vs AWS Networking

An important architectural difference was discovered during deployment.

Local Docker

The frontend Nginx container could communicate with:

project07-backend-container:3000

because both containers belonged to the same Docker network.

AWS ECS

The frontend and backend were deployed as separate ECS services.

The local Docker container hostname was therefore not available to the frontend service.

Instead of attempting to use the local container hostname, the AWS deployment uses ALB path-based routing:

/api/* → Backend Target Group → Backend ECS Tasks

This separated local container networking from AWS service routing.

Cost-Conscious Networking

For this learning project, Fargate tasks were deployed in public subnets with public IP assignment to avoid the additional cost of a NAT Gateway.

Security groups restrict inbound application traffic to the ALB security group.

A stronger production architecture would normally place ECS application tasks in private subnets and provide controlled outbound connectivity using NAT or appropriate VPC endpoints.

Production Architecture Improvements

A production version could add:

HTTPS/TLS using AWS Certificate Manager
Custom DNS using Route 53
Private ECS subnets
VPC endpoints
AWS WAF
Immutable ECR image versions
Automated CI/CD
Infrastructure as Code
CloudWatch alarms and dashboards
Additional deployment and security controls
Final Architecture Summary

The final request flow is:

Internet
   |
   v
Application Load Balancer
   |
   +---- / --------> Frontend Target Group
   |                     |
   |                     v
   |                Nginx Fargate Tasks
   |
   +---- /api/* ---> Backend Target Group
                         |
                         v
                    Node.js Fargate Tasks
                         |
                         v
                   CloudWatch Logs

Container images are supplied by Amazon ECR, while ECS manages task deployment, availability, health, and backend scaling.