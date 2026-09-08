## Step 1 — VPC Creation

### Objective
Create a custom Virtual Private Cloud (VPC) to provide an isolated network environment for the Amazon RDS PostgreSQL database and supporting resources.

### Configuration

| Setting | Value |
|---|---|
| VPC Name | `RDS-VPC` |
| IPv4 CIDR Block | `10.0.0.0/16` |
| IPv6 CIDR | None |
| Tenancy | Default |
| DNS Resolution | Enabled |
| DNS Hostnames | Enabled |
| Region | `us-east-1` |

### Implementation
- Created a custom VPC named `RDS-VPC`.
- Assigned the private IPv4 CIDR block `10.0.0.0/16`.
- Used default tenancy for resources deployed within the VPC.
- Enabled DNS resolution and DNS hostnames.
- The VPC will contain the private RDS database subnets and the public subnet for the Bastion Host.

### Security Consideration
Creating a dedicated VPC provides network isolation and allows access to the database infrastructure to be controlled using subnets, route tables, and security groups.

### Screenshot
`Screenshots/Project-04/01-rds-vpc-created.png`

### Status
Completed


### Step 2 — Subnet Configuration

- Created two private subnets for Amazon RDS:
  - `rds-private-1a` — `10.0.1.0/24` — `us-east-1a`
  - `rds-private-1b` — `10.0.2.0/24` — `us-east-1b`
- Created one public subnet for the Bastion Host:
  - `bastion-public` — `10.0.10.0/24` — `us-east-1a`
- Enabled automatic public IPv4 assignment only on the public Bastion subnet.

## Step 3 — Internet Gateway and Public Route Table

### Objective
Provide internet connectivity to the public Bastion subnet while keeping the Amazon RDS subnets private.

### Implementation
- Created an Internet Gateway named `RDS-VPC-IGW`.
- Attached the Internet Gateway to `RDS-VPC`.
- Created a route table named `public-rt`.
- Added a default route `0.0.0.0/0` pointing to the Internet Gateway.
- Associated `public-rt` only with the `bastion-public` subnet.
- Left `rds-private-1a` and `rds-private-1b` without a route to the Internet Gateway.

### Security Consideration
Only the Bastion subnet is configured for direct internet connectivity. The RDS database subnets remain private, reducing the database attack surface and preventing direct internet exposure.

### Screenshot
`Screenshots/Project-04/03-internet-gateway-route-table.png`

### Status
Completed

## Step 4 — Security Groups

### Objective
Implement least-privilege network access between the administrator, Bastion Host, and Amazon RDS PostgreSQL database.

### Implementation
- Created `bastion-sg` inside `RDS-VPC`.
- Allowed inbound SSH traffic on TCP port 22 only from my current public IP address.
- Created `rds-sg` inside `RDS-VPC`.
- Allowed inbound PostgreSQL traffic on TCP port 5432 only from `bastion-sg`.
- Retained the default outbound rules.

### Security Consideration
The RDS security group does not permit PostgreSQL connections directly from the internet. Database traffic is restricted to resources associated with the Bastion Host security group, implementing the principle of least privilege.

### Screenshot
`Screenshots/Project-04/04-security-groups.png`

### Status
Completed

## Step 5 — RDS DB Subnet Group

### Objective
Define the private network locations in which Amazon RDS can deploy the PostgreSQL database.

### Configuration

| Setting | Value |
|---|---|
| DB Subnet Group | `rds-subnet-group` |
| VPC | `RDS-VPC` |
| Availability Zones | `us-east-1a`, `us-east-1b` |
| Private Subnet 1 | `rds-private-1a` — `10.0.1.0/24` |
| Private Subnet 2 | `rds-private-1b` — `10.0.2.0/24` |

### Implementation
- Created an RDS DB subnet group named `rds-subnet-group`.
- Added the two private RDS subnets.
- Distributed the subnets across two Availability Zones.
- Excluded the public Bastion subnet from the DB subnet group.

### Security Consideration
The DB subnet group contains only private subnets. This prevents the database architecture from relying on the internet-facing Bastion subnet and supports network isolation for the PostgreSQL instance.

### Screenshot
`Screenshots/Project-04/05-db-subnet-group.png`

### Status
Completed

## Step 6 — Amazon RDS PostgreSQL Deployment

### Objective
Deploy a managed PostgreSQL database using Amazon RDS inside the private network architecture created for Project 04.

### Configuration

