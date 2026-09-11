## Step 2 — IAM Role

No CLI commands were used.

The `GitHubActionsRole` IAM role was created manually through the AWS Management Console using GitHub OIDC authentication.

## Step 3 — Created S3 Deployment Bucket and IAM Policy

Created an Amazon S3 bucket to receive deployment artifacts from the GitHub Actions pipeline.

### S3 Bucket

- Bucket name: `cloudtee-cicd-project05`
- Region: `us-east-1`
- Object Ownership: Bucket owner enforced
- Block Public Access: Enabled

The bucket was kept private during initial setup.

### IAM Permissions

Created an inline least-privilege policy named:

`Project05S3DeploymentPolicy`

The policy allows `GitHubActionsRole` to:

- List the deployment bucket
- Upload objects
- Read objects
- Delete objects

Permissions are restricted to:

`cloudtee-cicd-project05`

This avoids using broad managed policies such as `AmazonS3FullAccess`.

Screenshot:

`Screenshots/Project-05/04-s3-deployment-bucket-created.png`

`Screenshots/Project-05/05-github-actions-s3-policy.png`


## Step 4 — Configured GitHub Actions Repository Variables

Configured repository-level variables for the CI/CD workflow.

Variables created:

- `AWS_REGION` = `us-east-1`
- `S3_BUCKET_NAME` = `cloudtee-cicd-project05`
- `AWS_ROLE_ARN` = IAM role ARN for `GitHubActionsRole`

These values are configuration data rather than credentials.

GitHub Actions will use `AWS_ROLE_ARN` together with OIDC to request temporary AWS credentials during deployment.

No long-term AWS access keys or secret access keys were stored in GitHub.

Screenshot:

`Screenshots/Project-05/06-github-actions-variables.png`

## Step 5 — Local CI Validation

```bash
npm.cmd test
npm.cmd run lint