# Project 03: Serverless Contact Form with AWS Lambda and Amazon SES

## Project Overview

In this project, I built a serverless contact form using AWS services. Instead of hosting a backend application on an EC2 instance, the application uses AWS Lambda to process form submissions, Amazon API Gateway to expose an HTTP endpoint, and Amazon Simple Email Service (SES) to send emails.

This project demonstrates how to build event-driven applications without managing servers.

---

## Project Objectives

- Build a serverless backend using AWS Lambda.
- Create an HTTP API using Amazon API Gateway.
- Send emails using Amazon SES.
- Configure IAM permissions following the principle of least privilege.
- Connect a static HTML contact form to a serverless backend.
- Monitor and troubleshoot the application using Amazon CloudWatch.

---

## AWS Services Used

- AWS Lambda
- Amazon API Gateway
- Amazon Simple Email Service (SES)
- AWS Identity and Access Management (IAM)
- Amazon CloudWatch

---

## Architecture

User

↓

Static HTML Contact Form

↓

Amazon API Gateway

↓

AWS Lambda

↓

Amazon SES

↓

Verified Email Address

---

## Project Structure

```
Project-03-Serverless-Contact-Form/
│
├── README.md
├── architecture.md
├── commands-used.md
├── project-notes.md
├── troubleshooting.md
├── lessons-learned.md
│
├── lambda/
│   ├── index.js
│   └── package.json
│
├── frontend/
│   └── contact.html
│
└── deploy.sh
```

---

## Skills Demonstrated

- Serverless Computing
- Event-Driven Architecture
- AWS Lambda
- Amazon API Gateway
- Amazon SES
- IAM Roles and Policies
- CloudWatch Monitoring
- HTTP APIs
- Secure Application Design

---

## Learning Outcomes

By completing this project, I will understand:

- How serverless applications work.
- How Lambda executes code without managing servers.
- How API Gateway exposes backend services.
- How Amazon SES sends emails programmatically.
- How AWS services communicate securely using IAM.
- How to monitor and troubleshoot serverless applications.

---

This project was deployed manually using the AWS Management Console. The optional deploy.sh automation script was not implemented as part of this project.