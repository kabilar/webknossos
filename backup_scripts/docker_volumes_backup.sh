#!/bin/bash

# Log file for debugging
LOGFILE="/home/ec2-user/opt/webknossos/docker_volume_backup.log"

{
  echo "Starting backup at $(date +"%Y-%m-%d_%H-%M-%S")"

  # Set the environment variables
  export AWS_ACCESS_KEY_ID=some-value
  export AWS_SECRET_ACCESS_KEY=some-value
  export AWS_DEFAULT_REGION=us-east-2
  export S3_BUCKET=linc-brain-mit-prod-us-east-2

  # Define the directories to back up and the S3 bucket name
  BACKUP_DIRECTORY="/home/ec2-user/opt/webknossos"
  BINARY_DATA_DIR="$BACKUP_DIRECTORY/binaryData"
  PERSISTENT_DIR="$BACKUP_DIRECTORY/persistent"
  TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
  BACKUP_NAME="backup_$TIMESTAMP.tar.gz"

  # Create a tar.gz archive of the specified directories
  /bin/tar -czf /tmp/$BACKUP_NAME -C $BACKUP_DIRECTORY binaryData persistent

  if [ $? -ne 0 ]; then
    echo "Failed to create tar.gz archive"
    exit 1
  fi

  # Upload the backup to the S3 bucket
  /usr/bin/aws s3 cp /tmp/$BACKUP_NAME s3://$S3_BUCKET/docker_volume_backups/$BACKUP_NAME --storage-class GLACIER

  if [ $? -ne 0 ]; then
    echo "Failed to upload to S3"
    exit 1
  fi

  # Clean up the temporary backup file
  /bin/rm /tmp/$BACKUP_NAME

  echo "Backup completed and uploaded to S3 at $(date +"%Y-%m-%d_%H-%M-%S")"
} >> $LOGFILE 2>&1
