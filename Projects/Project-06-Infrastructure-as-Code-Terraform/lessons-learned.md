# Project 06 Lessons Learned

## 1. Infrastructure as Code Makes Infrastructure Reproducible

Terraform allows infrastructure to be represented as code rather than relying entirely on manual AWS Console configuration.

This makes infrastructure easier to:

- Review
- Reproduce
- Version
- Troubleshoot
- Document
- Destroy safely

---

## 2. Modules Improve Infrastructure Organization

Separating the infrastructure into:

```text
VPC
EC2
RDS
```

made the Terraform configuration easier to understand.

Each module has a clear responsibility.

The root module connects them together.

---

## 3. Variables Make Modules Reusable

Instead of hardcoding every value inside modules, variables allow values such as:

- VPC CIDR
- Subnet CIDRs
- Project name
- VPC ID
- Subnet IDs
- EC2 instance type

to be supplied externally.

This improves reuse and maintainability.

---

## 4. Outputs Connect Terraform Modules

AWS-generated resource IDs are not known before deployment.

Terraform outputs allow one module to expose information that another module needs.

For example:

```text
VPC Module
     |
     `---- Public Subnet ID ----> EC2 Module
```

This avoids manually copying resource IDs between infrastructure components.

---

## 5. `terraform validate` and `terraform plan` Serve Different Purposes

`terraform validate` checks whether the Terraform configuration is structurally valid.

`terraform plan` goes further by evaluating the proposed infrastructure changes.

A configuration passing `terraform validate` does not mean the intended infrastructure is definitely included in the deployment.

This became clear when the configuration validated successfully while the RDS module was initially missing from the root deployment plan.

---

## 6. Always Read the Terraform Plan

The first plan contained:

```text
14 to add
```

Reviewing the plan revealed that RDS was missing.

After fixing the module configuration, the final plan became:

```text
17 to add
```

The lesson is:

> Never run `terraform apply` simply because `terraform validate` succeeded.

Review the proposed resources first.

---

## 7. Remote State Is Important

Terraform state contains the relationship between Terraform configuration and real infrastructure.

Using an S3 backend provides centralized remote state instead of relying only on a local state file.

Versioning and encryption improve state protection.

Native S3 state locking helps protect state from concurrent Terraform operations.

---

## 8. Security Should Be Part of the Architecture

Security controls were designed into the infrastructure rather than added only after deployment.

Examples include:

- Private RDS networking
- RDS storage encryption
- AWS-managed RDS master password
- No public SSH rule
- IMDSv2 enforcement
- S3 Block Public Access
- Encrypted remote state
- Git exclusions for potentially sensitive files

---

## 9. Private and Public Subnets Have Different Purposes

The EC2 web server needs to serve HTTP traffic, so it is placed in the public portion of the architecture.

The database does not need direct Internet exposure, so RDS uses private subnets.

This follows a common multi-tier architecture principle:

```text
Internet-facing resources -> Public tier

Internal databases -> Private tier
```

---

## 10. NAT Gateway Is Not Always Necessary

A NAT Gateway was intentionally not created for this project.

The private RDS database did not require general outbound Internet connectivity for the lab.

Avoiding unnecessary infrastructure:

- Reduces complexity
- Reduces cost
- Reduces unnecessary network paths

---

## 11. Automation Can Configure Servers at Launch

EC2 user data automatically installed and started Apache.

Terraform therefore handled both infrastructure provisioning and basic instance bootstrap configuration.

The successful web response proved that the automated startup configuration worked.

---

## 12. Troubleshooting Is Part of Infrastructure Engineering

Several issues occurred during the project:

- AWS CLI authentication
- Terraform module initialization
- PowerShell command parsing
- Missing RDS module integration
- Incorrect nested RDS module configuration

The useful troubleshooting pattern was:

```text
Read error
    |
Identify affected component
    |
Inspect configuration
    |
Correct smallest issue
    |
Format
    |
Initialize if necessary
    |
Validate
    |
Plan
    |
Verify
```

---

## Final Reflection

Project 06 moved beyond manually creating individual AWS resources.

It demonstrated how networking, compute, databases, security controls, automation, and Terraform state management can be represented as a single version-controlled infrastructure project.

The most important lesson was not simply learning Terraform syntax. It was learning how infrastructure components depend on one another and how Terraform can manage those relationships in a repeatable and auditable way.