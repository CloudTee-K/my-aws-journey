```markdown
## Bastion Host and PostgreSQL Commands

### Verify Available PostgreSQL Packages

```bash
dnf list available | grep -i postgresql

Install PostgreSQL 18 Client
sudo dnf install postgresql18 -y

Verify PostgreSQL Client
psql --version

Test RDS DNS Resolution
  getent hosts <RDS-ENDPOINT>

  Connect to RDS PostgreSQL
psql -h <RDS-ENDPOINT> -U dbadmin -d projectdb

Create Test Table
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100)
);
Insert Test Record
INSERT INTO users (name, email)
VALUES ('Jane Doe', 'jane@example.com');

Query Test Data
SELECT * FROM users;
List Tables
\dt

Exit PostgreSQL
\q