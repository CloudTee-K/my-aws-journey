## OIDC Trust Relationships

GitHub Actions OIDC authentication depends on the IAM trust policy matching the subject claim contained in the GitHub OIDC token.

The first deployment failed because the IAM role used the older repository subject format while the GitHub repository used immutable OIDC subject claims.

Updating the trust policy to the repository's immutable subject allowed AWS STS to issue temporary credentials successfully.

This reinforced the importance of verifying OIDC token claims rather than weakening IAM trust policies when authentication fails.