

#!/bin/bash

# Backup Script using rsync

# Set the source directory and destination directory
SRC="/home/saif/a_to_d"         # Change this to the directory you want to backup
DEST="$HOME/backup/user_backup"     # Change this to your backup destination path

# Create backup directory if not exists
mkdir -p $DEST

# Perform the backup using rsync (archive mode, verbose, delete extraneous files)
echo "Starting backup at $(date)" >> backup.log
rsync -av --delete $SRC $DEST >> backup.log 2>&1

# Check if rsync was successful
if [ $? -eq 0 ]; then
    echo "Backup completed successfully at $(date)" >> backup.log
else
    echo "Backup failed at $(date)" >> backup.log
    exit 1
fi

# Sync backup to cloud storage (AWS S3 example)
# Use the path to your S3 bucket (update with your bucket name)
echo "Syncing backup to AWS S3 at $(date)" >> backup.log
aws s3 sync $SRC s3://saif-bucket >> backup.log 2>&1

# Check if AWS sync was successful
if [ $? -eq 0 ]; then
    echo "Backup uploaded to S3 successfully at $(date)" >> backup.log
else
    echo "S3 upload failed at $(date)" >> backup.log
    exit 1
fi

# Log the backup completion time
echo "Backup process completed at $(date)" >> backup.log

# Optionally, rotate logs to prevent excessive log file size
# This keeps only the last 7 days' logs and removes older ones
find . -name 'backup.log' -mtime +7 -exec rm {} \;

echo "Backup process completed successfully."

