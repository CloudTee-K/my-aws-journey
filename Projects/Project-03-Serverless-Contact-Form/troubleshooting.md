# Troubleshooting

This document records the actual issues encountered during the implementation of Project 03 and the steps taken to resolve them.

---

## Troubleshooting Log

| Issue | Cause | Resolution | Status |
|------|-------|------------|--------|
| Node.js command not recognized | Node.js was installed, but Windows PATH was not updated correctly. | Reinstalled Node.js, added the installation directory to the system PATH, and restarted Windows. | ✅ Resolved |
| PowerShell blocked `npm install` | PowerShell execution policy prevented `npm.ps1` from running. | Used `npm.cmd install` instead of `npm install` to bypass the execution policy restriction. | ✅ Resolved |
| Lambda deployment package missing dependencies | The Lambda function initially contained only the source code without the required Node.js dependencies. | Ran `npm install` to download dependencies, then packaged the project (including `node_modules`) into a ZIP archive before deploying. | ✅ Resolved |
| Contact form displayed "Please configure the API_ENDPOINT" | The JavaScript demo-mode validation still compared the API endpoint to the production endpoint, causing the condition to always evaluate as true. | Removed the placeholder validation logic and updated the application to use the deployed API Gateway endpoint. | ✅ Resolved |
| API endpoint not connected to the frontend | The HTML form still referenced the template API endpoint. | Replaced the placeholder endpoint with the deployed API Gateway Invoke URL. | ✅ Resolved |

---

## Common Issues

### Amazon SES

**Problem**

Email is not delivered.

**Possible Causes**

- Sender email is not verified.
- Recipient email is not verified.
- Amazon SES sandbox restrictions.

**Resolution**

- Verify both sender and recipient email addresses in Amazon SES.
- Ensure the verified identities are created in the same AWS Region as the Lambda function.
- If using the SES Sandbox, send emails only between verified addresses.

---

### AWS Lambda

**Problem**

Lambda function fails during execution.

**Possible Causes**

- Missing environment variables.
- Missing Node.js dependencies.
- Incorrect IAM permissions.

**Resolution**

- Review Amazon CloudWatch Logs.
- Verify the execution role permissions.
- Confirm that `SENDER_EMAIL` and `RECIPIENT_EMAIL` environment variables are configured.
- Ensure all dependencies are included in the deployment package.

---

### Amazon API Gateway

**Problem**

API request fails or returns an error.

**Possible Causes**

- Lambda integration is incorrect.
- API was not deployed after making changes.
- Incorrect Invoke URL.

**Resolution**

- Verify the Lambda integration.
- Redeploy the API after any configuration changes.
- Confirm the frontend uses the correct API Gateway endpoint.

---

### CORS

**Problem**

Browser blocks requests from the frontend.

**Possible Cause**

CORS is not enabled for the API resource.

**Resolution**

- Enable CORS in API Gateway.
- Configure both the `POST` and `OPTIONS` methods.
- Redeploy the API after updating CORS settings.

---

## Key Troubleshooting Lessons

- Windows environment configuration can prevent development tools from working even after successful installation.
- PowerShell execution policies can affect Node.js workflows; using `npm.cmd` is a simple workaround.
- AWS Lambda deployment packages must include all required dependencies.
- Small configuration mistakes, such as an incorrect API endpoint or leftover template code, can prevent an application from functioning correctly.
- Testing each component individually before performing end-to-end testing makes troubleshooting much easier.