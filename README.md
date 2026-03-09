# Log Archiver — DevOps Intern Assessment

Bash script that finds `.log` files older than 30 days, uploads them to S3, deletes locally after successful upload, and sends email via AWS SES.

## Usage
```bash
sudo ./setup_test.sh          # create test files
sudo ./log_archiver.sh        # run the script
```

## Cron — Midnight Daily
```bash
0 0 * * * /usr/local/bin/log_archiver.sh >> /var/log/log_archiver_cron.log 2>&1
```

## Deploy to 50+ EC2s
Upload script to S3, then use SSM Run Command targeting instances by tag — no SSH needed.

## Requirements
- AWS CLI
- IAM Role with S3 + SES permissions
- Email verified in AWS SES
