# Project 04 — Amazon RDS PostgreSQL Database with Automated Backups

## Overview

This project demonstrates the deployment of a secure, managed PostgreSQL database using Amazon RDS within a custom AWS VPC.

The database was deployed without public access and administered through an EC2 Bastion Host located in a public subnet. Security groups were used to restrict SSH and PostgreSQL connectivity, while Amazon RDS automated backups and Amazon CloudWatch alarms provided recovery and monitoring capabilities.

The project demonstrates practical AWS database administration, network isolation, access control, backup management, encryption, and monitoring.

---

## Project Objectives

The objectives of this project were to:

- Create a custom VPC for the database environment.
- Separate public administrative resources from private database resources.
- Deploy Amazon RDS PostgreSQL within private subnets.
- Prevent direct public access to the database.
- Configure an EC2 Bastion Host for controlled database administration.
- Apply least-privilege network access using security groups.
- Establish secure PostgreSQL connectivity.
- Create and query database records.
- Enable storage encryption.
- Configure and verify automated RDS backups.
- Monitor database health using Amazon CloudWatch.
- Create alarms for high CPU utilization and low available storage.

---

## Architecture

```text
                         Internet
                            |
                            | SSH :22
                            v
                   Internet Gateway
                            |
                            v
                +-----------------------+
                |    Public Subnet      |
                |    bastion-public     |
                |                       |
                |    EC2 Bastion Host   |
                |    bastion-sg         |
                +-----------+-----------+
                            |
                            | PostgreSQL :5432
                            v
             +-------------------------------+
             |       Private RDS Network     |
             |                               |
             |       my-postgres-db          |
             |       PostgreSQL 18           |
             |       projectdb               |
             |       rds-sg                  |
             |       Encryption Enabled      |
             +-------------+-----------------+
                           |
                  +--------+--------+
                  |                 |
                  v                 v
          Automated Backups     CloudWatch
          1-Day Retention       Monitoring
                               - High CPU
                               - Low Storage
```

---

## AWS Services Used

| Service | Purpose |
|---|---|
| Amazon VPC | Provides isolated networking for the project |
| Amazon EC2 | Hosts the Bastion server |
| Amazon RDS | Provides the managed PostgreSQL database |
| Amazon CloudWatch | Provides RDS metrics and alarms |
| Security Groups | Control SSH and PostgreSQL network access |
| Internet Gateway | Provides internet connectivity to the public Bastion subnet |

---

## Network Configuration

| Resource | Configuration |
|---|---|
| VPC | `RDS-VPC` |
| VPC CIDR | `10.0.0.0/16` |
| Private Subnet 1 | `rds-private-1a` — `10.0.1.0/24` |
| Private Subnet 2 | `rds-private-1b` — `10.0.2.0/24` |
| Public Subnet | `bastion-public` — `10.0.10.0/24` |
| Internet Gateway | `RDS-VPC-IGW` |
| Public Route Table | `public-rt` |

The public route table was associated only with the Bastion subnet. The RDS database was deployed using the private subnet architecture.

---

## Security Configuration

Two security groups were used.

### `bastion-sg`

Allows:

- SSH (`TCP 22`) from the administrator's public IP address.

### `rds-sg`

Allows:

- PostgreSQL (`TCP 5432`) from `bastion-sg`.

The RDS database was configured with:

- Public access disabled
- Storage encryption enabled
- Private subnet deployment
- Security-group-restricted PostgreSQL access
- SSL/TLS database connectivity

Database passwords and SSH private keys are not stored in this repository.

---

## Amazon RDS Configuration

| Setting | Configuration |
|---|---|
| DB Identifier | `my-postgres-db` |
| Engine | PostgreSQL 18 |
| Database | `projectdb` |
| Master User | `dbadmin` |
| Port | `5432` |
| Deployment | Single-AZ |
| Public Access | Disabled |
| Storage Encryption | Enabled |
| Automated Backups | Enabled |
| Backup Retention | 1 Day |
| DB Subnet Group | `rds-subnet-group` |
| Security Group | `rds-sg` |

