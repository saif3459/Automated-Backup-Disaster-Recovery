#!/bin/bash

# Backup Script using rsync

# Set the source directory and destination directory
SRC="/home/user"        # Change this to the directory you want to backup
DEST="/backup/user_backup"  # Change this to your backup destination path

# Create backup directory if not exists
mkdir -p $DEST

# Perform the backup using rsync (archive mode, verbose, delete extraneous files)
rsync -av --delete $SRC $DEST

# Optionally, sync backup to cloud storage (AWS S3 example)
# Make sure you have AWS CLI configured before running this line
echo "before aws"
aws s3 sync $DEST s3://your-bucket-name/backup/

# Log the backup time and completion status
echo "Backup completed at $(date)" >> /var/log/backup.log
