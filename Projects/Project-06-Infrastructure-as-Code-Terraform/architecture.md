# Project 06 Architecture

## Overview

Project 06 uses Terraform to provision a modular AWS environment containing networking, compute, database, and remote state infrastructure.

## High-Level Architecture

```text
                           Internet
                              |
                              v
                      Internet Gateway
                              |
                              v
                      Public Route Table
                         /          \
                        /            \
               Public Subnet 1   Public Subnet 2
                       |
                       v
                EC2 Web Server
                 Amazon Linux
                 Apache :80
                       |
                       | PostgreSQL :5432
                       v
                 PostgreSQL RDS
                       |
                  DB Subnet Group
                    /         \
                   /           \
          Private Subnet 1  Private Subnet 2
```

## Network Design

VPC CIDR:

```text
10.0.0.0/16
```

Public subnets:

```text
10.0.1.0/24
10.0.2.0/24
```

Private subnets:

```text
10.0.11.0/24
10.0.12.0/24
```

The subnets span two Availability Zones.

## Public Networking

The public subnets are associated with a public route table containing:

```text
0.0.0.0/0 -> Internet Gateway
```

This provides Internet connectivity to resources that meet the required addressing and Security Group conditions.

The EC2 web server is deployed into the first public subnet.

## Private Networking

The private subnets use a separate route table.

No NAT Gateway or default Internet route was added to the private route table for this project.

The RDS database uses the private subnet architecture and is configured with:

```text
publicly_accessible = false
```

## EC2

The EC2 instance uses Amazon Linux 2023.

Terraform `user_data` automatically:

1. Installs Apache.
2. Enables Apache.
3. Starts the service.
4. Creates a test webpage.

IMDSv2 is required through the instance metadata configuration.

The EC2 Security Group permits inbound HTTP traffic on TCP port 80.

Public SSH access is not configured.

## RDS

The database uses PostgreSQL.

Security-related settings include:

```text
storage_encrypted = true
publicly_accessible = false
manage_master_user_password = true
```

The database uses an RDS DB subnet group containing the private subnets.

The design restricts database access through VPC Security Group relationships rather than exposing PostgreSQL directly to the Internet.

## Remote State Architecture

```text
Developer Workstation
        |
        | Terraform
        v
      AWS
        |
        +---- VPC / EC2 / RDS
        |
        `---- S3 Remote State
                |
                +-- Encryption
                +-- Versioning
                +-- Block Public Access
                `-- Native state locking
```

Terraform uses an S3 backend with:

```hcl
encrypt      = true
use_lockfile = true
```

This provides centralized Terraform state storage and protects concurrent state operations.

## Module Relationships

```text
Root Module
    |
    +---- VPC Module
    |       |
    |       +-- VPC ID
    |       +-- Public Subnet IDs
    |       `-- Private Subnet IDs
    |
    +---- EC2 Module
    |       |
    |       +-- Instance ID
    |       +-- Public IP
    |       `-- Security Group ID
    |
    `---- RDS Module
            |
            +-- DB Instance
            +-- DB Subnet Group
            `-- Database outputs
```

Terraform outputs allow modules to pass dynamically generated AWS resource information to other parts of the configuration.

## Security Design

The architecture follows several security principles:

- Database resources remain private.
- Database storage is encrypted.
- Database passwords are not hardcoded.
- Public SSH exposure is avoided.
- IMDSv2 is required.
- State storage is encrypted.
- State storage blocks public access.
- Sensitive Terraform files are excluded from Git.
- Infrastructure dependencies are managed automatically by Terraform.