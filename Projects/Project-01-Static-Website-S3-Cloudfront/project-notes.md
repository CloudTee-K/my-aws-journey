# Project 01: Static Website Hosting with Amazon S3 and CloudFront

##  Project Overview

This project focuses on hosting a static website using Amazon Simple Storage Service (S3) and delivering the website globally using Amazon CloudFront.

The goal is to understand how AWS provides scalable, highly available, and secure solutions for hosting static web content.

---

#  Project Objectives

By completing this project, I aim to learn:

- How to create and configure an Amazon S3 bucket.
- How to host static website files on AWS.
- How to configure Amazon CloudFront as a Content Delivery Network (CDN).
- How AWS handles content delivery globally.
- How to manage permissions and security configurations.
- How to monitor costs and clean up resources after deployment.

---

# Architecture Overview

The architecture consists of:

User → CloudFront Distribution → S3 Bucket → Website Files

The user requests the website through CloudFront, which retrieves content from the S3 bucket and delivers it through AWS edge locations worldwide.

---

#  AWS Services Used

| Service | Purpose |
|---------|---------|
| Amazon S3 | Stores website files |
| Amazon CloudFront | Global content delivery and caching |
| AWS IAM | Manages permissions and access control |
| AWS Certificate Manager (ACM) | HTTPS certificate management (future configuration) |

---

#  What I Learned

## Concepts Learned

- Static website hosting.
- Object storage concepts.
- CDN architecture.
- AWS permissions and security.

## Technical Skills Developed

- AWS Console navigation.
- AWS CLI usage.
- Cloud resource management.
- Deployment documentation.

---

#  Deployment Process

- Created a globally unique Amazon S3 bucket in the us-east-1 region and configured it as the storage location for the static website.

- Enabled static website hosting on the S3 bucket by specifying index.html as both the index and error document. This allows Amazon S3 to serve the website files directly over HTTP.

- Applied a bucket policy granting public read access (s3:GetObject) to all objects within the S3 bucket. This allows browsers to retrieve website files while preventing unauthorized modifications.

- Uploaded the website assets to Amazon S3 while preserving the directory structure. Verified that the website loads correctly from the S3 static website endpoint.

- Created an Amazon CloudFront distribution with the S3 static website endpoint as the origin. Configured CloudFront to redirect all HTTP requests to HTTPS and set index.html as the default root object.

## Project Completion Summary

### Outcome

Successfully deployed a static website using Amazon S3 and Amazon CloudFront.

### AWS Services Used

- Amazon S3
- Amazon CloudFront
- AWS IAM

### Skills Acquired

- Creating and configuring S3 buckets
- Static website hosting
- Bucket policies
- Object management
- CloudFront distributions
- HTTPS delivery
- CDN concepts
- Website deployment


#  Deployment Process

## Step 1 – Prepare the AWS Environment

- Installed and verified the AWS CLI.
- Configured AWS CLI credentials using `aws configure`.
- Verified authentication using:

```bash
aws sts get-caller-identity
```

---

## Step 2 – Create and Configure the Amazon S3 Bucket

- Created a globally unique S3 bucket named:

```
cloudtee-static-website-2026
```

- Selected the **us-east-1** region.
- Disabled **Block Public Access** for static website hosting.
- Enabled Static Website Hosting.
- Configured:

```
Index document: index.html
Error document: index.html
```

---

## Step 3 – Configure Bucket Policy

Applied a bucket policy granting public read access (`s3:GetObject`) to all website files stored in the bucket.

This allows visitors to access the website while preventing unauthorized modifications.

---

## Step 4 – Upload Website Files

Uploaded the following project files while preserving the directory structure:

```
index.html
contact.html
css/styles.css
js/main.js
```

Verified that the website loaded correctly from the Amazon S3 website endpoint.

---

## Step 5 – Configure Amazon CloudFront

Created a CloudFront distribution using the Amazon S3 Static Website Endpoint as the origin.

Configured:

