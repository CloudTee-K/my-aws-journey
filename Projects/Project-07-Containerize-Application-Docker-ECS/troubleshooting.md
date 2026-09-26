# Project 07 - Troubleshooting

This document records the major technical issues encountered while containerizing and deploying the application with Docker and Amazon ECS.

---

## Issue 1 - Docker Desktop Could Not Start Correctly

### Problem

Docker Desktop was installed, but the Docker Engine was not functioning correctly.

### Investigation

The system virtualization status showed that virtualization support was not enabled in the computer firmware.

### Cause

CPU virtualization was disabled in the BIOS.

### Solution

Entered the HP BIOS settings and enabled:

```text
Virtualization Technology (VTx)
```

After restarting Windows, virtualization was confirmed as enabled.

### Lesson Learned

Docker Desktop using the WSL 2 backend depends on hardware virtualization. When Docker fails at the virtualization layer, application-level troubleshooting will not solve the problem.

---

## Issue 2 - Windows Optional Features Could Not Be Enabled

### Problem

Attempts to enable WSL and Virtual Machine Platform produced Windows servicing errors including:

```text
0x800f080c
0x800f0819
```

Windows optional-feature commands were not operating correctly.

### Troubleshooting

Windows system integrity was checked using DISM and System File Checker.

DISM reported that the component store was healthy.

System File Checker detected and repaired corrupted Windows files, but the optional-feature problem remained.

### Solution

A Windows 10 in-place repair upgrade was performed while selecting:

```text
Keep personal files and apps
```

After the repair, Windows optional features could be queried and enabled successfully.

The following features were then enabled:

```powershell
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
```

```powershell
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
```

The computer was restarted afterward.

### Lesson Learned

Docker problems can originate below Docker itself. Windows servicing, virtualization, and WSL must all be functioning correctly for the Docker Desktop WSL 2 backend to operate reliably.

---

## Issue 3 - WSL Kernel Was Missing

### Problem

After enabling WSL, the system showed:

```text
Default Version: 2
```

but the required WSL kernel was not fully available.

### Solution

Updated WSL:

```powershell
wsl --update
```

Docker Desktop was then able to use its WSL 2 backend successfully.

Validation:

```powershell
docker info
docker run --rm hello-world
```

The `hello-world` container completed successfully.

---

## Issue 4 - Incorrect Docker Build Context

### Problem

While already inside the backend directory, an initial build command referenced:

```text
.\app\backend
```

This was the wrong relative path from the current directory.

### Solution

Used the current directory as the Docker build context:

```powershell
docker build -t project07-backend:latest .
```

### Lesson Learned

Docker build paths are evaluated relative to the shell's current working directory.

Always verify the current directory before running path-dependent commands.

---

## Issue 5 - ECR Push Network Timeout

### Problem

The first backend image push to Amazon ECR timed out while uploading some image layers.

### Solution

The push command was retried:

```powershell
docker push "$ECR_REGISTRY/project07-backend:latest"
```

Docker reused already-uploaded layers, and the image push completed successfully.

### Lesson Learned

Container registries upload images as layers. A temporary network failure does not necessarily require rebuilding or retagging the image.

---

## Issue 6 - PowerShell Parser Errors from Pasted Output

### Problem

AWS CLI command output was accidentally pasted back into PowerShell together with the next command.

PowerShell attempted to interpret the output text as executable commands and returned parser errors.

### Cause

Terminal output and shell prompt text were included with the intended command.

### Solution

The command was entered again using only the actual PowerShell command.

No AWS resources were damaged by the failed local parsing attempt.

### Lesson Learned

Only command text should be copied into the terminal.

Shell prompts and previous command output should not be included.

---

## Issue 7 - Frontend ECS Tasks Continuously Stopped

### Problem

The backend ECS service became healthy, but the frontend ECS service repeatedly started and stopped tasks.

The service could not maintain a healthy frontend task.

### Investigation

Stopped ECS tasks were inspected.

The task reported:

```text
StopCode: EssentialContainerExited
```

and the frontend container returned:

```text
ExitCode: 1
```

CloudWatch logs were then inspected.

The important Nginx error was:

```text
host not found in upstream "project07-backend-container"
```

### Root Cause

The original Nginx configuration contained an upstream similar to:

