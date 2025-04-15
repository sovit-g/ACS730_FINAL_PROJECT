# Deployment Instructions for Terraform Infrastructure
#ACS730 Final Project – Two-Tier Web Application Deployment

## Prerequisites
#Before deploying the infrastructure, ensure the following prerequisites are met:
- Create an S3 Bucket for Terraform remote state storage:
   
   bucket name: acs730-final-group-project-bucket
   region: us-east-1
   

- Generate an SSH Key Pair to access EC2 instances:
   
   ssh-keygen -t rsa  -f ~/.ssh/access_key
   

- Import the SSH Key Pair into AWS:
   
   aws ec2 import-key-pair --key-name access_key --public-key-material fileb://~/.ssh/access_key.pub

- Install Terraform on cloud-based IDE like AWS Cloud9
  sudo yum install -y yum-utils
  sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
  sudo yum -y install terraform

- Install Ansible for configuration management

- Install Python 'boto3': 

	pip install boto3






##Project Deployment Steps

1. Clone the Repository

 git clone https://github.com/sovit-g/ACS730_FINAL_PROJECT.git
 cd ACS730_FINAL_PROJECT



2. Copy SSH public Key

 cp ~/.ssh/access_key.pub /home/ec2-user/environment/terraform/webserver/access_key.pub 


3. Deploy Terraform – VPC and EC2 Setup

a. Create Network Infrastructure

 cd ~/environment/ACS730_FINAL_PROJECT/terraform/network
 terraform init
 terraform validate
 terraform plan
 terraform apply


b. Deploy Web Servers and DB servers

 cd ~/environment/ACS730_FINAL_PROJECT/terraform/webserver
 terraform init
 terraform validate
 terraform plan
 terraform apply


4.Ansible Configuration and Deployment

a. Install Ansible & Dependencies

 pip3 install boto3
 python3 -m pip install --user ansible


b. Navigate to Ansible Directory

 cd ~/environment/ACS730_FINAL_PROJECT/ansiblefinal/

c. Run Ansible Playbooks

   Note: Before running Ansible, upload a file named "Project_Architecture_Diagram.png" manually to S3 bucket "acs730-final-group-project-bucket".  


I. Download image from S3 bucket:
   
   ansible-playbook s3playbook.yml
 
  

II. Deploy Web Server Configuration using Ansible:
   
   cd ~/environment/ACS730_FINAL_PROJECT/ansiblefinal/
   ansible-playbook -i aws_ec2.yml myplaybook.yml

## Conclusion
After completing these steps, the two-tier web application infrastructure, including networking and web server setup, should be successfully deployed and configured using Terraform and Ansible.