- Viewer Protocol Policy: Redirect HTTP to HTTPS
- Default Root Object: index.html
- Cached website content at AWS edge locations globally

After deployment completed, verified that the website was accessible through the CloudFront HTTPS URL.

---

## Step 6 – Route 53 (Optional)

Route 53 configuration was not implemented because this project did not use a custom domain name.

Instead, the website was successfully accessed using the default Amazon CloudFront domain.


##  Challenges Faced

### 1. Insufficient IAM Permissions

While creating the S3 bucket, I received an error indicating that the `s3:CreateBucket` permission was missing.

**Resolution**

Updated my IAM user permissions and retried the operation successfully.

---

### 2. Invalid AWS Security Token

Running:

```bash
aws sts get-caller-identity
```

initially returned an `InvalidClientTokenId` error.

**Resolution**

Reconfigured AWS CLI credentials using:

```bash
aws configure
```

and verified the identity successfully.

---

### 3. Understanding S3 Website Endpoints

Initially, it was unclear which S3 endpoint should be used with CloudFront.

**Resolution**

Learned the difference between:

- S3 REST Endpoint
- S3 Static Website Endpoint

Configured CloudFront to use the Static Website Endpoint as required.

##  Troubleshooting Notes

| Issue | Resolution |
|--------|------------|
| Missing `s3:CreateBucket` permission | Updated IAM permissions |
| Invalid AWS credentials | Reconfigured AWS CLI credentials |
| CloudFront deployment delay | Waited until the distribution status changed to **Deployed** |
| Public website accessibility | Applied the appropriate bucket policy allowing `s3:GetObject` |

##  Experiments Performed

During this project I explored several AWS concepts beyond the minimum requirements.

- Tested the website directly through the Amazon S3 Website Endpoint.
- Tested the website through Amazon CloudFront.
- Compared HTTP and HTTPS behavior.
- Observed CloudFront deployment time before the distribution became available.
- Verified CSS and JavaScript assets loaded correctly through CloudFront.

##  Security Considerations

- Never expose AWS Access Keys or Secret Access Keys.
- Applied the principle of least privilege when configuring IAM permissions.
- Granted only `s3:GetObject` permission for public website access.
- Used Amazon CloudFront to deliver content securely over HTTPS.
- Did not expose write permissions to the S3 bucket.


## Cost Considerations

### AWS Resources Used

- Amazon S3
- Amazon CloudFront

### Estimated Cost

Less than **$1** using AWS Free Tier resources.

### Cost Optimization

- Used Free Tier eligible resources.
- Deleted unnecessary resources after testing.
- Configured billing alerts.
- Monitored usage to avoid unexpected charges.

## Screenshots

### Amazon S3 Configuration

- S3 Static Website Hosting
- S3 Bucket Policy
- Uploaded Website Files

### Website Deployment

- Home Page
- Contact Page

### Amazon CloudFront

- Distribution Status
- CloudFront Domain


 ## Key Takeaways

- Successfully deployed my first static website on Amazon S3.
- Learned how Amazon S3 can host static websites.
- Understood the importance of bucket policies for public access.
- Verified proper folder structure is essential for CSS and JavaScript to load correctly.
- Successfully tested the website without deployment errors.

##  Future Improvements

Future enhancements for this project include:

- Register a custom domain name.
- Configure Amazon Route 53 DNS.
- Request an ACM SSL/TLS certificate for the custom domain.
- Implement GitHub Actions for automated deployments.
- Restrict direct S3 bucket access using CloudFront Origin Access Control (OAC).
- Add CloudWatch monitoring and logging.

##  Key Takeaways

- Successfully deployed my first production-style static website on AWS.
- Gained hands-on experience with Amazon S3 static website hosting.
- Learned how Amazon CloudFront improves global performance and enables HTTPS.
- Understood how IAM permissions affect AWS resource creation.
- Learned the importance of bucket policies for secure public access.
- Strengthened my documentation, troubleshooting, and Git workflow throughout the deployment process.