Single-AZ deployment and a 1-day backup retention period were used to comply with the limitations of the AWS Free plan used for the lab.

---

## Database Connectivity

Database administration followed this path:

```text
Local Workstation
       |
       | SSH
       v
EC2 Bastion Host
       |
       | PostgreSQL TCP 5432
       v
Private Amazon RDS
       |
       v
projectdb
```

The PostgreSQL 18 client was installed on the Amazon Linux 2023 Bastion Host.

A successful connection to the RDS database confirmed SSL/TLS encryption.

Example connection syntax:

```bash
psql -h <RDS-ENDPOINT> -U dbadmin -d projectdb
```

---

## Database Validation

A test table was created:

```sql
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100)
);
```

A sample record was inserted:

```sql
INSERT INTO users (name, email)
VALUES ('Jane Doe', 'jane@example.com');
```

The data was successfully retrieved:

```sql
SELECT * FROM users;
```

Result:

```text
 id |   name   |      email
----+----------+------------------
  1 | Jane Doe | jane@example.com
```

This verified successful database creation, authentication, connectivity, data insertion, and retrieval.

---

## Automated Backups

Amazon RDS automated backups were enabled.

The final configuration used:

```text
Backup retention: 1 Day
```

The AWS RDS console confirmed:

- Automated backups enabled
- Restore information available
- Automated snapshot generated
- Automated snapshot status: `Available`

An actual restore was not performed because restoring the database would provision an additional RDS instance and was unnecessary for validating the backup capability in this cost-conscious lab.

---

## CloudWatch Monitoring

Two Amazon CloudWatch alarms were configured.

### High CPU Alarm

```text
Alarm: RDS-High-CPU
Metric: CPUUtilization
Threshold: >= 80%
State after validation: OK
```

### Low Storage Alarm

```text
Alarm: RDS-Low-Storage
Metric: FreeStorageSpace
Threshold: <= 2 GiB
State after validation: OK
```

Both alarms successfully received RDS metric data and reached the `OK` state.

---

## Troubleshooting

### Backup Retention Free Plan Limitation

The initial RDS deployment attempted to use a 7-day automated backup retention period.

AWS rejected the database creation request because the configured retention period exceeded the maximum available under the account's Free plan.

The retention period was reduced to 1 day, after which the RDS database was successfully created.

This demonstrated the importance of validating cloud architecture requirements against account-level service and pricing limitations.

---

## Project Validation

The following components were successfully validated:

- Custom VPC networking
- Public and private subnet architecture
- Bastion Host SSH connectivity
- Private RDS deployment
- PostgreSQL authentication
- Security-group-controlled database connectivity
- SSL/TLS database connection
- SQL table creation
- Data insertion and retrieval
- Storage encryption
- Automated RDS backups
- Automated snapshot generation
- CloudWatch RDS monitoring
- High CPU alarm
- Low storage alarm

---

## Repository Structure

```text
Project-04-RDS-Database/
|
|-- README.md
|-- architecture.md
|-- project-notes.md
|-- commands-used.md
|-- troubleshooting.md
|-- lessons-learned.md
|-- deploy-rds.sh
`-- cleanup-rds.sh
```

Project screenshots are stored separately under:

```text
Screenshots/Project-04/
```

---

## Key Lessons Learned

This project provided practical experience with:

- Designing secure AWS database network architectures.
- Separating public administrative resources from private database resources.
- Using security group references instead of exposing database ports publicly.
- Administering a private RDS instance through an EC2 Bastion Host.
- Working with PostgreSQL on Amazon RDS.
- Protecting database traffic using SSL/TLS.
- Configuring RDS automated backups.
- Monitoring managed databases with Amazon CloudWatch.
- Creating threshold-based operational alarms.
- Adapting AWS architecture decisions to account and cost limitations.

---

## Project Status

**Completed**

The project successfully deployed and validated a secure Amazon RDS PostgreSQL environment with private database access, automated backups, encryption, Bastion-based administration, and CloudWatch monitoring.