# Project 06 Troubleshooting

## 1. AWS CLI Authentication Failure

### Problem

Before Terraform could communicate with AWS, AWS CLI authentication failed.

The following command could not initially retrieve the caller identity:

```powershell
aws sts get-caller-identity
```

Attempts to authenticate using AWS CLI login also failed.

### Cause

Valid AWS CLI credentials were not configured for the local environment.

### Resolution

An IAM access key was configured locally using:

```powershell
aws configure
```

The AWS region was configured as:

```text
us-east-1
```

Authentication was then verified using:

```powershell
aws sts get-caller-identity
```

The command completed successfully.

### Security Consideration

AWS access keys must never be committed to GitHub.

The credential itself is intentionally excluded from project documentation.

---

## 2. Terraform Module Not Installed

### Problem

After adding the VPC module to the root configuration:

```text
Error: Module not installed
```

Terraform instructed that initialization was required.

### Cause

A new module had been introduced after the previous Terraform initialization.

### Resolution

Ran:

```powershell
terraform init
```

Terraform discovered the local module and initialized it successfully.

### Lesson

Run `terraform init` again when module or backend configuration changes.

---

## 3. Terraform Plan Command / PowerShell Parsing Issue

### Problem

An attempt to save a Terraform plan produced:

```text
Error: Too many command line arguments
```

A later terminal paste caused PowerShell to enter multiline input and interpret Terraform output as PowerShell code.

This produced:

```text
Missing opening '(' after keyword 'for'.
```

### Cause

Terminal output and prompt text were accidentally included with the intended command.

PowerShell attempted to execute the pasted text.

### Resolution

Returned to the normal PowerShell prompt and manually executed:

```powershell
terraform plan
```

The plan completed successfully.

### Lesson

Only copy the actual command into PowerShell.

Do not copy:

- `PS C:\...>`
- `>>`
- Terraform explanatory output

---

## 4. RDS Missing From Terraform Plan

### Problem

The first successful Terraform plan reported:

```text
Plan: 14 to add, 0 to change, 0 to destroy.
```

EC2 and VPC resources appeared, but RDS resources were missing.

### Investigation

The plan was filtered to inspect expected resource types.

RDS resources did not appear.

### Cause

The RDS module had not been correctly integrated into the root Terraform configuration.

### Resolution

The root `module "rds"` block was added and the module configuration was reviewed.

---

## 5. Nested RDS Module Error

### Problem

After adding RDS, Terraform initialization returned errors including:

```text
- rds.rds in
```

and:

```text
Error: Unreadable module directory
```

Terraform pointed to:

```text
modules\rds\outputs.tf
```

### Cause

The root RDS module block had accidentally been placed inside the RDS module output file.

Terraform therefore interpreted the RDS module as attempting to call another nested RDS module.

### Resolution

`modules/rds/outputs.tf` was corrected so that it contained only output blocks.

The `module "rds"` block remained only in the root `main.tf`.

Terraform was then reinitialized:

```powershell
terraform init
terraform fmt -recursive
terraform validate
terraform plan
```

### Result

The final plan became:

```text
Plan: 17 to add, 0 to change, 0 to destroy.
```

The RDS resources and RDS output were then included correctly.

### Lesson

Root module calls belong in the root Terraform configuration.

Files inside a reusable child module should define that module's resources, variables, data sources, and outputs rather than recursively calling the root module configuration.

---

## 6. Terraform State Lock Messages

During Terraform operations, messages similar to the following appeared:

```text
Acquiring state lock. This may take a few moments...
```

and:

```text
Releasing state lock. This may take a few moments...
```

These were normal.

The project uses native S3 state locking through:

```hcl
use_lockfile = true
```

Terraform uses the lock to reduce the risk of concurrent state modifications.

---

## Final Troubleshooting Outcome

All blocking issues were resolved.

Final Terraform deployment:

```text
17 added, 0 changed, 0 destroyed
```

The EC2 web server responded successfully, remote state was verified, and the RDS configuration was successfully represented in the deployed infrastructure.