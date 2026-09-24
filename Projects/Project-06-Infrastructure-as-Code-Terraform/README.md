# Project 06 — Infrastructure as Code with Terraform

## Overview

This project demonstrates how to provision and manage AWS infrastructure using Terraform and Infrastructure as Code (IaC).

Instead of manually creating infrastructure through the AWS Management Console, the environment is defined using reusable Terraform modules.

The deployed architecture includes:

- Custom AWS VPC
- Two public subnets across two Availability Zones
- Two private subnets across two Availability Zones
- Internet Gateway
- Public and private route tables
- EC2 web server
- EC2 Security Group
- Amazon RDS PostgreSQL database
- RDS DB subnet group
- Remote Terraform state stored in Amazon S3
- Native S3 state locking

The project demonstrates modular infrastructure design, networking, security, remote state management, automated EC2 configuration, and Terraform lifecycle operations.

---

## Architecture

```text
                         Internet
                            |
                    Internet Gateway
                            |
                    Public Route Table
                      /             \
             Public Subnet 1    Public Subnet 2
                    |
              EC2 Web Server
                HTTP :80
                    |
                    | PostgreSQL :5432
                    v
              Amazon RDS
               PostgreSQL
                    |
              Private Subnets
                /         \
       Private Subnet 1  Private Subnet 2
```

The EC2 instance is deployed in a public subnet and serves a simple Apache webpage.

The PostgreSQL RDS database is deployed using private subnets and is configured as non-publicly accessible.

---

## Technologies Used

- AWS
- Terraform
- Amazon VPC
- Amazon EC2
- Amazon RDS PostgreSQL
- Amazon S3
- AWS IAM
- Security Groups
- Amazon Linux 2023
- Apache HTTP Server
- PowerShell
- Git
- GitHub

---

## Terraform Structure

```text
terraform-project/
|
|-- backend.tf
|-- main.tf
|-- variables.tf
|-- outputs.tf
|-- terraform.tfvars.example
|
|-- modules/
    |
    |-- vpc/
    |   |-- main.tf
    |   |-- variables.tf
    |   `-- outputs.tf
    |
    |-- ec2/
    |   |-- main.tf
    |   |-- variables.tf
    |   `-- outputs.tf
    |
    `-- rds/
        |-- main.tf
        |-- variables.tf
        `-- outputs.tf
```

This modular structure separates networking, compute, and database infrastructure.

---

## Infrastructure Components

### VPC Module

The VPC module provisions:

- Custom VPC
- Two public subnets
- Two private subnets
- Internet Gateway
- Public route table
- Private route table
- Route table associations

The public route table provides an Internet Gateway route for public resources.

The private route table does not contain a default Internet route.

### EC2 Module

The EC2 module provisions:

- Amazon Linux 2023 EC2 instance
- EC2 Security Group
- Apache HTTP server through EC2 user data
- IMDSv2 enforcement

HTTP traffic on port 80 is permitted to the web server.

Public SSH access was not enabled.

### RDS Module

The RDS module provisions:

- PostgreSQL RDS instance
- DB subnet group using private subnets
- Private database networking
- Encrypted database storage
- AWS-managed master password

The database is configured with:

```text
publicly_accessible = false
storage_encrypted = true
manage_master_user_password = true
```

---

## Remote Terraform State

Terraform state is stored remotely in a dedicated Amazon S3 bucket.

The backend uses:

- S3 remote state
- S3 versioning
- Server-side encryption
- Block Public Access
- Native S3 state locking

The backend uses:

```hcl
use_lockfile = true
```

This avoids storing the main Terraform state only on the local workstation and helps protect infrastructure state during Terraform operations.

The remote state object was successfully verified after deployment.

---

## Security Controls

Security decisions implemented in this project include:

- RDS is not publicly accessible.
- RDS storage encryption is enabled.
- RDS master credentials are managed by AWS.
- Database credentials are not hardcoded in Terraform files.
- PostgreSQL is intended to be accessible through controlled VPC Security Group rules.
- EC2 does not expose SSH publicly.
- EC2 requires IMDSv2.
- Terraform state bucket blocks public access.
- Terraform state bucket uses encryption and versioning.
- `.tfvars`, `.tfstate`, `.pem`, environment files, and Terraform plan files are excluded from Git where appropriate.
- `.terraform.lock.hcl` is retained for reproducible provider dependency selection.

---

## Deployment

Initialize Terraform:

```powershell
terraform init
```

Format the configuration:

```powershell
terraform fmt -recursive
```

Validate the configuration:

```powershell
terraform validate
```

Preview the infrastructure:

```powershell
terraform plan
```

Deploy:

```powershell
terraform apply
```

Terraform successfully deployed:

```text
17 added, 0 changed, 0 destroyed
```

---

## Validation

Terraform validation completed successfully:

```text
Success! The configuration is valid.
```

The EC2 web server was tested using:

```powershell
curl.exe http://<EC2-PUBLIC-IP>
```

Successful response:

```html
<h1>Project 06 - Terraform Infrastructure</h1>
```

Terraform state was verified using:

```powershell
terraform state list
```

Remote state was also confirmed in the configured S3 backend.

---

## Key Learning Outcomes

This project provided practical experience with:

- Infrastructure as Code
- Terraform modules
- Terraform variables and outputs
- Terraform dependency relationships
- AWS VPC networking
- Public and private subnet architecture
- EC2 automation using user data
- RDS private networking
- Security Groups
- Remote Terraform state
- State locking
- Terraform plan/apply workflow
- Infrastructure troubleshooting
- Secure infrastructure design

---

## Cleanup

Terraform-managed infrastructure can be removed using:

```powershell
terraform destroy
```

The remote-state backend should be handled separately and carefully because it contains Terraform state and version history.

---

## Project Status

Core infrastructure deployment and validation: **Completed**

Documentation, screenshots, GitHub publication, and final cleanup are completed as separate project lifecycle steps.