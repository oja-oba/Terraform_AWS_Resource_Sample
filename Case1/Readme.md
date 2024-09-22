Terraform VPC, RDS, and NGINX Web Server Deployment
Project Overview
This Terraform configuration automates the deployment of a secure and scalable infrastructure on AWS. The resources provisioned include a VPC, RDS (Relational Database Service) for database management, and an NGINX Web Server hosted on an EC2 instance, which connects to the VPC.

Resources Created
VPC (Virtual Private Cloud):

A custom VPC to isolate and secure your infrastructure.
Subnets: Public and Private subnets for organizing resources.
Internet Gateway and Route Tables for enabling internet access where necessary.
RDS (Relational Database Service):

Amazon RDS instance for managing your database.
Configured within the private subnet of the VPC for security purposes.
Parameters for instance class, engine type (e.g., MySQL/PostgreSQL), and storage size.
NGINX Web Server (EC2 Instance):

An EC2 instance running NGINX as a web server.
Connected to the VPC in a public subnet to handle web traffic.
Configured with the necessary security groups and inbound rules.
Usage
Prerequisites
Before running this project, ensure the following:

Terraform is installed on your local machine. Install Terraform
AWS CLI is configured with your credentials and has appropriate permissions.
You have an SSH key to connect to the EC2 instance.
Steps to Deploy
Clone the repository:

bash
Copy code
git clone <repository-url>
cd <repository-directory>
Initialize Terraform: This command initializes the Terraform environment and downloads the necessary providers.

bash
Copy code
terraform init
Review the plan: This allows you to see the resources Terraform will create.

bash
Copy code
terraform plan
Apply the configuration: Apply the changes to deploy the infrastructure.

bash
Copy code
terraform apply
Access the NGINX web server: Once the deployment is complete, you can access the NGINX web server by visiting the public IP of the EC2 instance.

Clean Up
To avoid ongoing costs, ensure you destroy the infrastructure when it’s no longer needed:

bash
Copy code
terraform destroy
Configuration
This project includes customizable variables such as:

VPC CIDR block
Subnets CIDR blocks
RDS Instance type, database engine, and storage
EC2 instance type and AMI for NGINX
You can modify these variables in the variables.tf file to suit your needs.

Security Considerations
The RDS instance is deployed in a private subnet, preventing direct exposure to the internet.
Security groups are configured to allow necessary traffic (e.g., HTTP, SSH) while minimizing exposure.
Ensure that secrets, such as database credentials, are managed securely (e.g., via AWS Secrets Manager).