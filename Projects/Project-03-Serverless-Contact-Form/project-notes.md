## Project Goal

Build a serverless contact form that accepts user input from a web page and sends the submitted information to a verified email address using AWS Lambda, Amazon API Gateway, and Amazon SES.

---

## Key Concepts

- Serverless Computing
- Event-Driven Architecture
- AWS Lambda
- Amazon API Gateway
- Amazon SES
- IAM Roles and Policies
- CloudWatch Logs

---

## Progress

### Project Initialization

- Created the Project-03 documentation structure.
- Created the Lambda and frontend directories.
- Created the deployment script.
- Reviewed the project requirements and architecture.
- Prepared the development environment.

---

## Implementation Notes

### Amazon SES Configuration

- Opened Amazon SES.
- Created a verified email identity.
- Successfully verified the email address.
- Confirmed the identity status as **Verified**.
-Prepared Amazon SES for sending emails from the serverless contact form.

### IAM Role Configuration

- Created the ContactFormLambdaRole.
- Attached the AWSLambdaBasicExecutionRole managed policy.
- Created an inline policy (SESSendPolicy) to allow Lambda to send emails using Amazon SES.

### AWS Lambda Configuration

- Created the ContactFormHandler Lambda function.
- Selected the Node.js runtime.
- Configured the function to use the ContactFormLambdaRole execution role.
- Prepared the function for backend implementation.

### Lambda Function Deployment

- Created the ContactFormHandler Lambda function.
- Installed project dependencies using npm.
- Packaged the application into a ZIP deployment package.
- Successfully deployed the Lambda function.
- Configured environment variables for Amazon SES.

### API Deployment

- Deployed the ContactFormAPI to the `prod` stage.
- Obtained the public Invoke URL.
- Prepared the API endpoint for integration with the frontend contact form.
---

## Observations

> Record important findings, best practices, or implementation decisions made during the project.