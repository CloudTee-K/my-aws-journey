# My AWS Cloud Engineering Journey

A hands-on Cloud Engineering and DevOps portfolio documenting my growth through the CloudHER Cohort 1 Mentorship Program by Women Innovating in Cloud Africa (WIICA).

## About This Journey

This repository documents my practical journey into AWS Cloud Engineering, DevOps, and Cloud Security through a structured series of 20 hands-on projects.

Rather than learning AWS services only in theory, I am building real-world cloud solutions that help me understand how infrastructure is designed, deployed, secured, automated, monitored, and troubleshot.

Each project documents not only the final solution, but also:

- The problem being solved
- Architecture and AWS services used
- Implementation steps
- Commands and configurations
- Testing and validation
- Troubleshooting
- Security considerations
- Lessons learned
- Cleanup procedures

## CloudHER Cohort 1

This portfolio forms part of my learning journey during the CloudHER Cohort 1 Mentorship Program by Women Innovating in Cloud Africa (WIICA).

**Track:** Cloud Computing  
**Focus:** Cloud Engineering, Cloud Architecture, Infrastructure Security, and DevOps  
**Mentor:** Olamide Kosile

During the mentorship, I moved from working mainly with individual AWS services to building complete cloud architectures and introducing automation, security, monitoring, CI/CD, and Infrastructure as Code into my projects.

## About Me

Hi, I'm **Toluwalope**, a Computer Science student building practical skills in **Cloud Computing, Cloud Engineering, DevOps, and Cybersecurity**.

My long-term focus is Cloud Security Engineering. I am developing the cloud engineering foundation required to design infrastructure that is not only functional, but also secure, resilient, observable, and maintainable.

This repository serves as both my technical learning journal and professional portfolio as I progress from foundational AWS projects toward increasingly advanced cloud engineering and security concepts.

---

## Learning Objectives

Throughout this journey, my objectives are to:

- Build practical experience designing and deploying solutions on AWS.
- Develop strong Cloud Engineering and DevOps fundamentals.
- Apply cloud security principles such as least privilege, private networking, encryption, and secure authentication.
- Automate infrastructure deployment using Infrastructure as Code.
- Build and understand CI/CD pipelines.
- Develop experience with containers and container orchestration.
- Improve monitoring, logging, and observability skills.
- Strengthen troubleshooting and problem-solving abilities.
- Document technical work professionally.
- Build a portfolio that demonstrates practical cloud engineering skills.

---

## Learning Roadmap

| Level | Projects | Status |
| --- | --- | --- |
| Beginner | Projects 1–5 | Completed |
| Intermediate | Projects 6–11 | In Progress |
| Advanced | Projects 12–16 | Not Started |
| Expert | Projects 17–20 | Not Started |

**Overall Progress:** 5/20 Projects Completed  
**Current Project:** Project 06 — Infrastructure as Code with Terraform

### Beginner Level Milestone Completed

I have completed the first five projects in the AWS Cloud Engineering roadmap.

These projects introduced me to:

- Static website hosting and content delivery
- Linux server administration on EC2
- Serverless architecture
- Managed relational databases
- Networking and security groups
- IAM roles and least-privilege permissions
- Monitoring and automated backups
- CI/CD pipelines
- GitHub Actions
- Secure AWS authentication with OIDC
- Deployment automation

I am now progressing into the intermediate stage, beginning with Infrastructure as Code using Terraform.

---

## Technologies & Services

### AWS Services Used So Far

- Amazon EC2
- Amazon S3
- Amazon CloudFront
- AWS IAM
- Amazon RDS
- AWS Lambda
- Amazon API Gateway
- Amazon SES
- Amazon VPC
- Amazon CloudWatch

### DevOps & Development Tools Used So Far

- Git
- GitHub
- GitHub Actions
- AWS CLI
- Linux
- Node.js
- Jest
- ESLint
- Flask
- Nginx
- PostgreSQL

### Currently Learning

- Terraform
- Infrastructure as Code
- Terraform modules
- Remote state management

### Planned Technologies

As I progress through the remaining projects, the roadmap will introduce technologies including:

