## Step 1 — Created GitHub OIDC Provider

Created an OpenID Connect (OIDC) identity provider in AWS IAM for GitHub Actions.

Configuration:

- Provider type: OpenID Connect
- Provider URL: `https://token.actions.githubusercontent.com`
- Audience: `sts.amazonaws.com`

This allows GitHub Actions to authenticate to AWS using short-lived credentials instead of storing long-term AWS access keys in GitHub.

A typo was initially entered in the provider URL as:

`https://token.action.githubusercontent.com`

This caused AWS to return a connection error. The issue was resolved by correcting the URL to:

`https://token.actions.githubusercontent.com`

Screenshot:

`Screenshots/Project-05/01-github-oidc-provider-created.png`


## Step 2 — Created IAM Role for GitHub Actions

Created an IAM role that GitHub Actions can assume using the GitHub OIDC identity provider.

### Role Configuration

- Role name: `GitHubActionsRole`
- Trusted entity type: Web identity
- Identity provider: `token.actions.githubusercontent.com`
- Audience: `sts.amazonaws.com`
- GitHub organization: `CloudTee-K`
- GitHub repository: `my-aws-journey`
- GitHub branch: `main`

The trust relationship was restricted to the specific GitHub repository and main branch rather than allowing access from all GitHub repositories.

No AWS permissions were attached during role creation. A custom least-privilege policy will be added after the S3 deployment bucket is created.

This approach separates two IAM concepts:

- Trust policy — determines who can assume the role.
- Permissions policy — determines what the role can do after it has been assumed.

Screenshot:

`Screenshots/Project-05/02-iam-role-trusted-entity.png`

`Screenshots/Project-05/03-github-actions-role-created.png`

## Step 5 — Local CI Validation

Validated the Node.js application locally before pushing the GitHub Actions workflow.

### Jest Test Results

Executed:

`npm.cmd test`

Result:

- Test suites: 1 passed
- Tests: 3 passed
- Snapshots: 0
- All API endpoint tests passed successfully

### ESLint Results

Executed:

`npm.cmd run lint`

Result:

- ESLint completed successfully
- No linting errors were reported

This confirmed that the application was ready for automated CI execution in GitHub Actions.

Screenshot:

`Screenshots/Project-05/07-local-tests-and-lint-success.png`

## Step 8 — Fixed OIDC Trust Policy and Completed Deployment

The first GitHub Actions deployment attempt failed during AWS authentication.

GitHub Actions returned:

`Not authorized to perform sts:AssumeRoleWithWebIdentity`

The CI stage had already completed successfully, confirming that the application passed linting and automated tests.

### Root Cause

The AWS IAM trust policy was using the older GitHub OIDC subject format:

`repo:CloudTee-K/my-aws-journey:ref:refs/heads/main`

The GitHub repository was configured to use immutable OIDC subject claims.

The repository's immutable subject prefix was:

`repo:CloudTee-K@223471307/my-aws-journey@1312629450`

### Resolution

Updated the IAM role trust policy to use the immutable GitHub OIDC subject:

`repo:CloudTee-K@223471307/my-aws-journey@1312629450:ref:refs/heads/main`

The failed deployment job was then re-run.

### Result

The workflow completed successfully:

- Linting passed
- Jest tests passed
- GitHub authenticated to AWS using OIDC
- `GitHubActionsRole` was assumed successfully
- Application files were deployed to Amazon S3

Screenshot:

`Screenshots/Project-05/09-github-actions-deployment-success.png`

## Step 9 — Verified S3 Deployment

Verified the output of the GitHub Actions deployment directly in Amazon S3.

Deployment location:

`cloudtee-cicd-project05/my-app/`

The following application files and directories were successfully deployed:

- `.gitignore`
- `eslint.config.js`
- `package-lock.json`
- `package.json`
- `src/`
- `tests/`

The `node_modules` directory was not uploaded because it was explicitly excluded from the deployment workflow.

This confirmed that the GitHub Actions deployment job successfully authenticated to AWS using OIDC and transferred the application files to the configured S3 bucket.

Screenshot:

`Screenshots/Project-05/10-s3-deployment-verified.png`