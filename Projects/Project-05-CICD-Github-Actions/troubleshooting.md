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