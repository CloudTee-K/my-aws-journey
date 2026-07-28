#  Architecture Documentation

# Project Information

**Project Number:** 01

**Project Name:** Static Website Hosting with Amazon S3 and CloudFront

**Architecture Version:** 1.0

**Date Created:** July 2026

---

#  Architecture Overview

## Purpose

This architecture demonstrates how to deploy a globally accessible static website using Amazon S3 for storage and Amazon CloudFront as a Content Delivery Network (CDN).

The solution provides a highly available, scalable, and cost-effective method for hosting static web content while improving performance through caching at AWS edge locations.

---

#  Architecture Diagram

```text
                    Internet Users
                           │
                           ▼
              Amazon CloudFront (CDN)
             HTTPS • Edge Caching • CDN
                           │
                    HTTP (Origin Request)
                           │
                           ▼
        Amazon S3 Static Website Endpoint
                           │
                           ▼
      ┌──────────────────────────────────┐
      │           Website Files          │
      │                                  │
      │  index.html                      │
      │  contact.html                    │
      │  css/styles.css                  │
      │  js/main.js                      │
      └──────────────────────────────────┘
```

---

#  System Flow

1. A user enters the website URL.
2. The request is routed to Amazon CloudFront.
3. CloudFront checks whether the requested content is already cached at the nearest edge location.
4. If cached, CloudFront immediately returns the content to the user.
5. If not cached, CloudFront requests the files from the Amazon S3 Static Website Endpoint.
6. Amazon S3 returns the requested website files.
7. CloudFront caches the content and delivers it securely over HTTPS.
8. Future users receive the cached content from the nearest AWS edge location, reducing latency.

---

#  AWS Components

| AWS Service | Role in Architecture |
|-------------|----------------------|
| Amazon S3 | Stores static website files |
| Amazon CloudFront | Delivers content globally using edge locations |
| AWS IAM | Controls permissions for AWS resources |

---

#  Component Details

## Component 1: Amazon S3

### Purpose

Stores all website assets.

### Configuration

- Static Website Hosting Enabled
- Public Read Bucket Policy
- Region: us-east-1

### Why this service was chosen

Amazon S3 provides durable, highly available, and cost-effective object storage that is ideal for hosting static websites.

---

## Component 2: Amazon CloudFront

### Purpose

Distributes website content globally with low latency.

### Configuration

- Origin: Amazon S3 Static Website Endpoint
- Viewer Protocol Policy: Redirect HTTP to HTTPS
- Default Root Object: index.html

### Why this service was chosen

CloudFront improves website performance by caching content at AWS edge locations while providing secure HTTPS access.

---

## Component 3: AWS IAM

### Purpose

Controls access to AWS resources.

### Configuration

IAM User with permissions required to manage Amazon S3 and Amazon CloudFront resources.

### Why this service was chosen

IAM enables secure authentication and authorization while following the principle of least privilege.

---

#  Security Design

Security measures implemented:

- IAM permissions restricted to authorized users.
- Public access limited to `s3:GetObject` for website content.
- HTTPS enforced through Amazon CloudFront.
- AWS credentials stored securely using AWS CLI configuration.
- No AWS Access Keys or Secret Keys stored in the GitHub repository.

---

# Scalability Considerations

This architecture can easily support growth because:

- Amazon S3 automatically scales to store virtually unlimited objects.
- Amazon CloudFront automatically scales to handle increasing traffic.
- AWS edge locations reduce latency for users worldwide.
- Static content is cached, reducing load on the origin.

---

#  Reliability & Availability

The architecture provides high availability through:

- Amazon S3's high durability for stored objects.
- Amazon CloudFront's globally distributed edge network.
- Automatic content caching.
- Managed AWS infrastructure with no servers to maintain.

---

#  Cost Optimization

## AWS Resources Used

- Amazon S3
- Amazon CloudFront

## Cost Optimization Measures

- Used AWS Free Tier eligible resources where possible.
- Uploaded only required website assets.
- Avoided unnecessary services such as Route 53 and ACM since no custom domain was used.
- Planned cleanup of unused resources after project completion.

---

#  Design Decisions & Trade-offs

## Decision 1

**Choice**

Use Amazon S3 Static Website Hosting.

**Reason**

Provides a simple, serverless solution for hosting static websites.

**Trade-off**

Supports only static content and cannot execute server-side code.

---

## Decision 2

**Choice**

Use Amazon CloudFront as the CDN.

**Reason**

Improves global performance and enables HTTPS delivery.

**Trade-off**

Content updates may require cache invalidation before users receive the latest version.

---

#  Testing & Validation

The architecture was validated by:

- Successfully loading the website through the Amazon S3 Website Endpoint.
- Successfully accessing the website through the Amazon CloudFront HTTPS domain.
- Verifying that CSS styling loaded correctly.
- Verifying JavaScript functionality.
- Confirming no deployment errors occurred.

---

#  Key Learnings

- How Amazon S3 hosts static websites.
- How Amazon CloudFront caches content globally.
- The difference between S3 Website Endpoints and REST Endpoints.
- How HTTPS is provided through CloudFront.
- How IAM permissions affect AWS resource creation.
- The importance of documenting cloud architecture.

---

# Future Improvements

Potential production enhancements include:

- Register a custom domain name.
- Configure Amazon Route 53 DNS.
- Request an ACM SSL/TLS certificate.
- Implement CloudFront Origin Access Control (OAC).
- Restrict direct public access to the S3 bucket.
- Automate deployments using GitHub Actions.
- Add CloudWatch monitoring and logging.
- Deploy infrastructure using Terraform.