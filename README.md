# AWS Infrastructure with Terraform

This project automates the provisioning of AWS resources using Terraform. The resources include an EC2 instance, an S3 bucket, a DynamoDB table, and a security group.

## 🚀 Features
- **EC2 Instance**: Amazon Linux 2 instance with a security group allowing HTTP (80) and SSH (22) access.
- **S3 Bucket**: Secure, versioned S3 bucket with AES-256 encryption.
- **DynamoDB Table**: A table to support Terraform state locking.
- **Security Group**: Open inbound rules for HTTP and SSH.

## 📁 Project Structure

📂 terraform-project ├── main.tf # Terraform configuration for AWS resources ├── variables.tf # Variables for Terraform (if needed) ├── outputs.tf # Outputs of Terraform resources ├── README.md # Project documentation ├── .gitignore # Ignore Terraform state files and backups


## ⚙️ Prerequisites
- Install **Terraform**: [Download Terraform](https://developer.hashicorp.com/terraform/downloads)
- Configure **AWS CLI**:  
  ```sh
  aws configure


🔧 Usage

Initialize Terraform:
```sh
terraform init

Plan Deployment:

terraform plan

Apply Changes:

terraform apply -auto-approve

Destroy Resources:

terraform destroy -auto-approve

📌 Notes

The EC2 instance uses the latest Amazon Linux 2 AMI.
The S3 bucket has versioning and encryption enabled.
Terraform state is not stored remotely in this setup.

📜 License

This project is licensed under the MIT License.

This README provides clear documentation on how to use the Terraform project. Let me know if you need any modifications! 🚀
