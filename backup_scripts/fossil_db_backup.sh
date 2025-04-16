#!/bin/bash

# Log file for debugging
LOGFILE="/home/ec2-user/opt/webknossos/backup.log"

{
  echo "Starting backup at $(date +"%Y-%m-%d_%H-%M-%S")"

  # Set the environment variables
  export AWS_ACCESS_KEY_ID=some-value
  export AWS_SECRET_ACCESS_KEY=some-value
  export AWS_DEFAULT_REGION=us-east-2
  export S3_BUCKET=linc-brain-mit-prod-us-east-2

  # Define the subdirectory to back up and the S3 bucket name
  BACKUP_DIRECTORY="/home/ec2-user/opt/webknossos/persistent/fossildb/backup/private"
  TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
  BACKUP_NAME="backup_$TIMESTAMP"

  # Set the working directory to where docker-compose.yml is located
  cd /home/ec2-user/opt/webknossos

  # Call the docker-compose step without TTY
  /usr/local/bin/docker-compose up -d --no-deps --no-recreate fossil-db-backup

  if [ $? -ne 0 ]; then
    echo "Docker-compose step failed"
    exit 1
  fi

  # Create a snapshot of the backup directory using rsync to avoid file changes during copy
  SNAPSHOT_DIRECTORY="/tmp/$BACKUP_NAME"
  /usr/bin/rsync -a --delete $BACKUP_DIRECTORY/ $SNAPSHOT_DIRECTORY/

  if [ $? -ne 0 ]; then
    echo "Failed to create a snapshot using rsync"
    exit 1
  fi

  # Upload the snapshot directory to the S3 bucket recursively
  /usr/bin/aws s3 cp $SNAPSHOT_DIRECTORY s3://$S3_BUCKET/fossil_backups/$BACKUP_NAME/ --recursive

  if [ $? -ne 0 ]; then
    echo "Failed to upload to S3"
    exit 1
  fi

  # Clean up the snapshot directory
  /bin/rm -rf $SNAPSHOT_DIRECTORY

  echo "Backup completed and uploaded to S3 at $(date +"%Y-%m-%d_%H-%M-%S")"
} >> $LOGFILE 2>&1
