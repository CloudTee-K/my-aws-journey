# Project 06 — Infrastructure as Code with Terraform

## Project Overview

This project focuses on using Terraform to provision and manage AWS infrastructure through Infrastructure as Code (IaC).

Instead of manually creating resources through the AWS Management Console, the infrastructure will be defined using HashiCorp Configuration Language (HCL). This makes the infrastructure reproducible, version-controlled, easier to review, and easier to manage consistently.

The project will use reusable Terraform modules to provision networking, compute, and database resources on AWS.

## Project Objectives

The objectives of this project are to:

- Understand Infrastructure as Code principles.
- Learn Terraform and HCL configuration structure.
- Provision AWS resources using Terraform.
- Organize infrastructure using reusable Terraform modules.
- Use variables and outputs to make configurations reusable.
- Store Terraform state remotely in Amazon S3.
- Protect remote state using versioning and encryption.
- Use Terraform state locking to prevent concurrent state modifications.
- Use `terraform plan` to review infrastructure changes before deployment.
- Validate and format Terraform configuration.
- Manage infrastructure changes through Terraform.
- Destroy infrastructure safely after testing.
- Document the complete implementation and troubleshooting process.

## Planned Architecture

The Terraform configuration will provision:

- Amazon VPC
- Public subnets
- Private subnets
- Route tables
- Security groups
- Amazon EC2
- Amazon RDS PostgreSQL
- Amazon S3 remote state backend

High-level flow:

Terraform CLI
      |
      v
AWS Provider
      |
      +----------------------+
      |                      |
      v                      v
Amazon S3               AWS Infrastructure
Remote State                  |
                              +-- VPC
                              +-- Subnets
                              +-- Route Tables
                              +-- Security Groups
                              +-- EC2
                              +-- RDS PostgreSQL

## Terraform Module Structure

The infrastructure will be separated into reusable modules:

- `vpc` — networking resources
- `ec2` — compute resources
- `rds` — PostgreSQL database resources

The root Terraform configuration will call these modules and pass the required variables between them.

## Planned Terraform Structure

terraform-project/
├── backend.tf
├── main.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars
├── terraform.tfvars.example
└── modules/
    ├── vpc/
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    ├── ec2/
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    └── rds/
        ├── main.tf
        ├── variables.tf
        └── outputs.tf

## Security Considerations

The project will apply security practices including:

- Keeping the Terraform state bucket private.
- Enabling S3 Block Public Access.
- Enabling S3 bucket versioning.
- Encrypting Terraform state at rest.
- Avoiding hard-coded AWS credentials in Terraform files.
- Avoiding hard-coded database passwords.
- Keeping sensitive variable files out of Git.
- Restricting network access through security groups.
- Keeping the RDS database in private networking.
- Reviewing `terraform plan` before applying infrastructure changes.
- Using controlled access between EC2 and RDS.

## Prerequisites

The following prerequisites have been verified:

- Terraform installed: v1.16.2
- AWS CLI installed: v2.36.47
- AWS CLI authentication configured successfully
- AWS region configured: `us-east-1`
- Git installed
- VS Code available
- AWS account available for deployment

## Current Status

Project workspace created.

Documentation structure created.

Terraform and AWS CLI installations verified.

AWS CLI authentication verified successfully using:

`aws sts get-caller-identity`

No AWS infrastructure for Project 06 has been provisioned yet.

## Next Step

Create the Terraform project structure and configure the remote state backend before provisioning the main infrastructure.

## Remote State Backend Setup

An Amazon S3 bucket was created to store the Terraform state remotely.

### Backend Security Configuration

The following controls were verified:

- S3 Block Public Access enabled.
- All four public access block settings set to `true`.
- S3 bucket versioning enabled.
- Server-side encryption enabled using SSE-S3 (`AES256`).
- SSE-C encryption blocked.
- No Terraform state has been stored in the bucket yet.

### Why Remote State Is Used

