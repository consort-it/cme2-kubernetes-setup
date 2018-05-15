!/bin/bash

# NOTE temporarely removed download cause local files are most latest and contain some modification not yet pushed
#####rm -r download
#####mkdir download
cd download

#####git archive --remote=git@gitlab.consort-it.de:cme/consort-infrastructure.git HEAD:terraform/aws/k8s/ingress ingress-controller.yaml | tar -x

#####git archive --remote=git@gitlab.consort-it.de:cme/consort-infrastructure.git HEAD:terraform/aws/k8s/ingress skipper.yaml | tar -x

#####git archive --remote=git@gitlab.consort-it.de:cme/consort-infrastructure.git HEAD:terraform/aws/k8s/external-dns external-dns.yaml | tar -x

#git archive --remote=git@gitlab.consort-it.de:cme/consort-infrastructure.git HEAD:terraform/aws/k8s sg-dev-k8s.tf | tar -x
#terraform apply download/sg-dev-k8s.tf

cd ..

echo "Please kindly enter your AWS_REGION (eu-central-1) BASE64-DECODED: "
read AWS_REGION

echo "Please kindly enter your AWS_CLOUDWATCH_ACCESS (...) BASE64-DECODED: "
read AWS_CLOUDWATCH_ACCESS

echo "Please kindly enter your AWS_CLOUDWATCH_SECRET (...) BASE64-DECODED: "
read AWS_CLOUDWATCH_SECRET

kubectl create -f download/sa_admin.yaml
kubectl create -f download/sa_admin_rolebinding.yaml
#kubectl create -f download/sa_suadmin_rolebinding.yaml
kubectl create -f download/ingress-controller.yaml
kubectl create -f download/skipper.yaml
#kubectl create -f download/external-dns.yaml
AWS_REGION=$AWS_REGION AWS_CLOUDWATCH_ACCESS=$AWS_CLOUDWATCH_ACCESS AWS_CLOUDWATCH_SECRET=$AWS_CLOUDWATCH_SECRET envsubst<download/fluentd-k8s-cloudwatch-secrets.yaml > download/fluentd-k8s-cloudwatch-secrets_interpol.yaml
kubectl create -f download/fluentd-k8s-cloudwatch-secrets_interpol.yaml 
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml

# NOTE for testing purpose another Microservice gets deployed. Microservice should be available by /jira?etc then
#kubectl create -f download/jira.yaml

kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep admin-user | awk '{print $1}')

echo "http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/"
