lunch an ec2 instance, ubuntu 18

install aws cli
sudo apt update
#sudo apt install awscli
#requires awscli 1.15 or higher for eks
sudo apt install python3-pip
pip3 install --upgrade --user awscli
export PATH=/home/ec2-user/.local/bin:$PATH

create a iam user and its access key
run this command to configure awscli
  aws configure

ap-southeast-2
json

  aws ec2 import-key-pair --key-name "eksworkshop" --public-key-material file://~/.ssh/id_rsa.pub

install kubectl
  sudo curl --silent --location -o /usr/local/bin/kubectl https://amazon-eks.s3-us-west-2.amazonaws.com/1.14.6/2019-08-22/bin/linux/amd64/kubectl
  sudo chmod +x /usr/local/bin/kubectl
  sudo apt-get update
  sudo apt-get -y install jq gettext bash-completion


Verify the binaries are in the path and executable
  for command in kubectl jq envsubst
    do
      which $command &>/dev/null && echo "$command in path" || echo "$command NOT FOUND"
      done

Enable kubectl bash_completion
  kubectl completion bash >>  ~/.bash_completion
  . /etc/profile.d/bash_completion.sh
  . ~/.bash_completion


create IAM role eksworkshop-admin
ATTACH THE IAM ROLE TO YOUR WORKSPACE

CLONE THE SERVICE REPOS
  cd ~/environment
  git clone https://github.com/brentley/ecsdemo-frontend.git
  git clone https://github.com/brentley/ecsdemo-nodejs.git
  git clone https://github.com/brentley/ecsdemo-crystal.git

CREATE AN SSH KEY
  ssh-keygen

This key will be used on the worker node instances to allow ssh access if necessary.
Press enter 3 times to take the default choices


Upload the public key to your EC2 region:
  aws ec2 import-key-pair --key-name "eksworkshop" --public-key-material file://~/.ssh/id_rsa.pub


To ensure temporary credentials aren’t already in place we will also remove any existing credentials file:
  rm -vf ${HOME}/.aws/credentials
We should configure our aws cli with our current region as default:
  export ACCOUNT_ID=$(aws sts get-caller-identity --output text --query Account)
  export AWS_REGION=$(curl -s 169.254.169.254/latest/dynamic/instance-identity/document | jq -r '.region')

  echo "export ACCOUNT_ID=${ACCOUNT_ID}" | tee -a ~/.bash_profile
  echo "export AWS_REGION=${AWS_REGION}" | tee -a ~/.bash_profile
  aws configure set default.region ${AWS_REGION}
  aws configure get default.region


Validate the IAM role
  aws sts get-caller-identity

The output assumed-role name should contain: eksworkshop-admin

Create an EKS cluster
eksctl create cluster --name=eksworkshop-eksctl --nodes=3 --managed --alb-ingress-access --region=${AWS_REGION}




Launch using eksctl
PREREQUISITES
  curl --silent --location "https://github.com/weaveworks/eksctl/releases/download/latest_release/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
  sudo mv -v /tmp/eksctl /usr/local/bin
  eksctl version

Enable eksctl bash-completion
  eksctl completion bash >> ~/.bash_completion
  . /etc/profile.d/bash_completion.sh
  . ~/.bash_completion

Test the cluster:
  Confirm your nodes:(this command requires awscli 1.15 or higher, if error occurs, check awscli version "aws --version")
    kubectl get nodes
  Export the Worker Role Name for use throughout the workshop:
    STACK_NAME=$(eksctl get nodegroup --cluster eksworkshop-eksctl -o json | jq -r '.[].StackName')
    ROLE_NAME=$(aws cloudformation describe-stack-resources --stack-name $STACK_NAME | jq -r '.StackResources[] | select(.ResourceType=="AWS::IAM::Role") | .PhysicalResourceId')
    echo "export ROLE_NAME=${ROLE_NAME}" | tee -a ~/.bash_profile


kubernetes Dashboard
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v1.10.1/src/deploy/recommended/kubernetes-dashboard.yaml

kubectl proxy --port=8080 --address='0.0.0.0' --disable-filter=true &

/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/
aws eks get-token --cluster-name eksworkshop-eksctl | jq -r '.status.token'

DEPLOY NODEJS BACKEND API
cd ~/environment/ecsdemo-nodejs
kubectl apply -f kubernetes/deployment.yaml
kubectl apply -f kubernetes/service.yaml

We can watch the progress by looking at the deployment status:
kubectl get deployment ecsdemo-nodejs

DEPLOY CRYSTAL BACKEND API

cd ~/environment/ecsdemo-crystal
kubectl apply -f kubernetes/deployment.yaml
kubectl apply -f kubernetes/service.yaml

kubectl get deployment ecsdemo-crystal