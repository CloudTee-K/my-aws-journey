# Project 05 — CI/CD Pipeline with GitHub Actions

## Project Overview

This project implements a CI/CD pipeline using GitHub Actions for a Node.js Express application.

The pipeline automatically validates the application using ESLint and Jest before deploying successful application artifacts to Amazon S3.

GitHub Actions authenticates to AWS using OpenID Connect (OIDC), which allows temporary AWS credentials to be used without storing long-term AWS access keys in GitHub.

## Objectives

- Build a simple Node.js Express application
- Run automated linting with ESLint
- Run automated tests with Jest
- Create a GitHub Actions CI/CD workflow
- Authenticate GitHub Actions to AWS using OIDC
- Use a least-privilege IAM role
- Deploy application artifacts to Amazon S3
- Troubleshoot pipeline failures
- Verify successful deployment in AWS

## Architecture

```text
Developer
    |
    | git push
    v
GitHub Repository
    |
    v
GitHub Actions
    |
    +-- Install Dependencies
    |
    +-- Run ESLint
    |
    +-- Run Jest Tests
    |
    v
GitHub OIDC
    |
    v
AWS IAM Role
    |
    v
Amazon S3


Technologies Used
Git
GitHub
GitHub Actions
Node.js
Express
npm
ESLint
Jest
AWS IAM
AWS STS
Amazon S3
GitHub OIDC


Application Structure
my-app/
├── src/
│   └── index.js
├── tests/
│   └── index.test.js
├── eslint.config.js
├── package.json
├── package-lock.json
└── .gitignore
Application Endpoints

The Express application contains the following routes:

GET /
GET /health
GET /api/info

These endpoints are tested automatically using Jest and Supertest.

Continuous Integration

The CI job performs the following steps:

Checks out the repository
Sets up Node.js
Installs dependencies using npm ci
Runs ESLint
Runs Jest tests

Deployment only continues if all CI checks succeed.

Continuous Deployment

After the CI job succeeds, the deployment job:

Requests an OIDC token from GitHub
Uses the token to assume GitHubActionsRole
Receives temporary AWS credentials
Uploads application artifacts to Amazon S3

The deployment bucket is:

cloudtee-cicd-project05

The deployed files are stored under:

my-app/
Security Design

This project avoids storing long-term AWS access keys in GitHub.

GitHub Actions uses OIDC to authenticate to AWS and assume a restricted IAM role.

The IAM role is limited to the required S3 bucket and only allows the permissions needed for deployment.

The S3 bucket remains private.

OIDC Trust Policy

The first deployment attempt failed because the IAM role trust policy used the older GitHub OIDC subject format.

The repository uses immutable OIDC subject claims.

The IAM trust policy was updated to use the repository's immutable subject so AWS STS could successfully authorize:

sts:AssumeRoleWithWebIdentity

After the trust policy was corrected, the workflow completed successfully.

Testing

Local testing produced:

Test Suites: 1 passed, 1 total
Tests:       3 passed, 3 total

ESLint also completed successfully with no errors.

Deployment Verification

The deployed S3 location was verified manually.

The following files and folders were present:

.gitignore
eslint.config.js
package-lock.json
package.json
src/
tests/

The node_modules directory was excluded from deployment.

Important Note

Amazon S3 is used in this project as a deployment artifact destination.

S3 does not run the Node.js Express server.

A production deployment of the Express application itself would require a compute service such as:

AWS Elastic Beanstalk
Amazon ECS
Amazon EC2
AWS App Runner
Troubleshooting

Major issues encountered included:

PowerShell blocking npm.ps1
invalid dependency versions caused by placeholder values in package.json
ESLint configuration issues
accidental node_modules staging
duplicate root-level npm files
GitHub OIDC role assumption failure
IAM trust policy mismatch with immutable GitHub OIDC subject claims

Full troubleshooting details are documented in:

troubleshooting.md
Screenshots

Project screenshots are stored in:

Screenshots/Project-05/
Project Status

Completed.

The CI/CD pipeline successfully:

validates the Node.js application
runs automated tests
authenticates to AWS using OIDC
assumes a least-privilege IAM role
deploys artifacts to Amazon S3
verifies the deployed files successfully


Key Learning Outcomes

This project demonstrated how CI/CD automation, GitHub Actions, AWS IAM, OIDC authentication, automated testing, and secure cloud deployment work together in a real DevOps workflow.