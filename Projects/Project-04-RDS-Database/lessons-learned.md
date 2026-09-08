## CloudWatch Monitoring

Amazon RDS integrates with Amazon CloudWatch to provide operational metrics for database instances.

During this project, I learned how to monitor important RDS metrics and create threshold-based alarms for abnormal conditions.

Two alarms were implemented:

- High CPU utilization (`CPUUtilization >= 80%`)
- Low available storage (`FreeStorageSpace <= 2 GiB`)

Both alarms reached the `OK` state after receiving sufficient metric data.

This demonstrated the importance of observability in cloud database environments. Deploying a database is not sufficient on its own; administrators also need monitoring mechanisms that can identify resource pressure before it results in service degradation or failure.



## Final Lessons Learned

Project 04 provided practical experience designing and operating a managed relational database architecture on AWS.

Key lessons included:

- Amazon RDS removes much of the infrastructure management associated with running a database server manually.
- Databases should generally be isolated from direct internet access when public connectivity is unnecessary.
- A Bastion Host can provide controlled administrative access to resources located within private network environments.
- Security group references can be used to restrict database access to specific trusted AWS resources instead of exposing database ports publicly.
- RDS DB subnet groups allow database resources to use subnets across multiple Availability Zones.
- PostgreSQL clients can securely connect to private RDS instances through controlled network paths.
- SSL/TLS protects database traffic in transit.
- RDS automated backups provide managed recovery capabilities.
- CloudWatch metrics and alarms improve database observability.
- AWS account plans and service limits can affect architecture decisions, as demonstrated by the backup retention restriction encountered during deployment.
- Cloud architecture should balance security, reliability, operational requirements, and cost.