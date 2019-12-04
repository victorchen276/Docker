#Install kubectl
sudo curl --silent --location -o /usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/v1.13.7/bin/linux/amd64/kubectl


sudo chmod +x /usr/local/bin/kubectl
#Install JQ and envsubst
sudo yum -y install jq gettext
#Verify the binaries are in the path and executable
for command in kubectl jq envsubst
  do
    which $command &>/dev/null && echo "$command in path" || echo "$command NOT FOUND"
  done


  export ACCOUNT_ID=$(aws sts get-caller-identity --output text --query Account)
  export AWS_REGION=$(curl -s 169.254.169.254/latest/dynamic/instance-identity/document | jq -r '.region')

  echo "export ACCOUNT_ID=${ACCOUNT_ID}" >> ~/.bash_profile
  echo "export AWS_REGION=${AWS_REGION}" >> ~/.bash_profile
  aws configure set default.region ${AWS_REGION}
  aws configure get default.region

# Validate the IAM role

  aws sts get-caller-identity

# CREATE AN SSH KEY
ssh-keygen

# Upload the public key to your EC2 region:
aws ec2 import-key-pair --key-name "eksworkshop" --public-key-material file://~/.ssh/id_rsa.pub


# Launching EKS and all the dependencies will take approximately 15 minutes
eksctl create cluster --name=eksworkshop-eksctl --nodes=3 --alb-ingress-access --region=${AWS_REGION}

# Test the cluster:
# Confirm your Nodes:
kubectl get nodes # if we see our 3 nodes, we know we have authenticated correctly

# Export the Worker Role Name for use throughout the workshop
STACK_NAME=$(eksctl get nodegroup --cluster eksworkshop-eksctl -o json | jq -r '.[].StackName')
INSTANCE_PROFILE_ARN=$(aws cloudformation describe-stacks --stack-name $STACK_NAME | jq -r '.Stacks[].Outputs[] | select(.OutputKey=="InstanceProfileARN") | .OutputValue')
ROLE_NAME=$(aws cloudformation describe-stacks --stack-name $STACK_NAME | jq -r '.Stacks[].Outputs[] | select(.OutputKey=="InstanceRoleARN") | .OutputValue' | cut -f2 -d/)
echo "export ROLE_NAME=${ROLE_NAME}" >> ~/.bash_profile
echo "export INSTANCE_PROFILE_ARN=${INSTANCE_PROFILE_ARN}" >> ~/.bash_profile

# get token
aws eks get-token --cluster-name eksworkshop-eksctl | jq -r '.status.token'

# clean up
unset AWS_SECRET_ACCESS_KEY
unset AWS_ACCESS_KEY_ID
kubectl delete namespace rbac-test
rm aws-auth.yaml
rm rbacuser_creds.sh
rm /tmp/create_output.json
rm rbacuser-role.yaml