- Docker
- Amazon ECS
- Amazon ECR
- Kubernetes
- Amazon EKS
- Secrets Manager
- Auto Scaling
- Application Load Balancer
- AWS Config
- GuardDuty
- Security Hub
- Helm
- ArgoCD
- Prometheus
- Grafana
- Loki

---

## Repository Structure

```text
my-aws-journey/
│
├── README.md
├── LICENSE
├── .gitignore
│
├── Projects/
├── Templates/
├── Notes/
├── Resources/
├── Architecture-Diagrams/
├── Screenshots/
└── Certificates/
```

---

## Project Documentation Standard

Every project in this repository is documented with relevant information such as:

- Project overview
- Architecture
- AWS services used
- Deployment steps
- Commands used
- Screenshots
- Challenges encountered
- Troubleshooting notes
- Lessons learned
- Security considerations
- Cost considerations
- Cleanup instructions

---

## Progress Tracker

| Project | Title | Status |
| --- | --- | --- |
| 1 | Static Website Hosting with S3 & CloudFront | Completed |
| 2 | Linux Server Setup on EC2 | Completed |
| 3 | Serverless Contact Form | Completed |
| 4 | RDS Database with Automated Backups | Completed |
| 5 | CI/CD Pipeline with GitHub Actions | Completed |
| 6 | Infrastructure as Code with Terraform | In Progress |
| 7 | Containerized Application on ECS | Not Started |
| 8 | Centralized Logging | Not Started |
| 9 | Secrets Management | Not Started |
| 10 | Auto Scaling Web Tier | Not Started |
| 11 | Event-Driven Data Pipeline | Not Started |
| 12 | Kubernetes on EKS | Not Started |
| 13 | GitOps with ArgoCD | Not Started |
| 14 | Full Observability Stack | Not Started |
| 15 | Blue/Green & Canary Deployments | Not Started |
| 16 | AWS Security Posture | Not Started |
| 17 | Multi-Region Active-Active Architecture | Not Started |
| 18 | Platform Engineering | Not Started |
| 19 | Chaos Engineering | Not Started |
| 20 | FinOps Cost Optimization | Not Started |

---

## Featured Projects

### Project 01 — Static Website Hosting with Amazon S3 & CloudFront

Built and deployed a static website using Amazon S3 for storage and Amazon CloudFront for content delivery.

**Key Technologies:** Amazon S3, Amazon CloudFront, IAM

**What I Learned:**

- Static website hosting on AWS
- Content delivery using a CDN
- HTTPS delivery through CloudFront
- S3 bucket policies and access control
- CloudFront distributions and cache invalidation

**Status:** Completed  
**Project Documentation:** [View Project 01](./Projects/Project-01-Static-Website-S3-Cloudfront/)

---

### Project 02 — Linux Server Setup on Amazon EC2

Provisioned and configured a Linux web server on Amazon EC2, using Nginx as a reverse proxy for a Flask application.

**Key Technologies:** Amazon EC2, Linux, Nginx, Flask, IAM, Systems Manager, CloudWatch

**What I Learned:**

- EC2 provisioning and Linux administration
- Security group configuration
- IAM roles for EC2
- AWS Systems Manager Session Manager
- Nginx reverse proxy configuration
- Application and infrastructure troubleshooting

**Status:** Completed  
**Project Documentation:** [View Project 02](./Projects/Project-02-Linux-Server-Setup-EC2/)

---

### Project 03 — Serverless Contact Form with Lambda and SES

Built a serverless contact form that receives HTTP requests through API Gateway, processes them with AWS Lambda, and sends emails using Amazon SES.

**Key Technologies:** AWS Lambda, Amazon API Gateway, Amazon SES, IAM, Node.js

**What I Learned:**

- Serverless architecture
- REST API integration
- Lambda execution roles
- Input validation
- CORS configuration
- Event-driven application design

**Status:** Completed  
**Project Documentation:** [View Project 03](./Projects/Project-03-Serverless-Contact-Form/)

---

### Project 04 — RDS Database with Automated Backups

Designed a secure database architecture using Amazon RDS for PostgreSQL inside a custom VPC with private database subnets and controlled access through a bastion host.

