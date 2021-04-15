# EKS Deployment on AWS
The purpose of this simple workshop is to provide guide as a starting of your Kubernetes Journey on top of AWS. We will use terraform, an opensource tool for creating clusters on EKS.
After setting up your EKS Cluster with serverless Fargate, we will deploy a microservices application. 
This tutorial is verified to work on EKS 1.18

## Install terraform

We first install terraform into Cloud9 which is using Amazon Linux

``` 
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum -y install terraform
terraform -help

```

## Create VPC, EKS cluster and fargate profile

``` 
terraform init
terraform apply

```

## Create Kubernetes deployment

```
cd kubernetes

terraform init
terraform apply

```

## View resources created

```
aws eks --region ap-southeast-1 update-kubeconfig --name eks_cluster

mkdir $HOME/bin
curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.18.9/2020-11-02/bin/linux/amd64/kubectl
chmod +x ./kubectl
cp ./kubectl $HOME/bin/kubectl
export PATH=$HOME/bin:$PATH
echo 'export PATH=$HOME/bin:$PATH' >> ~/.bashrc
kubectl version --client

kubectl get pods

```

You should be able to see the resources created