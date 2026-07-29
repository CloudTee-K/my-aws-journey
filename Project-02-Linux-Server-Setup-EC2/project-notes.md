# Project 02: Linux Server Setup on Amazon EC2

## Project Overview

This project focused on deploying and configuring a secure Ubuntu Linux server on Amazon EC2. The deployment included configuring networking, IAM permissions, secure authentication, automated server provisioning using EC2 User Data, and infrastructure monitoring with Amazon CloudWatch.

---

## Deployment Summary

### Step 1

Created an EC2 Security Group allowing inbound SSH (22), HTTP (80), and HTTPS (443).

### Step 2

Created an IAM Role (`Project2-EC2-Role`) with:

- AmazonSSMManagedInstanceCore
- CloudWatchAgentServerPolicy

### Step 3

Created an RSA Key Pair (`project2-key`) for secure instance authentication.

### Step 4

Launched an Ubuntu Server 22.04 LTS EC2 instance using:

- t3.micro
- Default VPC
- Existing Security Group
- IAM Role
- EC2 User Data

### Step 5

Verified the instance reached the Running state and passed all status checks.

### Step 6

Verified that:

- Nginx was installed successfully.
- Flask application was running on port 8080.
- Nginx was configured as a reverse proxy.
- Local application testing using `curl` returned the Flask application successfully.

### Step 7

Connected successfully using AWS Systems Manager Session Manager.

Reviewed the cloud-init logs to verify that the User Data script executed.

### Step 8

Verified that Amazon CloudWatch collected performance metrics for the EC2 instance.

---

## Project Outcome

Successfully deployed and configured a secure Linux server on Amazon EC2.

The server, web application, monitoring, and security configuration were successfully deployed.

An issue remained where the public browser displayed the default Nginx page instead of the Flask application despite successful local verification. This has been documented for further review with my mentor.