| Setting | Value |
|---|---|
| DB Instance Identifier | `my-postgres-db` |
| Database Engine | PostgreSQL |
| Master Username | `dbadmin` |
| Initial Database Name | `projectdb` |
| VPC | `RDS-VPC` |
| DB Subnet Group | `rds-subnet-group` |
| Security Group | `rds-sg` |
| Public Access | No |
| Database Port | `5432` |
| Deployment | Single-AZ |
| Storage Encryption | Enabled |
| Automated Backups | Enabled |
| Backup Retention | Maximum permitted by AWS Free plan |
| Backtrack | Disabled |
| Deletion Protection | Disabled |
| Region | `us-east-1` |

### Implementation
- Created an Amazon RDS PostgreSQL instance named `my-postgres-db`.
- Created the initial PostgreSQL database `projectdb`.
- Deployed the database using the custom `RDS-VPC`.
- Used `rds-subnet-group`, which contains private subnets across two Availability Zones.
- Disabled public database access.
- Associated the database with `rds-sg`, which permits PostgreSQL traffic on port 5432 only from `bastion-sg`.
- Enabled storage encryption to protect database data at rest.
- Enabled automated backups using the maximum retention period supported by the AWS Free plan.
- Used a Single-AZ deployment to remain within the limitations of the Free plan.
- Confirmed that the RDS instance reached the `Available` state.

### Security Considerations
The RDS instance was deployed without public access and is protected by `rds-sg`. PostgreSQL connections are restricted to resources associated with `bastion-sg`, preventing direct database access from the internet.

Storage encryption was enabled to protect data at rest, while automated backups provide a recovery mechanism for database data.

Database credentials were not stored in the project repository or documentation.

### Cost Consideration
The original project design specified a 7-day backup retention period and considered Multi-AZ deployment. These settings were adjusted to comply with the limitations of the AWS Free plan.

A Single-AZ deployment was used instead of Multi-AZ, and the automated backup retention period was reduced to the maximum supported by the account's Free plan.

### Result
The PostgreSQL RDS instance `my-postgres-db` was successfully deployed and reached the `Available` state.

### Screenshots
- `Screenshots/Project-04/06-rds-configuration.png`
- `Screenshots/Project-04/07-rds-available.png`

### Status
Completed

## Step 8 — Bastion Host and PostgreSQL Connectivity Validation

### Objective
Establish secure administrative access to the private Amazon RDS PostgreSQL database through an EC2 Bastion Host and verify that the database is operational.

### Bastion Host Configuration

| Setting | Value |
|---|---|
| Operating System | Amazon Linux 2023 |
| Subnet | `bastion-public` |
| VPC | `RDS-VPC` |
| Security Group | `bastion-sg` |
| SSH Access | Restricted to administrator public IP |
| RDS Access | PostgreSQL TCP 5432 through security group reference |

### PostgreSQL Configuration

| Setting | Value |
|---|---|
| PostgreSQL Client | PostgreSQL 18.6 |
| RDS Engine | PostgreSQL 18 |
| DB Instance | `my-postgres-db` |
| Database | `projectdb` |
| Database User | `dbadmin` |
| Port | `5432` |
| Public RDS Access | Disabled |
| Connection Encryption | SSL/TLS |

### Implementation

1. Connected from the local Windows workstation to the EC2 Bastion Host using SSH and the `bastion-key` private key.

2. Verified that the Bastion Host was operational and accessible through its public IPv4 address.

3. Checked the Amazon Linux 2023 repositories for available PostgreSQL client versions.

4. Installed the PostgreSQL 18 client to correspond with the PostgreSQL 18 RDS database engine.

5. Retrieved the private RDS endpoint from the Amazon RDS console.

6. Connected from the Bastion Host to `my-postgres-db` using the PostgreSQL client.

7. Successfully authenticated to the `projectdb` database as `dbadmin`.

8. Verified that the database connection used SSL/TLS encryption.

### Database Validation

A test table named `users` was created:

