#  My AWS Cloud Engineering Journey

Welcome to **My AWS Cloud Engineering Journey**! 

This repository documents my hands-on learning journey through AWS Cloud Engineering and DevOps using a project-based approach. Rather than learning AWS services in isolation, I'm building real-world projects that reflect how cloud technologies are used in production environments.

Each project in this repository is carefully documented to showcase not only the final solution but also the learning process, challenges encountered, troubleshooting steps, and key takeaways.

---

## About Me

Hi, I'm **Toluwalope**, a Computer Science student with a growing passion for **Cloud Computing**, **Cloud Engineering**, and **Cybersecurity**.

My goal is to build a strong foundation in AWS cloud technologies through practical, hands-on experience while developing the skills required to design, deploy, secure, and manage modern cloud solutions.

This repository serves as both my learning journal and professional portfolio as I progress from beginner-level AWS projects to advanced cloud engineering concepts.

---

##  Learning Objectives

Throughout this journey, I aim to:

* Build practical experience with core AWS services.
* Develop strong Cloud Engineering and DevOps skills.
* Learn Infrastructure as Code using Terraform.
* Build and deploy containerized applications.
* Understand CI/CD pipelines and automation.
* Gain experience with Kubernetes and GitOps.
* Learn cloud security best practices.
* Improve troubleshooting and problem-solving skills.
* Build a professional GitHub portfolio.
* Document my learning consistently.

---

## Learning Roadmap

| Level           | Projects       | Status        |
| --------------- | -------------- | ------------- |
| 🟢 Beginner     | Projects 1–5   | ⏳ IN PROGRESS |
| 🟡 Intermediate | Projects 6–11  | ⏳ Not Started |
| 🟠 Advanced     | Projects 12–16 | ⏳ Not Started |
| 🔴 Expert       | Projects 17–20 | ⏳ Not Started |

**Overall Progress:** **3/20 Projects Completed**

---

##  Technologies & Services

During this journey, I'll gain hands-on experience with:

### AWS Services

* Amazon EC2
* Amazon S3
* Amazon CloudFront
* AWS IAM
* Amazon RDS
* AWS Lambda
* API Gateway
* Amazon VPC
* Route 53
* Amazon ECS
* Amazon EKS
* Amazon ECR
* CloudWatch
* Secrets Manager
* DynamoDB
* Auto Scaling
* Application Load Balancer (ALB)
* AWS Config
* GuardDuty
* Security Hub

### DevOps & Cloud Engineering

* Git & GitHub
* GitHub Actions
* Docker
* Terraform
* Kubernetes
* Helm
* ArgoCD
* Prometheus
* Grafana
* Loki

---

##  Repository Structure

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

##  Project Documentation Standard

Every project in this repository will include:

* Project overview
* Architecture diagram
* AWS services used
* Deployment steps
* Commands used
* Screenshots
* Challenges encountered
* Troubleshooting notes
* Lessons learned
* Security considerations
* Cost considerations
* Cleanup instructions

---

## Progress Tracker

| Project | Title                                       | Status    |
| ------- | ------------------------------------------- | --------- |
| 1       | Static Website Hosting with S3 & CloudFront |✅ Completed|
| 2       | Linux Server Setup on EC2                   |✅ Completed|
| 3       | Serverless Contact Form                     |✅ Completed|
| 4       | RDS Database with Backups                   | ✅ Completed |
| 5       | CI/CD Pipeline                              | ⏳ Pending |
| 6       | Infrastructure as Code with Terraform       | ⏳ Pending |
| 7       | Containerized Application on ECS            | ⏳ Pending |
| 8       | Centralized Logging                         | ⏳ Pending |
| 9       | Secrets Management                          | ⏳ Pending |
| 10      | Auto Scaling Web Tier                       | ⏳ Pending |
| 11      | Event-Driven Data Pipeline                  | ⏳ Pending |
| 12      | Kubernetes on EKS                           | ⏳ Pending |
| 13      | GitOps with ArgoCD                          | ⏳ Pending |
| 14      | Full Observability Stack                    | ⏳ Pending |
| 15      | Blue/Green & Canary Deployments             | ⏳ Pending |
| 16      | AWS Security Posture                        | ⏳ Pending |
| 17      | Multi-Region Active-Active Architecture     | ⏳ Pending |
| 18      | Platform Engineering                        | ⏳ Pending |
| 19      | Chaos Engineering                           | ⏳ Pending |
| 20      | FinOps Cost Optimization                    | ⏳ Pending |

---

---

# 🌟 Featured Projects

## ✅ Project 01 — Static Website Hosting with Amazon S3 & CloudFront

Successfully deployed a globally accessible static website using Amazon S3 and Amazon CloudFront.

### Highlights

- Hosted a static website on Amazon S3
- Configured Static Website Hosting
- Applied a public-read bucket policy
- Created a CloudFront distribution
- Enabled HTTPS through CloudFront
- Documented the complete deployment process
- Recorded troubleshooting steps and lessons learned
- Captured deployment screenshots
- Practiced AWS cost optimization through resource cleanup

## ✅ Project 02 — Linux Server Setup on Amazon EC2

Successfully provisioned and configured a secure Ubuntu Linux server on Amazon EC2 using automated provisioning with EC2 User Data. Implemented secure access with IAM Roles, Security Groups, AWS Systems Manager Session Manager, and Amazon CloudWatch monitoring while deploying a Flask web application behind an Nginx reverse proxy.

### Highlights

