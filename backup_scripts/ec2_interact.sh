#!/bin/bash

# to execute locally,
# chmod +x ec2_interact.sh
# ./ec2_interach.sh (start or stop)

# Check if required argument (start/stop) is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 {start|stop}"
    exit 1
fi

# Set AWS credentials in the script
AWS_ACCESS_KEY_ID="temp"
AWS_SECRET_ACCESS_KEY="temp/temp"
AWS_DEFAULT_REGION="us-east-2"

INSTANCE_ID="i-0fb27de75937dc7ea"  # WebKNOSSOS prod

export AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY
export AWS_DEFAULT_REGION

ACTION=$1

case $ACTION in
    start)
        echo "Starting EC2 instance: $INSTANCE_ID"
        aws ec2 start-instances --instance-ids $INSTANCE_ID
        ;;
    stop)
        echo "Stopping EC2 instance: $INSTANCE_ID"
        aws ec2 stop-instances --instance-ids $INSTANCE_ID
        ;;
    *)
        echo "Invalid action: $ACTION. Use 'start' or 'stop'."
        exit 1
        ;;
esac

# Clear credentials after the command execution for security
unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY
unset AWS_DEFAULT_REGION

echo "Action $ACTION completed for instance $INSTANCE_ID."