```sql
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100)
);

A sample record was inserted:
   INSERT INTO users (name, email)
VALUES ('Jane Doe', 'jane@example.com');

The record was retrieved using:

SELECT * FROM users;

Result:

 id |   name   |      email
----+----------+------------------
  1 | Jane Doe | jane@example.com

## Step 9 — Automated Backup and Recovery Verification

### Objective
Verify that Amazon RDS automated backups are enabled and that recovery information and automated snapshots are being generated for the PostgreSQL database.

### Backup Configuration

| Setting | Value |
|---|---|
| DB Instance | `my-postgres-db` |
| Automated Backups | Enabled |
| Backup Retention Period | 1 Day |
| Backup Window | `04:30–05:00 UTC` |
| Backup Target | AWS Cloud |
| Copy Tags to Snapshots | Enabled |
| Automated Snapshot Status | Available |
| Snapshot Type | Automated |

### Implementation

The Maintenance & backups section of the Amazon RDS console was inspected after the PostgreSQL database became operational.

Automated backups were confirmed to be enabled with a 1-day retention period, which is the retention period supported by the AWS Free plan used for this project.

Amazon RDS displayed a latest restore time, demonstrating that recovery information was available for the database.

An automatically generated RDS snapshot was also present with an `Available` status and an `Automated` snapshot type.

This confirmed that Amazon RDS was successfully managing backups for the database without requiring manual backup scripts.

### Recovery Capability

Amazon RDS automated backups provide recovery capabilities within the configured backup retention period.

The presence of a latest restore time and an available automated snapshot confirmed that the database had recoverable backup data.

An actual restore was not performed during the lab because restoring an RDS database provisions another database instance and could introduce additional resource usage and cost.

### Security and Reliability Considerations

- Automated backups reduce dependence on manual database backup procedures.
- The 1-day retention period was selected to comply with the AWS Free plan limitation encountered during deployment.
- RDS manages the underlying backup infrastructure.
- Backup availability provides a recovery mechanism in the event of database failure, accidental modification, or data loss.
- Database storage encryption was enabled during RDS deployment.

### Validation

The AWS RDS console confirmed:

- Automated backups: Enabled
- Backup retention: 1 Day
- Latest restore time: Available
- Automated snapshot: Available
- Snapshot type: Automated

These results verified that the backup configuration was functioning successfully.

### Screenshot

`Screenshots/Project-04/11-automated-backup-configuration.png`

### Status

Completed

## Step 10 — Amazon CloudWatch Monitoring and Alarms

### Objective
Configure Amazon CloudWatch monitoring and alarms for the Amazon RDS PostgreSQL database to detect high CPU utilization and critically low available storage.

### Monitoring Configuration

Amazon RDS automatically publishes database performance metrics to Amazon CloudWatch. The monitoring metrics for `my-postgres-db` were reviewed before creating alarms.

Two CloudWatch alarms were configured:

| Alarm | Metric | Condition | Status |
|---|---|---|---|
| `RDS-High-CPU` | CPUUtilization | >= 80% | OK |
| `RDS-Low-Storage` | FreeStorageSpace | <= 2 GiB | OK |

### High CPU Alarm

The `RDS-High-CPU` alarm monitors the average CPU utilization of the PostgreSQL RDS instance.

Configuration:

- Metric: `CPUUtilization`
- Statistic: Average
- Period: 5 minutes
- Threshold: 80%
- Condition: Greater than or equal to 80%
- Evaluation periods: 2
- Datapoints to alarm: 2

The alarm is designed to detect sustained high CPU utilization rather than temporary CPU spikes.

### Low Storage Alarm

The `RDS-Low-Storage` alarm monitors the amount of free storage remaining on the RDS instance.

Configuration:

- Metric: `FreeStorageSpace`
- Statistic: Average
- Period: 5 minutes
- Threshold: 2 GiB
- Threshold in bytes: `2147483648`
- Condition: Less than or equal to 2 GiB
- Evaluation periods: 1
- Datapoints to alarm: 1

This alarm provides an early warning if database storage approaches a critically low level.

### Validation

After creation, both CloudWatch alarms reached the `OK` state:

- `RDS-High-CPU` — OK
- `RDS-Low-Storage` — OK

The `OK` state confirms that CloudWatch received sufficient metric data to evaluate the configured conditions and that neither alarm threshold was currently being breached.

### Cost Consideration

The project used standard RDS metrics available through Amazon CloudWatch. Additional optional database monitoring features were not enabled for this lab.

### Result

Amazon CloudWatch monitoring was successfully integrated with the RDS PostgreSQL database.

The database environment can now be monitored for two important operational conditions:

1. Sustained high CPU utilization.
2. Critically low available storage.

This improves the observability and operational reliability of the database architecture.

### Screenshots

- `Screenshots/Project-04/12-cloudwatch-rds-alarms.png`
- `Screenshots/Project-04/13-rds-monitoring-metrics.png`

### Status

Completed

Project 04 successfully demonstrated the deployment and administration of a managed PostgreSQL database using Amazon RDS.

The completed architecture incorporated:

- Custom VPC networking
- Public and private subnet separation
- EC2 Bastion Host
- Security-group-based access control
- Private Amazon RDS PostgreSQL
- Database storage encryption
- SSL/TLS database connectivity
- Automated backups
- Recovery capability
- Amazon CloudWatch monitoring and alarms

The deployed environment successfully passed the required functional and operational validation tests.

### Status

Completed