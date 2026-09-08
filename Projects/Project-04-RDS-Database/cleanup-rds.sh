#!/bin/bash

# Project 04 - RDS PostgreSQL Cleanup Reference
#
# This script provides reference AWS CLI commands for removing
# Project 04 resources.
#
# Review all resource IDs and dependencies before execution.
# The actual cleanup may also be performed through the AWS Console.

set -e

REGION="us-east-1"
DB_IDENTIFIER="my-postgres-db"

echo "Project 04 - RDS Cleanup"
echo "Region: $REGION"
echo

# --------------------------------------------------
# 1. Delete RDS Instance
# --------------------------------------------------

echo "Requesting deletion of RDS instance..."

aws rds delete-db-instance \
    --db-instance-identifier "$DB_IDENTIFIER" \
    --skip-final-snapshot \
    --delete-automated-backups \
    --region "$REGION"

echo "Waiting for RDS instance deletion..."

aws rds wait db-instance-deleted \
    --db-instance-identifier "$DB_IDENTIFIER" \
    --region "$REGION"

echo "RDS instance deleted."

# --------------------------------------------------
# 2. Delete DB Subnet Group
# --------------------------------------------------

echo "Deleting DB subnet group..."

aws rds delete-db-subnet-group \
    --db-subnet-group-name rds-subnet-group \
    --region "$REGION"

# --------------------------------------------------
# Remaining Resources
# --------------------------------------------------

cat <<'EOF'

RDS resources have been removed.

Before deleting the VPC, verify and remove the remaining Project 04
resources in dependency order:

1. Terminate the Bastion EC2 instance.
2. Delete CloudWatch alarms:
   - RDS-High-CPU
   - RDS-Low-Storage
3. Delete rds-sg.
4. Delete bastion-sg.
5. Delete the public route-table association.
6. Delete public-rt.
7. Detach and delete RDS-VPC-IGW.
8. Delete:
   - bastion-public
   - rds-private-1a
   - rds-private-1b
9. Delete RDS-VPC.
10. Delete bastion-key from EC2 if it is no longer required.

IMPORTANT:
Deleting the database and skipping the final snapshot permanently
removes the database unless another retained backup exists.

Always verify resources before executing destructive commands.
EOF