```text
project07-backend-container:3000
```

This worked locally because the frontend and backend containers were connected to the same custom Docker network.

Docker provided hostname resolution for the backend container name.

In AWS, however, the frontend and backend were deployed as separate ECS services.

The local Docker container hostname therefore did not exist in the ECS service architecture.

### Solution

The production Nginx configuration was changed so that it only served the frontend application.

The `/api/*` proxy configuration was removed from Nginx.

The Application Load Balancer was used for routing instead:

```text
/       → Frontend Target Group → Frontend ECS Service
/api/*  → Backend Target Group  → Backend ECS Service
```

The frontend Docker image was rebuilt:

```powershell
docker build -t project07-frontend:latest .
```

The corrected image was tagged and pushed to ECR.

A new ECS deployment was then forced:

```powershell
aws ecs update-service `
  --cluster project07-cluster `
  --service project07-frontend-service `
  --force-new-deployment `
  --region $AWS_REGION
```

The replacement frontend task successfully started and became healthy.

### Lesson Learned

Local Docker networking and ECS service networking are different architectural environments.

A hostname that works between containers on a local Docker network should not automatically be expected to work between independent ECS services.

CloudWatch logs were essential for identifying the actual container failure instead of guessing from the ECS service status alone.

---

## Issue 8 - ECR Authorization Token Expired

### Problem

After fixing the frontend configuration, pushing the rebuilt image failed with:

```text
Your authorization token has expired.
Reauthenticate and try again.
```

### Cause

The previous Docker authentication session with Amazon ECR had expired.

### Solution

Authenticated Docker with ECR again:

```powershell
aws ecr get-login-password --region $AWS_REGION |
docker login `
  --username AWS `
  --password-stdin $ECR_REGISTRY
```

Then retried:

```powershell
docker push "$ECR_REGISTRY/project07-frontend:latest"
```

The push completed successfully.

### Lesson Learned

ECR Docker authentication is temporary. Authentication may need to be refreshed during longer deployment sessions.

---

## Issue 9 - Auto Scaling JSON Failed in PowerShell

### Problem

An attempt to provide the target-tracking configuration directly as inline JSON to the AWS CLI failed.

The CLI reported an error similar to:

```text
Invalid JSON: Expecting property name enclosed in double quotes
```

### Cause

PowerShell quoting altered the JSON passed to the AWS CLI.

### Solution

Instead of passing complex JSON inline, the configuration was written to a temporary JSON file:

```powershell
@'
{
  "TargetValue": 70.0,
  "PredefinedMetricSpecification": {
    "PredefinedMetricType": "ECSServiceAverageCPUUtilization"
  },
  "ScaleOutCooldown": 60,
  "ScaleInCooldown": 60
}
'@ | Set-Content -Encoding ascii scaling-config.json
```

The file was then supplied to the AWS CLI using:

```text
file://scaling-config.json
```

The scaling policy was created successfully.

Verification showed:

```text
Policy: project07-backend-cpu-scaling
Metric: ECSServiceAverageCPUUtilization
Target CPU: 70
```

The temporary JSON file was later removed from the project.

### Lesson Learned

For complex AWS CLI parameters in PowerShell, using a JSON file can be more reliable than deeply nested inline quoting.

---

## Troubleshooting Method Used

The general troubleshooting process followed during this project was:

```text
Observe the failure
        ↓
Check service/task status
        ↓
Inspect stopped task information
        ↓
Inspect CloudWatch logs
        ↓
Identify the root cause
        ↓
Modify configuration
        ↓
Rebuild container
        ↓
Push new image
        ↓
Redeploy service
        ↓
Verify target health
        ↓
Test application
```

This prevented random configuration changes and made troubleshooting evidence-driven.

---

## Key Troubleshooting Lessons

The project demonstrated that container deployment problems can occur at several different layers:

```text
Hardware
↓
Windows
↓
WSL
↓
Docker
↓
Container
↓
Amazon ECR
↓
ECS Task
↓
ECS Service
↓
Load Balancer
↓
Application
```

Successful troubleshooting requires identifying **which layer is actually failing** before attempting a fix.

The most important example was the frontend ECS failure: ECS showed that the task had stopped, but CloudWatch revealed the actual cause inside Nginx.