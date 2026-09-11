## OIDC Provider URL Error

### Problem

AWS returned:

`Could not connect to https://token.action.githubusercontent.com`

### Cause

The GitHub OIDC provider URL was entered incorrectly. The word `actions` was missing the final `s`.

### Resolution

Corrected the provider URL to:

`https://token.actions.githubusercontent.com`

The identity provider was then created successfully.

## GitHub Actions OIDC Role Assumption Failure

### Problem

The first GitHub Actions deployment attempt failed during AWS authentication.

The CI job completed successfully, but the deployment job failed at the step:

`Configure AWS credentials using OIDC`

GitHub Actions returned:

`Not authorized to perform sts:AssumeRoleWithWebIdentity`

### Cause

The IAM trust policy was configured with the older GitHub OIDC subject format:

`repo:CloudTee-K/my-aws-journey:ref:refs/heads/main`

However, the GitHub repository was configured to use immutable OIDC subject claims.

The repository's immutable subject prefix was:

`repo:CloudTee-K@223471307/my-aws-journey@1312629450`

Because the subject in the GitHub OIDC token did not match the subject allowed by the IAM trust policy, AWS STS rejected the role assumption request.

### Resolution

The IAM role trust policy was updated to allow the immutable GitHub OIDC subject:

`repo:CloudTee-K@223471307/my-aws-journey@1312629450:ref:refs/heads/main`

The workflow was then re-run.

### Result

GitHub Actions successfully:

- authenticated to AWS using OIDC
- assumed `GitHubActionsRole`
- received temporary AWS credentials
- deployed the application files to Amazon S3

### Lesson

OIDC trust policies must exactly match the subject claim issued by GitHub.

When immutable subject claims are enabled, the IAM trust relationship must use the immutable repository subject rather than the older repository-name-only format.