#!/bin/bash

# Directory to simulate /var/log
LOG_DIR="/var/log"

echo "Generating sample log files..."

# Recent logs (should NOT be picked by script)
touch $LOG_DIR/app1.log
touch $LOG_DIR/app2.log
touch $LOG_DIR/app3.log
touch $LOG_DIR/system.log
touch $LOG_DIR/auth.log

# Logs older than 30 days (should be picked)
touch -d "40 days ago" $LOG_DIR/old_app1.log
touch -d "45 days ago" $LOG_DIR/old_app2.log
touch -d "50 days ago" $LOG_DIR/old_app3.log
touch -d "60 days ago" $LOG_DIR/nginx.log
touch -d "90 days ago" $LOG_DIR/mysql.log

# Some non-log files (should be ignored)
touch -d "60 days ago" $LOG_DIR/debug.txt
touch -d "70 days ago" $LOG_DIR/archive.tar

echo "--------------------------------------"
echo "Setup completed."
echo "Files created in $LOG_DIR:"
ls -lh $LOG_DIR
echo "--------------------------------------"
