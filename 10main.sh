#!/bin/bash

export AWS_AVAILABILITY_ZONES=eu-central-1b,eu-central-1c
export S3_BUCKET=consort-kops-state
export KOPS_CLUSTER_NAME=dev.k8s.consort-it.de

export KOPS_STATE_STORE=s3://${S3_BUCKET}
export AWS_PROFILE=default

echo "Kindly enter yout vpc_id of the current installation: "

read vpc_id

# We need the previous VPC ID in order to delete the existing cluster
# get it from here
# https://eu-central-1.console.aws.amazon.com/ec2/v2/home?region=eu-central-1#Instances:sort=launchTime
export VPC_ID=$vpc_id

./11setupAuthorization.sh
./12setupDeploy.sh
