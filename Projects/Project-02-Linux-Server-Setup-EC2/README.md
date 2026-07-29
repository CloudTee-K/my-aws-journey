#  Project 02: Linux Server Setup on Amazon EC2

##  Project Overview

This project focuses on deploying and configuring a secure Linux server on Amazon Elastic Compute Cloud (EC2). The server hosts a Python Flask web application and demonstrates best practices for launching, securing, and managing compute resources in AWS.

Unlike Project 1, where Amazon S3 handled static website hosting without servers, this project introduces Infrastructure as a Service (IaaS), where I am responsible for provisioning, securing, and managing the virtual server.

---

#  Project Objectives

By completing this project, I aim to learn how to:

- Launch and configure Amazon EC2 instances.
- Create and manage Security Groups.
- Generate and use EC2 Key Pairs.
- Assign IAM Roles to EC2 instances.
- Automate server configuration using EC2 User Data.
- Deploy a Python Flask web application.
- Monitor EC2 performance using Amazon CloudWatch.
- Connect securely using AWS Systems Manager Session Manager.
- Apply AWS security best practices for compute resources.

---

#  Architecture Overview

The solution architecture consists of:

```text
Internet Users
        │
        ▼
Security Group
(Ports 22, 80, 443)
        │
        ▼
Amazon EC2 Instance
(Ubuntu Server 22.04)
        │
 ┌──────┴─────────┐
 ▼                ▼
Flask Web App   User Data Script
```

The EC2 instance serves as the web server. During launch, a User Data script automatically installs required software, configures the operating system, and deploys the Flask application.

---

# AWS Services Used

| AWS Service | Purpose |
|-------------|---------|
| Amazon EC2 | Hosts the Linux virtual server |
| Amazon VPC | Provides networking for the EC2 instance |
| Security Groups | Acts as the virtual firewall |
| AWS IAM | Manages permissions through an IAM Role |
| AWS Systems Manager | Enables secure Session Manager access |
| Amazon CloudWatch | Monitors instance health and performance |

---

#  What I Learned

## Concepts Learned

- Infrastructure as a Service (IaaS)
- Virtual machines in AWS
- EC2 networking fundamentals
- Security Groups
- IAM Roles
- User Data automation
- Cloud monitoring

## Technical Skills Developed

- Launching EC2 instances
- Configuring AWS networking
- Managing IAM Roles
- Deploying Flask applications
- Monitoring AWS resources
- Linux server administration

---

#  Deployment Process

The deployment includes the following stages:

1. Create an EC2 Security Group.
2. Create an IAM Role for EC2.
3. Generate an EC2 Key Pair.
4. Launch an Ubuntu EC2 instance.
5. Attach the Security Group and IAM Role.
6. Configure the server using EC2 User Data.
7. Verify the Flask application.
8. Connect using Session Manager.
9. Monitor the instance in CloudWatch.


---

#  Testing & Validation

The deployment will be validated by confirming:

- EC2 instance reaches the **Running** state.
- Both EC2 status checks pass.
- Flask application loads successfully.
- HTTP requests return expected responses.
- Session Manager connection succeeds.
- CloudWatch metrics are visible.

---

#  Security Considerations

- Restrict SSH access to my public IP whenever possible.
- Apply the principle of least privilege using IAM Roles.
- Never expose AWS credentials.
- Use Session Manager as a secure alternative to SSH when available.
- Remove unused AWS resources after project completion.

---

#  Cost Considerations

AWS resources used:

- Amazon EC2 (t2.micro)
- Amazon EBS
- Amazon CloudWatch

Cost optimization measures:

- Use Free Tier eligible resources.
- Terminate the EC2 instance after testing.
- Delete the Security Group, IAM Role, and Key Pair when the project is complete.
- Monitor AWS Billing Dashboard regularly.

---

#  Screenshots

Deployment evidence will include:

- EC2 Security Group
- IAM Role
- EC2 Key Pair
- Launch Configuration
- Running EC2 Instance
- Instance Details
- Flask Application
- Session Manager
- CloudWatch Metrics

---

# Key Takeaways

- Gained hands-on experience launching and configuring an Ubuntu EC2 instance on AWS.
- Learned how to secure an EC2 instance using Security Groups, IAM Roles, and Key Pairs.
- Understood the importance of EC2 User Data for automating server provisioning and application deployment.
- Successfully used AWS Systems Manager Session Manager to manage an EC2 instance without relying on SSH.
- Configured Amazon CloudWatch to monitor instance performance and verify operational health.
- Learned how Nginx functions as a reverse proxy for a Flask web application.
- Strengthened Linux command-line skills by troubleshooting services, processes, network ports, and web server configurations.
- Recognized the importance of systematic troubleshooting by validating each layer of the deployment stack—from infrastructure and operating system to the web server and application.
- Improved documentation practices by recording deployment steps, troubleshooting activities, architecture, and lessons learned for future reference.

---

#  Future Improvements

Potential production enhancements include:

- Register a custom domain.
- Deploy behind an Application Load Balancer.
- Add HTTPS using AWS Certificate Manager.
- Automate deployments using GitHub Actions.
- Provision infrastructure with Terraform.
- Containerize the application using Docker.
- Deploy to Amazon ECS or Amazon EKS.