**Key Technologies:** Amazon RDS, PostgreSQL, Amazon VPC, Amazon EC2, CloudWatch

**What I Learned:**

- Public and private subnet architecture
- Database subnet groups
- Security-group-to-security-group access
- PostgreSQL administration
- Storage encryption
- Automated database backups
- CloudWatch alarms and monitoring

**Status:** Completed  
**Project Documentation:** [View Project 04](./Projects/Project-04-RDS-Database/)

---

### Project 05 — CI/CD Pipeline with GitHub Actions

Built a CI/CD pipeline for a Node.js application using GitHub Actions. The pipeline automatically installs dependencies, performs linting, runs automated tests, authenticates to AWS using OIDC, and deploys application artifacts to Amazon S3.

**Key Technologies:** GitHub Actions, Node.js, Jest, ESLint, AWS IAM, OIDC, Amazon S3

**Pipeline:**

`Git Push → Lint → Test → Authenticate to AWS → Deploy`

**What I Learned:**

- Continuous Integration and Continuous Deployment
- Automated testing and linting
- GitHub Actions workflows
- Secure AWS authentication using OIDC
- IAM trust policies
- Least-privilege deployment permissions
- CI/CD troubleshooting

**Status:** Completed  
**Project Documentation:** [View Project 05](./Projects/Project-05-CICD-Github-Actions/)

---

### Project 06 — Infrastructure as Code with Terraform

Currently learning how to provision AWS infrastructure using Terraform instead of manually creating every resource through the AWS Management Console.

The project introduces reusable Terraform modules, state management, infrastructure planning, and repeatable AWS deployments.

**Key Technologies:** Terraform, AWS CLI, Amazon VPC, Amazon EC2, Amazon RDS, Amazon S3

**Current Learning Focus:**

- Infrastructure as Code
- HashiCorp Configuration Language (HCL)
- Terraform modules
- Terraform state management
- Infrastructure validation and planning
- Reproducible cloud infrastructure

**Status:** In Progress

---

## Architecture Progress

### Project 01

```text
User
  |
  v
Amazon CloudFront
  |
  v
Amazon S3
```

### Project 02

```text
User
  |
  v
Amazon EC2
  |
  v
Nginx
  |
  v
Flask Application
```

### Project 03

```text
User
  |
  v
Amazon API Gateway
  |
  v
AWS Lambda
  |
  v
Amazon SES
  |
  v
Verified Email
```

### Project 04

```text
User / Administrator
        |
        v
   Bastion Host
        |
        v
 Private RDS PostgreSQL
```

### Project 05

```text
Developer
    |
    | git push
    v
GitHub Repository
    |
    v
GitHub Actions
    |
    +-- ESLint
    |
    +-- Jest Tests
    |
    v
GitHub OIDC
    |
    v
AWS IAM Role
    |
    v
Amazon S3
```

---

## Technical Growth & Skills Demonstrated

Through these projects, I have developed practical experience across several areas of cloud engineering.

### Cloud Architecture

- Designing AWS solutions using multiple interconnected services
- Working with public and private subnet architectures
- Understanding server-based, serverless, and managed-service architectures
- Selecting AWS services based on application requirements

### AWS Infrastructure

- Amazon EC2 instance deployment and administration
- Amazon S3 storage and static website hosting
- Amazon CloudFront content delivery
- Amazon RDS PostgreSQL deployment
- AWS Lambda serverless computing
- Amazon API Gateway
- Amazon SES email integration
- Amazon VPC networking
- Amazon CloudWatch monitoring

### Cloud Security

Security has become an increasingly important part of how I approach cloud infrastructure.

I have gained practical experience with:

- IAM users, roles, and policies
- Least-privilege permissions
- Security groups
- Private database subnets
- Encryption at rest
- HTTPS and encryption in transit
- Secure AWS authentication using OIDC
- Restricting direct access to cloud resources
- Separating application and database access
- Avoiding long-lived AWS credentials in CI/CD pipelines

### DevOps & Automation

- Git and GitHub version control
- GitHub Actions
- CI/CD pipeline design
- Automated testing with Jest
- Code linting with ESLint
- AWS deployment automation
- Introduction to Infrastructure as Code with Terraform

