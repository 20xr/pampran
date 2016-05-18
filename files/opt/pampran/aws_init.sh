#!/usr/bin/env bash

echo Retrieving AWS region...
export AWS_REGION=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone | sed 's/.$//')
aws configure set default.region $AWS_REGION

echo Retrieving instance information...
export AWS_INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)

# echo Export instance metadata as environment variables...
# . <(curl -fs http://169.254.169.254/latest/user-data | sed -r 's/^/export /')

echo Export instance tags as environment variables...
. <(aws ec2 describe-tags --filter "Name=resource-id,Values=${AWS_INSTANCE_ID}" --output=text | sed -r 's/TAGS\t(.*)\t.*\t.*\t(.*)/TAG_\1=\2/')

echo Export known instance tags with friendly names...
export INSTANCE_NAME=${TAG_Name}
export TAR_BUCKET=${TAG_tarBucket}

/opt/pampran/pollS3.sh
/opt/pampran/repeatPoll.sh
