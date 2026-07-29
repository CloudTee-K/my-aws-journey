# Project 02: Architecture

## Architecture Overview

This project deploys a Linux-based web application on an Amazon EC2 instance using automated provisioning with EC2 User Data.

The deployment includes secure access, automated software installation, web server configuration, application hosting, and monitoring services.

---

## Architecture Components

### Amazon EC2

- Ubuntu Server 22.04 LTS
- Instance type: t3.micro
- Hosts the Flask web application.

---

### Security Group

Inbound Rules:

- SSH (22)
- HTTP (80)
- HTTPS (443)

Controls network access to the EC2 instance.

---

### IAM Role

Role Name:

`Project2-EC2-Role`

Attached Policies:

- AmazonSSMManagedInstanceCore
- CloudWatchAgentServerPolicy

Provides secure permissions without storing AWS credentials on the instance.

---

### EC2 User Data

Automates server provisioning by:

- Updating packages
- Installing Python
- Creating a virtual environment
- Installing Flask
- Installing Nginx
- Deploying the application
- Configuring Nginx as a reverse proxy
- Starting required services

---

### Flask Application

Runs on:

- Port 8080

Serves the sample web application.

---

### Nginx

Runs on:

- Port 80

Acts as a reverse proxy by forwarding HTTP requests to the Flask application.

---

### AWS Systems Manager Session Manager

Provides secure shell access to the EC2 instance without requiring SSH.

---

### Amazon CloudWatch

Collects instance metrics including:

- CPU Utilization
- Network Activity
- Disk Metrics (CloudWatch Agent)

---

## Architecture Flow

Internet User

↓

EC2 Public IP

↓

Nginx (Port 80)

↓

Reverse Proxy

↓

Flask Application (Port 8080)

↓

Ubuntu EC2 Instance

---

## Notes

Although local testing confirmed successful communication between Nginx and the Flask application, the public browser continued displaying the default Nginx page. This behavior has been documented for further investigation.