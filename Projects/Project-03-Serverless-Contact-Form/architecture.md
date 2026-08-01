# Architecture

## Solution Overview

This project implements a serverless contact form using AWS managed services. A user submits a contact form through a static HTML webpage. The request is sent to Amazon API Gateway, which invokes an AWS Lambda function. The Lambda function validates the request and uses Amazon Simple Email Service (SES) to send the form contents as an email to a verified recipient.

Because the application is serverless, there are no virtual machines or web servers to provision, patch, or maintain. AWS automatically manages the underlying infrastructure and executes the function only when a request is received.

---

## Architecture Diagram

```text
                   +----------------------+
                   |      End User        |
                   +----------+-----------+
                              |
                              | HTTP POST
                              v
                 +---------------------------+
                 | Static HTML Contact Form  |
                 +------------+--------------+
                              |
                              | API Request
                              v
                  +--------------------------+
                  |   Amazon API Gateway     |
                  +------------+-------------+
                               |
                               | Invoke
                               v
                   +--------------------------+
                   |      AWS Lambda          |
                   | ContactFormHandler       |
                   +------------+-------------+
                                |
                                | Send Email
                                v
              +----------------------------------+
              | Amazon Simple Email Service (SES)|
              +------------+---------------------+
                           |
                           | Email Delivery
                           v
                 +--------------------------+
                 | Verified Email Address   |
                 +--------------------------+
```

---

## Request Flow

1. A user completes and submits the contact form.
2. The form sends an HTTP POST request to Amazon API Gateway.
3. API Gateway invokes the AWS Lambda function.
4. Lambda validates the submitted data.
5. Lambda calls Amazon SES to send an email.
6. SES delivers the email to the verified recipient.
7. Lambda returns a success or error response to the frontend.

---

## AWS Services Used

| AWS Service | Purpose |
|-------------|---------|
| AWS Lambda | Executes the backend code when the contact form is submitted. |
| Amazon API Gateway | Exposes a REST API endpoint and forwards requests to Lambda. |
| Amazon SES | Sends email notifications generated from the contact form. |
| AWS IAM | Grants Lambda permission to send emails through SES. |
| Amazon CloudWatch | Stores Lambda logs for monitoring and troubleshooting. |

---

## Architecture Characteristics

- Serverless architecture
- Event-driven execution
- Fully managed AWS services
- No server administration
- Scalable on demand
- Pay-per-use pricing model
- Secure communication through IAM permissions

---

## Key Takeaway

Unlike Project 2, where the application ran continuously on an Amazon EC2 instance managed by the user, this project uses a serverless architecture. AWS Lambda runs the application code only when the contact form is submitted, eliminating the need to provision, maintain, or monitor servers while still providing a scalable and reliable backend.