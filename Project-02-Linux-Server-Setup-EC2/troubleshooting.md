# Issue: Flask Application Not Displayed Publicly

## Problem

Although the Flask application was running successfully, visiting the EC2 Public IPv4 address displayed the default Nginx welcome page.

---

## Investigation

Verified:

- EC2 instance running
- Security Group configured correctly
- IAM Role attached
- User Data executed successfully
- Session Manager connection established
- Flask process running
- Nginx service active
- Reverse proxy configuration present
- Local curl tests successful

Commands used:

```bash
sudo systemctl status nginx

ps -ef | grep python

sudo ss -tulpn

curl http://127.0.0.1

curl http://127.0.0.1:8080
```

---

## Findings

Both:

```bash
curl http://127.0.0.1
```

and

```bash
curl http://127.0.0.1:8080
```

returned the Flask application's HTML successfully.

This confirmed that the application and reverse proxy were functioning locally.

---

## Current Status

The deployment infrastructure is operational.

The browser behavior will be reviewed further with my mentor to determine why the public endpoint continued to display the default Nginx page.