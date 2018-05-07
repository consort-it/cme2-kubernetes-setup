#!/bin/bash

aws ec2 delete-security-group --group-name ingress.$KOPS_CLUSTER_NAME 

AWS_PROFILE=$AWS_PROFILE kops delete cluster --name=$KOPS_CLUSTER_NAME --state=$KOPS_STATE_STORE --yes
