                         Internet
                            │
                            │ SSH :22
                            ▼
                    ┌───────────────┐
                    │ Bastion Host  │
                    │ Public Subnet │
                    │ bastion-sg    │
                    └───────┬───────┘
                            │
                            │ PostgreSQL :5432
                            ▼
                 ┌─────────────────────┐
                 │   Private RDS       │
                 │                     │
                 │ my-postgres-db      │
                 │ PostgreSQL 18       │
                 │ projectdb           │
                 │ rds-sg              │
                 │ Encryption Enabled  │
                 └──────┬────────┬─────┘
                        │        │
                        ▼        ▼
                 Automated     CloudWatch
                  Backups       Monitoring
                  1 Day        ├─ High CPU
                               └─ Low Storage