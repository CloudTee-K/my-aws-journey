# Lessons Learned

This document captures the key concepts, skills, and best practices learned while completing Project 03: Serverless Contact Form with AWS Lambda and Amazon SES.

---

## Serverless Computing

- Learned how serverless applications eliminate the need to provision and manage servers.
- Understood that AWS Lambda executes code only when an event occurs.
- Learned that AWS automatically manages the underlying infrastructure.

---

## Event-Driven Architecture

- Learned that serverless applications respond to events rather than running continuously.
- Understood how a user submitting a contact form triggers the execution of a Lambda function.

---

## AWS Services

### AWS Lambda

**Key Learning**

This section will be updated as the project progresses.

---

### Amazon API Gateway

**Key Learning**

- Learned how Amazon API Gateway exposes AWS Lambda functions as HTTP endpoints.
- Configured a REST API with a POST method.
- Integrated API Gateway with a Lambda function using Lambda proxy integration.
- Enabled CORS to allow browser-based communication with the API.

### Amazon SES

**Key Learning**

- Learned how Amazon SES verifies email identities before allowing emails to be sent.
- Understood that new SES accounts operate in Sandbox Mode, requiring both sender and recipient email addresses to be verified for testing.
- Learned that both the sender and recipient email addresses must be verified while in Sandbox Mode.
- Successfully verified an email identity for use in the project.


### AWS IAM

**Key Learning**

- Learned that AWS Lambda requires an IAM execution role to interact with other AWS services.
- Understood the Principle of Least Privilege by granting only the permissions needed to send emails through Amazon SES.
- Learned the difference between AWS managed policies and custom inline policies.

---


---

### Amazon CloudWatch

**Key Learning**

This section will be updated as the project progresses.

---

### AWS Lambda

**Key Learning**

- Learned that AWS Lambda is a serverless compute service that executes code in response to events.
- Understood that Lambda automatically provisions and manages the underlying infrastructure.
- Learned how to create a Lambda function and associate it with an IAM execution role.
- Learned how AWS Lambda executes backend code without managing servers.
- Packaged a Node.js application and its dependencies into a deployment package.
- Deployed a Lambda function using a ZIP archive.
- Configured environment variables to securely store application configuration.

### Final Takeaway

This project demonstrated how multiple AWS services can be combined to build a fully serverless application. I gained practical experience deploying a Node.js Lambda function, exposing it with API Gateway, securely granting permissions through IAM, sending emails with Amazon SES, and connecting a static frontend to a serverless backend.