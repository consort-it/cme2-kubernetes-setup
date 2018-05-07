#!/bin/bash

aws ec2 create-security-group --description ingress.$KOPS_CLUSTER_NAME --group-name ingress.$KOPS_CLUSTER_NAME --vpc-id $VPC_ID
#aws ec2 describe-security-groups --filter Name=vpc-id,Values=$VPC_ID  Name=group-name,Values=ingress.$KOPS_CLUSTER_NAME
export sgidingress=$(aws ec2 describe-security-groups --filter Name=vpc-id,Values=$VPC_ID  Name=group-name,Values=ingress.$KOPS_CLUSTER_NAME | jq '.["SecurityGroups"][0]["GroupId"]' -r)
export sgidnode=$(aws ec2 describe-security-groups --filter Name=vpc-id,Values=$VPC_ID  Name=group-name,Values=nodes.$KOPS_CLUSTER_NAME | jq '.["SecurityGroups"][0]["GroupId"]' -r)
aws ec2 authorize-security-group-ingress --group-id $sgidingress --protocol tcp --port 443 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-id $sgidingress --protocol tcp --port 80 --cidr 0.0.0.0/0

aws ec2 authorize-security-group-ingress --group-id $sgidnode --protocol all --port -1 --source-group $sgidingress
aws ec2 create-tags --resources $sgidingress --tags Key="kubernetes.io/cluster/${KOPS_CLUSTER_NAME}",Value="owned" Key="kubernetes:application",Value="kube-ingress-aws-controller"


