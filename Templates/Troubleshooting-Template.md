#  Troubleshooting Log

## Project Information

**Project Number:** 01

**Project Name:** Static Website Hosting with Amazon S3 and CloudFront

**Date:** July 2026

**Environment:**

- **AWS Region:** us-east-1
- **Operating System:** Windows 10
- **Tools Used:**
  - AWS Management Console
  - AWS CLI v2
  - PowerShell
  - Git
  - GitHub

---

#  Issue Summary

## Problem Description

During the deployment of the static website, I encountered several issues related to AWS permissions, CLI authentication, and CloudFront configuration. Each issue was investigated, resolved, and documented.

---

# Error 1 – Missing S3 Bucket Creation Permission

### Error Message

```text
Failed to create bucket.

To create a bucket, the s3:CreateBucket permission is required.
```

---

##  Investigation Process

### Initial Checks

- Verified that I was signed in with the correct AWS account.
- Confirmed the AWS region.
- Checked my IAM user permissions.
- Compared my permissions against the project requirements.

### Commands Used for Diagnosis

```bash
aws iam get-user
aws configure list
```

---

##  Root Cause Analysis

My IAM user did not have permission to create Amazon S3 buckets (`s3:CreateBucket`).

---

##  Solution Implemented

### Steps Taken

- Updated the IAM permissions for my AWS user.
- Refreshed the AWS Console.
- Created the bucket again successfully.

---

##  Verification

Successfully created:

```text
cloudtee-static-website-2026
```

---

##  Lessons Learned

AWS Identity and Access Management (IAM) permissions determine what resources a user can create or modify. Even an authenticated user cannot perform actions without the required permissions.

---

##  Prevention

- Verify IAM permissions before beginning a project.
- Apply the principle of least privilege while ensuring required permissions are available.

---

#  Error 2 – Invalid AWS Security Token

### Error Message

```text
An error occurred (InvalidClientTokenId) when calling the GetCallerIdentity operation:
The security token included in the request is invalid.
```

---

##  Investigation Process

### Initial Checks

- Confirmed AWS CLI was installed.
- Checked the configured credentials.
- Verified the configured AWS region.
- Reviewed the shared credentials file.

### Commands Used

```bash
aws configure list
aws sts get-caller-identity
```

---

##  Root Cause Analysis

The AWS CLI was using invalid or expired access keys.

---

##  Solution Implemented

Reconfigured the AWS CLI using:

```bash
aws configure
```

Entered:

- AWS Access Key ID
- AWS Secret Access Key
- Region: us-east-1
- Output: json

---

##  Verification

Successfully executed:

```bash
aws sts get-caller-identity
```

and received my AWS Account ID and IAM User ARN.

---

##  Lessons Learned

Authentication problems are often caused by incorrect or expired credentials rather than AWS service failures.

---

##  Prevention

- Verify AWS credentials before starting a project.
- Rotate access keys when necessary.
- Avoid storing credentials in public repositories.

---

#  Issue 3 – Selecting the Correct S3 Endpoint for CloudFront

## Problem Description

While creating the CloudFront distribution, it was initially unclear whether to use the S3 REST endpoint or the S3 Static Website endpoint.

---

##  Root Cause Analysis

CloudFront can use different origin types. For this project, the origin needed to be the **S3 Static Website Endpoint**, not the REST endpoint.

---

##  Solution Implemented

Configured CloudFront to use:

```text
cloudtee-static-website-2026.s3-website-us-east-1.amazonaws.com
```

with the Origin Protocol Policy set to **HTTP Only**.

---

##  Verification

- CloudFront distribution deployed successfully.
- Website loaded over HTTPS.
- CSS and JavaScript loaded correctly.
- No deployment errors occurred.

---

##  Lessons Learned

Understanding the difference between S3 REST endpoints and S3 Static Website endpoints is essential when configuring CloudFront.

---

##  Prevention

- Read the project documentation carefully before configuring CloudFront.
- Verify the selected origin before creating the distribution.

---

#  Related Resources

- AWS S3 Documentation
- AWS CloudFront Documentation
- AWS IAM Documentation
- AWS CLI Documentation