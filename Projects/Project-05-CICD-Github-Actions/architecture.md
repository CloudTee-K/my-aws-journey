# Project 05 Architecture — CI/CD Pipeline with GitHub Actions

## Architecture Overview

This project implements an automated CI/CD pipeline that validates application code and deploys successful builds to AWS.

## CI/CD Flow

Developer
    |
    | git push
    v
GitHub Repository
    |
    v
GitHub Actions
    |
    +-- Checkout Code
    |
    +-- Install Dependencies
    |
    +-- Run ESLint
    |
    +-- Run Jest Tests
    |
    | Tests Successful
    v
GitHub OIDC Authentication
    |
    v
AWS IAM Role
    |
    | Temporary Credentials
    v
Amazon S3
    |
    v
Application Deployment

## Continuous Integration

The CI stage automatically:

1. Retrieves the application source code.
2. Installs Node.js dependencies.
3. Checks code quality using ESLint.
4. Runs automated tests using Jest.
5. Prevents deployment when validation fails.

## Continuous Deployment

The CD stage runs only after the CI stage succeeds.

GitHub Actions authenticates with AWS using OIDC and assumes an IAM role with restricted permissions.

The successful application build is then automatically deployed to Amazon S3.

## Authentication Architecture

GitHub Actions
    |
    | OIDC Token
    v
AWS IAM OIDC Provider
    |
    v
GitHubActionsRole
    |
    | Temporary AWS Credentials
    v
Authorized AWS Resources

This avoids storing long-term AWS access keys in GitHub.

## AWS Services

- AWS IAM
- AWS Security Token Service (STS)
- Amazon S3

## Development and DevOps Tools

- Git
- GitHub
- GitHub Actions
- Node.js
- npm
- Express
- Jest
- ESLint

## Security Design

- No long-term AWS access keys stored in GitHub.
- GitHub Actions authenticates using OIDC.
- IAM trust is restricted to the authorized GitHub repository.
- The deployment role follows least-privilege principles.
- Deployment occurs only after linting and automated tests succeed.