# Project 01: Static Website Hosting with Amazon S3 and CloudFront

## 📌 Project Overview

This project focuses on hosting a static website using Amazon Simple Storage Service (S3) and delivering the website globally using Amazon CloudFront.

The goal is to understand how AWS provides scalable, highly available, and secure solutions for hosting static web content.

---

# 🎯 Project Objectives

By completing this project, I aim to learn:

- How to create and configure an Amazon S3 bucket.
- How to host static website files on AWS.
- How to configure Amazon CloudFront as a Content Delivery Network (CDN).
- How AWS handles content delivery globally.
- How to manage permissions and security configurations.
- How to monitor costs and clean up resources after deployment.

---

# 🏗️ Architecture Overview

The architecture consists of:

User → CloudFront Distribution → S3 Bucket → Website Files

The user requests the website through CloudFront, which retrieves content from the S3 bucket and delivers it through AWS edge locations worldwide.

---

# ☁️ AWS Services Used

| Service | Purpose |
|---------|---------|
| Amazon S3 | Stores website files |
| Amazon CloudFront | Global content delivery and caching |
| AWS IAM | Manages permissions and access control |
| AWS Certificate Manager (ACM) | HTTPS certificate management (future configuration) |

---

# 📚 What I Learned

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

# ⚙️ Deployment Process

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

## Step 1:

Prepare AWS environment and verify access.

Commands:

```bash


Step 2:

Create and configure S3 bucket.

Commands:

🚧 Challenges Faced

(To be updated during implementation)

🔧 Troubleshooting Notes

(To be updated when issues occur)

🧪 Experiments Performed

(To be updated)

🔐 Security Considerations
Avoid exposing AWS credentials.
Apply least privilege permissions.
Protect bucket access.
Use HTTPS for secure delivery.


💰 Cost Considerations

Resources used:

Amazon S3 storage
CloudFront data transfer

Cost optimization steps:

Delete unused resources after testing.
Monitor AWS billing.
Use AWS Free Tier where applicable.

📸 Screenshots

(To be added during deployment)


💡 ## Key Takeaways

- Successfully deployed my first static website on Amazon S3.
- Learned how Amazon S3 can host static websites.
- Understood the importance of bucket policies for public access.
- Verified proper folder structure is essential for CSS and JavaScript to load correctly.
- Successfully tested the website without deployment errors.

🚀 Future Improvements

Possible production improvements:

Add custom domain using Route 53.
Enable HTTPS with ACM.
Add CI/CD automation.💡 Key Takeaways
(To be completed after project deployment)

🚀 Future Improvements
Possible production improvements:

Add custom domain using Route 53.

Enable HTTPS with ACM.

Add CI/CD automation.