Remote state allows Terraform state to be stored outside the local development machine.

This provides:

- Centralized state storage.
- Better protection against accidental local state loss.
- State version recovery through S3 versioning.
- Encrypted state storage.
- Support for state locking to prevent concurrent modifications.

The Terraform S3 backend will be configured to use native state locking.


---

## Implementation Summary

Project 06 was successfully implemented using reusable Terraform modules for VPC, EC2, and RDS infrastructure.

### VPC Implementation

The VPC module provisions:

- VPC: `10.0.0.0/16`
- Two public subnets
- Two private subnets
- Internet Gateway
- Public route table
- Private route table
- Route table associations

Public subnet CIDRs:

```text
10.0.1.0/24
10.0.2.0/24
```

Private subnet CIDRs:

```text
10.0.11.0/24
10.0.12.0/24
```

The public route table contains a default route to the Internet Gateway.

The private route table intentionally has no Internet Gateway or NAT Gateway default route.

### EC2 Implementation

The EC2 module provisions an Amazon Linux 2023 web server.

The AMI is dynamically retrieved using an AWS AMI data source rather than hardcoding an AMI ID.

Apache is installed automatically using EC2 user data.

IMDSv2 is required.

The EC2 Security Group allows inbound HTTP traffic on TCP port 80.

Public SSH access was intentionally not enabled.

### RDS Implementation

The RDS module provisions a PostgreSQL database using the private subnet architecture.

Verified security settings:

```text
manage_master_user_password = true
publicly_accessible         = false
storage_encrypted           = true
```

The RDS subnet group uses the two private subnets.

### Terraform Module Integration

The root module connects the infrastructure modules.

VPC outputs are passed to the EC2 and RDS modules instead of manually copying AWS-generated resource IDs.

Example relationship:

```text
VPC Module
   |
   +---- VPC ID ----------> EC2 / RDS
   |
   +---- Public Subnets --> EC2
   |
   `---- Private Subnets -> RDS
```

The EC2 Security Group ID is also passed toward the RDS networking configuration.

---

## Deployment Results

Terraform plan:

```text
Plan: 17 to add, 0 to change, 0 to destroy.
```

Terraform apply:

```text
Apply complete! Resources: 17 added, 0 changed, 0 destroyed.
```

Root outputs successfully returned:

- EC2 instance ID
- EC2 public IP
- Public subnet IDs
- Private subnet IDs
- RDS endpoint
- VPC ID

Specific deployed IDs and addresses are intentionally not documented in the repository notes.

---

## EC2 Web Server Validation

The EC2 web server was tested using:

```powershell
curl.exe http://<EC2-PUBLIC-IP>
```

Response:

```html
<h1>Project 06 - Terraform Infrastructure</h1>
```

This confirmed:

- EC2 launched successfully.
- The instance had working public connectivity.
- Security Group HTTP access worked.
- EC2 user data executed.
- Apache installed and started successfully.
- The webpage was served successfully.

---

## Terraform State Validation

Terraform-managed resources were inspected using:

```powershell
terraform state list
```

The state included resources from the VPC, EC2, and RDS modules.

Outputs were retrieved using:

```powershell
terraform output
```

The S3 backend was also inspected and the Terraform state object was successfully present under the Project 06 state path.

This confirmed that remote Terraform state was functioning after deployment.

---

## RDS Security Validation

The RDS state was inspected to confirm security-related configuration.

Verified:

```text
manage_master_user_password = true
publicly_accessible = false
storage_encrypted = true
```

This ensures the database is not directly exposed to the Internet, database storage is encrypted, and the master password is managed by AWS instead of being hardcoded into Terraform configuration.

---

## Final Core Infrastructure Status

The core Project 06 infrastructure has been successfully:

- Designed
- Defined as code
- Formatted
- Initialized
- Validated
- Planned
- Deployed
- Tested
- State-verified

Remaining lifecycle activities include final screenshots, GitHub publication, and Terraform cleanup.