- Launched and configured an Ubuntu Server 22.04 LTS Amazon EC2 instance.
- Configured Security Groups to allow SSH, HTTP, and HTTPS traffic.
- Created and attached an IAM Role with Systems Manager and CloudWatch permissions.
- Provisioned the server automatically using EC2 User Data.
- Deployed a Python Flask web application.
- Configured Nginx as a reverse proxy for the Flask application.
- Managed the EC2 instance securely using AWS Systems Manager Session Manager.
- Monitored instance performance using Amazon CloudWatch.
- Performed end-to-end Linux and Nginx troubleshooting to validate the deployment.
- Produced comprehensive project documentation, including architecture, commands, troubleshooting, lessons learned, and screenshots.

## ✅ Project 03 — Serverless Contact Form with AWS Lambda & Amazon SES

Built and deployed a fully serverless contact form using Amazon API Gateway, AWS Lambda, and Amazon SES. The application accepts user input from a static HTML frontend, invokes a Lambda function through API Gateway, validates the request, and sends email notifications using Amazon SES.

### Highlights

- Built a serverless backend using AWS Lambda.
- Created a REST API with Amazon API Gateway.
- Integrated Lambda with Amazon SES for email delivery.
- Configured IAM roles following the Principle of Least Privilege.
- Connected a static HTML frontend to a serverless backend.
- Packaged and deployed a Node.js Lambda function with external dependencies.
- Configured CORS for secure browser-based API requests.
- Successfully tested end-to-end email delivery.
- Documented the architecture, deployment process, troubleshooting steps, and lessons learned.

### ✅ Project 04 — Amazon RDS PostgreSQL Database with Automated Backups

Deployed a secure PostgreSQL database using Amazon RDS within a custom VPC. The architecture uses private RDS subnets, an EC2 Bastion Host for controlled administrative access, security-group-based network restrictions, encrypted database connectivity, automated backups, and Amazon CloudWatch monitoring.

**AWS Services:** Amazon RDS, Amazon EC2, Amazon VPC, Amazon CloudWatch

**Key Skills:** PostgreSQL, VPC networking, private database architecture, Bastion Host administration, security groups, automated backups, SSL/TLS, CloudWatch monitoring

## 🏗️ Architecture Progress

### Project 1

```
User
   │
   ▼
Amazon CloudFront
   │
   ▼
Amazon S3
```

### Project 2

```
User
   │
   ▼
Amazon EC2
   │
   ▼
Nginx
   │
   ▼
Flask Application
```

### Project 3

```
User
   │
   ▼
API Gateway
   │
   ▼
AWS Lambda
   │
   ▼
Amazon SES
   │
   ▼
Verified Email
```

📂 Project Folder:

Projects/
├── Project-01-Static-Website-S3-CloudFront/
├── Project-02-Linux-Server-Setup-EC2/
└── Project-03-Serverless-Contact-Form/
└── Project-04-RDS-Database/
---

#  Skills Progress
## AWS Services

- ✅ Amazon S3
- ✅ Amazon CloudFront
- ✅ AWS IAM
- ✅ Amazon EC2
- ✅ AWS Lambda
- ✅ Amazon API Gateway
- ✅ Amazon SES
- ✅ Amazon CloudWatch
- ✅Amazon RDS
- ✅ Amazon VPC
- ⏳ Route 53
- ⏳ Amazon ECS
- ⏳ Amazon EKS
- ⏳ Amazon ECR
- ⏳ DynamoDB
- ⏳ Secrets Manager
- ⏳ Auto Scaling
- ⏳ Application Load Balancer (ALB)
- ⏳ AWS Config
- ⏳ GuardDuty
- ⏳ Security Hub

---

## DevOps Tools

- ✅ Git
- ✅ GitHub
- ✅ AWS CLI
- ✅ Node.js
- ⏳ GitHub Actions
- ⏳ Docker
- ⏳ Terraform
- ⏳ Kubernetes
- ⏳ Helm
- ⏳ ArgoCD

## 🏆 Certification Alignment

This learning journey supports hands-on preparation for:

* AWS Certified Cloud Practitioner
* AWS Certified Solutions Architect – Associate
* AWS Certified Developer – Associate
* AWS Certified SysOps Administrator – Associate
* AWS Certified DevOps Engineer – Professional

---

## 🚀 Current Milestone

After completing the first three projects, I have gained hands-on experience with:

- Static website hosting using Amazon S3 and CloudFront.
- Linux server provisioning and configuration on Amazon EC2.
- Secure server administration using IAM Roles and AWS Systems Manager.
- Reverse proxy configuration with Nginx.
- Monitoring infrastructure with Amazon CloudWatch.
- Building serverless applications using AWS Lambda.
- Creating REST APIs with Amazon API Gateway.
- Sending transactional emails using Amazon SES.
- Developing and deploying Node.js applications.
- Technical documentation, troubleshooting, Git, and GitHub workflows.

##  Acknowledgements

This journey is part of my participation in the **Women Innovating in Cloud Africa (WICA)** Mentorship Program, where I was selected as a mentee for the inaugural cohort.

Special thanks to my mentor, **Olamide Kosile**, for providing guidance, learning resources, and a structured project roadmap that supports practical skill development in Cloud Engineering and DevOps.

---

##  Disclaimer

This repository is intended for educational and portfolio purposes. AWS resources are deployed only for learning and are cleaned up after each project to encourage responsible cloud usage and cost management.

---

Cloud engineering isn't mastered by watching tutorials—it's mastered by building, breaking, fixing, documenting, and repeating. Every project in this repository represents one more step toward becoming a professional Cloud Engineer.