### Linux & Application Deployment

- Linux command-line administration
- Nginx configuration
- Flask application deployment
- Node.js application development
- PostgreSQL command-line administration
- AWS CLI usage

### Troubleshooting

An important part of this journey has been learning how to troubleshoot systems instead of simply following deployment instructions.

Some of the issues I have worked through include:

- Web server and reverse proxy configuration problems
- Security group and network connectivity issues
- Database connectivity
- IAM permission problems
- API and CORS configuration
- CI/CD workflow failures
- GitHub Actions OIDC authentication and IAM trust-policy issues
- Local development environment and CLI configuration

Troubleshooting these problems has strengthened my understanding of how the individual components of a cloud architecture interact.

---

## How My Approach Has Changed

At the beginning of this journey, much of my focus was on learning how individual AWS services worked and deploying resources manually.

As I progressed through the projects, my focus expanded toward understanding the relationships between services and the architecture as a whole.

My current approach increasingly considers:

**Architecture → Security → Automation → Testing → Monitoring → Documentation → Cleanup**

This shift has helped me understand that Cloud Engineering is not simply about creating resources in AWS. It involves designing infrastructure that can be secured, tested, maintained, monitored, reproduced, and improved.

My next stage focuses on Infrastructure as Code with Terraform and progressively more advanced cloud architecture, DevOps, containerization, observability, and security projects.

---

## CloudHER Mentorship Reflection

Participating in the CloudHER Cohort 1 Mentorship Program has helped me become more intentional about my journey into cloud technology.

My mentorship focus has been Cloud Computing, with particular interest in Cloud Engineering, Cloud Architecture, Infrastructure Security, and DevOps.

Working through hands-on AWS projects has helped me move beyond simply learning cloud concepts. I now spend more time thinking about why an architecture is designed a certain way, how its components communicate, what security controls should be applied, how failures can be diagnosed, and how infrastructure can eventually be automated.

One of the most valuable parts of this journey has been learning through troubleshooting. Not every deployment worked correctly on the first attempt, and resolving those problems has strengthened both my technical understanding and confidence when working with cloud infrastructure.

I am grateful to my mentor, **Olamide Kosile**, for his guidance throughout my CloudHER journey and to **Women Innovating in Cloud Africa (WIICA)** for creating an environment where women can develop practical cloud skills and grow within the technology industry.

---

## What's Next?

Completing the beginner stage is only the beginning of this roadmap.

My next phase focuses on:

- Infrastructure as Code with Terraform
- Containerization with Docker
- Amazon ECS and ECR
- Centralized logging and monitoring
- Secrets management
- Auto Scaling and load balancing
- Event-driven architectures
- Kubernetes and Amazon EKS
- GitOps
- Observability
- Advanced AWS security
- Highly available and multi-region architectures

As I continue building, I will keep documenting not only successful deployments but also the problems, design decisions, security considerations, and lessons that come with each project.

My long-term goal is to grow from Cloud Engineering into **Cloud Security Engineering**, with a strong understanding of how secure cloud infrastructure is designed, deployed, automated, monitored, and maintained.

---

## Current Progress

**AWS Cloud Engineering Roadmap:** 5/20 projects completed  
**Current Stage:** Intermediate  
**Currently Building:** Project 06 — Infrastructure as Code with Terraform  
**CloudHER:** Cohort 1 — Cloud Computing Track

This repository will continue to evolve as I complete the remaining projects in the roadmap.

---

## Certification Alignment

This learning journey provides practical experience relevant to AWS certification study, including:

- AWS Certified Cloud Practitioner
- AWS Certified Solutions Architect – Associate
- AWS Certified Developer – Associate
- AWS Certified SysOps Administrator – Associate
- AWS Certified DevOps Engineer – Professional

Certification objectives are used as learning references; completion of projects in this repository does not represent certification.

---

## Disclaimer

This repository is intended for educational and portfolio purposes. AWS resources are deployed for learning and are cleaned up after projects where appropriate to encourage responsible cloud usage and cost management.

---

Cloud engineering is learned through practice: building, testing, troubleshooting, documenting, and improving. Every project in this repository represents another step in my development as a Cloud Engineer.