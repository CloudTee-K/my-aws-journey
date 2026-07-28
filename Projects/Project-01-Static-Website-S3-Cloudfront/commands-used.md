## Step 1 – Create S3 Bucket

Created an Amazon S3 bucket through the AWS Management Console.

Bucket Name:cloudtee-static-website-2026
Region:us-east-1

## Step 2 – Enable Static Website Hosting

Enabled static website hosting for the S3 bucket.

Configuration:

- Hosting Type: Static Website
- Index Document: index.html
- Error Document: index.html

## Step 3 – Configure Bucket Policy

Configured a bucket policy to allow public read access to website objects.

Permission granted:

- s3:GetObject

Bucket:

cloudtee-static-website-2026

## Step 4 – Upload Website Files

Uploaded the following files to the S3 bucket:

- index.html
- contact.html
- css/styles.css
- js/main.js

Verified that the folder structure was preserved.

## Step 5 – Create CloudFront Distribution

Created a CloudFront distribution.

Origin:
cloudtee-static-website-2026.s3-website-us-east-1.amazonaws.com

Viewer Protocol Policy:
Redirect HTTP to HTTPS

Default Root Object:
index.html