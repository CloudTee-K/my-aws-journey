# Project 06 — Commands Used

This document records the main commands used while building Project 06: Infrastructure as Code with Terraform.

## 1. Verify Terraform Installation

```powershell
terraform version

Verified Terraform installation:

-Terraform v1.16.2
-Platform: windows_amd64


2. Verify AWS CLI Installation
aws --version
Verified AWS CLI installation:

-AWS CLI v2.36.47
-Windows AMD64
3. Verify AWS Authentication
aws sts get-caller-identity

The initial attempt failed because no AWS credentials were configured.

After configuring the AWS CLI credentials, the command successfully authenticated the IAM user.

AWS account identifiers are intentionally not documented in this public repository.

4. Configure AWS CLI
aws configure
Configuration used:

-AWS Region: us-east-1
-Output format: json

AWS Access Key ID and Secret Access Key are not stored in this repository.

5. Create Project Documentation Directory
mkdir Projects\Project-06-Infrastructure-as-Code-Terraform
mkdir Screenshots\Project-06


6. Create Documentation Files
New-Item README.md -ItemType File
New-Item project-notes.md -ItemType File
New-Item commands-used.md -ItemType File
New-Item troubleshooting.md -ItemType File
New-Item architecture.md -ItemType File
New-Item lessons-learned.md -ItemType File


7. Create Terraform Project Structure
mkdir terraform-project
mkdir terraform-project\modules
mkdir terraform-project\modules\vpc
mkdir terraform-project\modules\ec2
mkdir terraform-project\modules\rds

Terraform configuration files were then created for the root module and the VPC, EC2, and RDS modules.

8. Verify Terraform Project Structure
tree terraform-project /F

This confirmed that the root Terraform files and module directories were created successfully.

9. Git Repository Verification
git status

Used to verify repository changes before staging or committing files.

Security Notes

-AWS credentials are never committed to Git.
-Terraform state files are excluded from Git.
-Real .tfvars files are excluded because they may contain sensitive values.
-terraform.tfvars.example remains tracked for documentation.
-.terraform.lock.hcl will remain tracked after Terraform initialization.

## 10. Format Terraform Configuration

```powershell
terraform fmt -recursive

Used to automatically format Terraform configuration files according to Terraform's standard formatting rules.

11. Initialize Terraform
terraform init

Terraform initialization successfully:

Configured the Amazon S3 remote backend.
Initialized S3-native state locking.
Downloaded and initialized the AWS provider.
Created the local .terraform working directory.
Created .terraform.lock.hcl for provider dependency consistency.

The .terraform/ directory is excluded from Git, while .terraform.lock.hcl will be committed to version control.

12. Validate Terraform Configuration
terraform validate

Result:

Success! The configuration is valid.

This confirmed that the Terraform configuration created so far is syntactically and structurally valid.


Save it.

This is also a good screenshot checkpoint: capture the terminal showing:

```text
Success! The configuration is valid.


---

## VPC Module Development

Format Terraform files:

```powershell
terraform fmt -recursive
```

Validate Terraform configuration:

```powershell
terraform validate
```

The configuration returned:

```text
Success! The configuration is valid.
```

The VPC module was developed with:

- VPC
- Public subnets
- Private subnets
- Internet Gateway
- Public route table
- Private route table
- Route table associations
- Module outputs

---

## Module Initialization

After adding modules to the root configuration:

```powershell
terraform init
```

Terraform initialized the local VPC, EC2, and RDS modules and reused the provider version recorded in the dependency lock file.

---

## EC2 Module

The EC2 module was created with:

- Amazon Linux AMI lookup
- EC2 Security Group
- EC2 instance
- Apache user data
- IMDSv2 requirement
- EC2 outputs

Configuration was repeatedly checked using:

```powershell
terraform fmt -recursive
terraform validate
```

---

## RDS Module

The RDS module was created with:

- DB subnet group
- PostgreSQL RDS instance
- Private networking
- Storage encryption
- AWS-managed master credentials
- Module outputs

After connecting the module:

```powershell
terraform init
terraform fmt -recursive
terraform validate
```

---

## Infrastructure Planning

Preview infrastructure:

```powershell
terraform plan
```

Successful final plan:

```text
Plan: 17 to add, 0 to change, 0 to destroy.
```

---

## Infrastructure Deployment

Deploy the Terraform configuration:

```powershell
terraform apply
```

Deployment result:

```text
Apply complete! Resources: 17 added, 0 changed, 0 destroyed.
```

---

## EC2 Web Server Test

```powershell
curl.exe http://<EC2-PUBLIC-IP>
```

Successful response:

```html
<h1>Project 06 - Terraform Infrastructure</h1>
```

---

## Terraform State Verification

List Terraform-managed resources:

```powershell
terraform state list
```

Retrieve Terraform outputs:

```powershell
terraform output
```

Verify the remote state object:

```powershell
aws s3 ls s3://<TERRAFORM-STATE-BUCKET>/project-06/
```

The remote `terraform.tfstate` object was successfully present.

---

## RDS Security Verification

Inspect the RDS resource:

```powershell
terraform state show module.rds.aws_db_instance.postgres
```

The relevant configuration confirmed:

```text
manage_master_user_password = true
publicly_accessible = false
storage_encrypted = true
```

---

## Planned Cleanup Command

After completing screenshots and final verification:

```powershell
terraform destroy
```

Infrastructure should be destroyed after the lab to avoid unnecessary AWS resource charges.