#!/bin/bash

# Project 04 - RDS PostgreSQL Deployment Reference
# This script demonstrates how selected RDS resources could be
# provisioned using the AWS CLI.
#
# NOTE:
# The actual Project 04 environment was deployed manually through
# the AWS Management Console. This script is included for reference
# and learning purposes.

set -e

REGION="us-east-1"
VPC_CIDR="10.0.0.0/16"
PRIVATE_SUBNET_1_CIDR="10.0.1.0/24"
PRIVATE_SUBNET_2_CIDR="10.0.2.0/24"
PUBLIC_SUBNET_CIDR="10.0.10.0/24"

DB_IDENTIFIER="my-postgres-db"
DB_NAME="projectdb"
DB_USERNAME="dbadmin"
DB_PORT="5432"

echo "Project 04 - RDS PostgreSQL Deployment Reference"
echo "Region: $REGION"
echo

# --------------------------------------------------
# 1. Create VPC
# --------------------------------------------------

echo "Creating VPC..."

VPC_ID=$(aws ec2 create-vpc \
    --cidr-block "$VPC_CIDR" \
    --region "$REGION" \
    --query 'Vpc.VpcId' \
    --output text)

aws ec2 create-tags \
    --resources "$VPC_ID" \
    --tags Key=Name,Value=RDS-VPC \
    --region "$REGION"

aws ec2 modify-vpc-attribute \
    --vpc-id "$VPC_ID" \
    --enable-dns-support '{"Value":true}' \
    --region "$REGION"

aws ec2 modify-vpc-attribute \
    --vpc-id "$VPC_ID" \
    --enable-dns-hostnames '{"Value":true}' \
    --region "$REGION"

echo "VPC created: $VPC_ID"

# --------------------------------------------------
# 2. Create Private Subnets
# --------------------------------------------------

echo "Creating private subnets..."

PRIVATE_SUBNET_1=$(aws ec2 create-subnet \
    --vpc-id "$VPC_ID" \
    --cidr-block "$PRIVATE_SUBNET_1_CIDR" \
    --availability-zone us-east-1a \
    --region "$REGION" \
    --query 'Subnet.SubnetId' \
    --output text)

PRIVATE_SUBNET_2=$(aws ec2 create-subnet \
    --vpc-id "$VPC_ID" \
    --cidr-block "$PRIVATE_SUBNET_2_CIDR" \
    --availability-zone us-east-1b \
    --region "$REGION" \
    --query 'Subnet.SubnetId' \
    --output text)

aws ec2 create-tags \
    --resources "$PRIVATE_SUBNET_1" \
    --tags Key=Name,Value=rds-private-1a \
    --region "$REGION"

aws ec2 create-tags \
    --resources "$PRIVATE_SUBNET_2" \
    --tags Key=Name,Value=rds-private-1b \
    --region "$REGION"

echo "Private subnets created."

# --------------------------------------------------
# 3. Create Public Bastion Subnet
# --------------------------------------------------

echo "Creating public subnet..."

PUBLIC_SUBNET=$(aws ec2 create-subnet \
    --vpc-id "$VPC_ID" \
    --cidr-block "$PUBLIC_SUBNET_CIDR" \
    --availability-zone us-east-1a \
    --region "$REGION" \
    --query 'Subnet.SubnetId' \
    --output text)

aws ec2 create-tags \
    --resources "$PUBLIC_SUBNET" \
    --tags Key=Name,Value=bastion-public \
    --region "$REGION"

aws ec2 modify-subnet-attribute \
    --subnet-id "$PUBLIC_SUBNET" \
    --map-public-ip-on-launch

echo "Public subnet created: $PUBLIC_SUBNET"

# --------------------------------------------------
# 4. Create Internet Gateway
# --------------------------------------------------

echo "Creating Internet Gateway..."

IGW_ID=$(aws ec2 create-internet-gateway \
    --region "$REGION" \
    --query 'InternetGateway.InternetGatewayId' \
    --output text)

aws ec2 create-tags \
    --resources "$IGW_ID" \
    --tags Key=Name,Value=RDS-VPC-IGW \
    --region "$REGION"

aws ec2 attach-internet-gateway \
    --internet-gateway-id "$IGW_ID" \
    --vpc-id "$VPC_ID" \
    --region "$REGION"

# --------------------------------------------------
# 5. Create Public Route Table
# --------------------------------------------------

echo "Creating public route table..."

PUBLIC_RT=$(aws ec2 create-route-table \
    --vpc-id "$VPC_ID" \
    --region "$REGION" \
    --query 'RouteTable.RouteTableId' \
    --output text)

aws ec2 create-tags \
    --resources "$PUBLIC_RT" \
    --tags Key=Name,Value=public-rt \
    --region "$REGION"

aws ec2 create-route \
    --route-table-id "$PUBLIC_RT" \
    --destination-cidr-block 0.0.0.0/0 \
    --gateway-id "$IGW_ID" \
    --region "$REGION"

aws ec2 associate-route-table \
    --route-table-id "$PUBLIC_RT" \
    --subnet-id "$PUBLIC_SUBNET" \
    --region "$REGION"

# --------------------------------------------------
# 6. Create DB Subnet Group
# --------------------------------------------------

echo "Creating RDS subnet group..."

aws rds create-db-subnet-group \
    --db-subnet-group-name rds-subnet-group \
    --db-subnet-group-description "Private subnet group for Project 04 RDS" \
    --subnet-ids "$PRIVATE_SUBNET_1" "$PRIVATE_SUBNET_2" \
    --region "$REGION"

# --------------------------------------------------
# RDS Deployment Notice
# --------------------------------------------------

echo
echo "Core network resources created."
echo
echo "RDS configuration:"
echo "DB Identifier: $DB_IDENTIFIER"
echo "Database Name: $DB_NAME"
echo "Database User: $DB_USERNAME"
echo "Port: $DB_PORT"
echo
echo "RDS instance creation is intentionally not automated here."
echo "Database credentials must not be hard-coded in this repository."
echo "Use AWS Secrets Manager, environment variables, or another"
echo "secure credential-management mechanism before automating"
echo "the database creation process."