#!/bin/bash

kops create cluster --name $KOPS_CLUSTER_NAME --zones $AWS_AVAILABILITY_ZONES --cloud-labels kubernetes.io/cluster/$KOPS_CLUSTER_NAME=owned --out=. --target=terraform --yes

kops edit cluster --name $KOPS_CLUSTER_NAME 

AWS_PROFILE=$AWS_PROFILE kops update cluster --name $KOPS_CLUSTER_NAME --state=$KOPS_STATE_STORE --out=. --target=terraform

vim kubernetes.tf

#git archive --remote=git@gitlab.consort-it.de:cme/consort-infrastructure.git HEAD:terraform/aws/k8s sg-dev-k8s.tf | tar -x

terraform init
terraform apply --auto-approve
