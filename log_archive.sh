#!/bin/bash

# Configuration
LOG_DIR="/var/log"
BUCKET="s3://logs-backup-gagan"
EMAIL="anshusharma10172@gmail.com"

# Counters
UPLOADED=0
FAILED=0

echo "Starting log archival process..."

# Check AWS is reachable before doing anything
if ! aws s3 ls "$BUCKET" &>/dev/null; then
    echo "ERROR: S3 bucket unreachable. Exiting."
    aws ses send-email --from "$EMAIL" --to "$EMAIL" --subject "Log Archive FAILED - S3 unreachable" --text "S3 bucket unreachable on $(hostname)" --region ap-south-1
    exit 1
fi

# Find and process old log files
for file in $(find "$LOG_DIR" -name "*.log" -mtime +30 -type f 2>/dev/null)
do
    echo "Uploading: $file"
    aws s3 cp "$file" "$BUCKET/$(hostname)/$(basename $file)"

    if [ $? -eq 0 ]; then
        echo "Upload successful: $file"
        rm -f "$file"
        (( UPLOADED++ ))
    else
        echo "Upload FAILED: $file — keeping local copy"
        (( FAILED++ ))
    fi
done

# Send email summary
aws ses send-email \
    --from "$EMAIL" \
    --to "$EMAIL" \
    --subject "Log Archive Status - $(hostname)" \
    --text "Log archival complete. Uploaded: $UPLOADED | Failed: $FAILED" \
    --region ap-south-1

echo "Done. Uploaded: $UPLOADED | Failed: $FAILED"
