# 🚀 Terraform AWS Infrastructure

![Terraform](https://img.shields.io/badge/Terraform-v1.9%2B-623CE4?logo=terraform)
![AWS](https://img.shields.io/badge/AWS-Cloud-orange?logo=amazonaws)
![License](https://img.shields.io/badge/License-MIT-green)
![IaC](https://img.shields.io/badge/Infrastructure--as--Code-Enabled-blue)

A modular **Terraform project** to provision AWS infrastructure, including **VPC**, **EC2**, and **IAM roles**, with remote state management via **S3 + DynamoDB**.  
Designed for **multi-environment deployments** (`dev`, `stage`, `prod`) following infrastructure-as-code (IaC) best practices.

---

## ⚙️ Prerequisites

Before you begin, ensure the following:

- ✅ Terraform **v1.9+**
- ✅ AWS CLI configured (`aws configure`)
- ✅ An existing **EC2 Key Pair** in your region  
- ✅ IAM user with programmatic access & `AdministratorAccess` policy (for setup)

---

## ☁️ Remote Backend Setup (S3 + DynamoDB)

This project stores Terraform state remotely in S3 with state locking via DynamoDB.

### Step 1 — Create the S3 bucket and DynamoDB table

```bash
aws s3api create-bucket --bucket my-terraform-backend-bucket --region us-east-1

aws dynamodb create-table \
  --table-name terraform-locks \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST
```

### Step 2 - Update your backend.tf file

```bash
terraform {
  backend "s3" {
    bucket         = "my-terraform-backend-bucket"
    key            = "env/dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
```
🚀 Deployment Steps

1️⃣ Initialize Terraform
```bash
terraform init
```
2️⃣ Validate and Plan
```bash
terraform plan -var-file="env/dev/main.tfvars"
```
3️⃣ Apply Infrastructurre
```bash
terraform apply -var-file="env/dev/main.tfvars"
```
4️⃣ Destroy (when needed)
```bash
terraform destroy -var-file="env/dev/main.tfvars"
```
⚠️ Before destroying, migrate your state back to local if you want to delete the S3 backend bucket:
```bash
terraform init -migrate-state -backend-config="path=terraform.tfstate"
```

📊 Outputs

Once deployed, Terraform will display key outputs like:

| Output Name     | Description               |
| --------------- | ------------------------- |
| `vpc_id`        | The created VPC ID        |
| `ec2_public_ip` | Public IP of EC2 instance |
| `iam_role_arn`  | ARN of IAM role created   |

🧩 Modules Overview

| Module  | Description                                                 |
| ------- | ----------------------------------------------------------- |
| **VPC** | Creates VPC, subnets, IGW, and route tables                 |
| **EC2** | Launches EC2 instance(s) with security groups and user data |
| **IAM** | Creates IAM roles and attaches policies for EC2 access      |

🧰 Useful Commands

| Command                      | Description                  |
| ---------------------------- | ---------------------------- |
| `terraform fmt`              | Format code                  |
| `terraform validate`         | Validate configuration       |
| `terraform state list`       | List resources in state      |
| `terraform taint <resource>` | Mark resource for recreation |
| `terraform output`           | Show all output variables    |

🧱 Infrastructure Diagram

          +----------------------+
          |      AWS Cloud       |
          |----------------------|
          |     VPC (10.0.0.0)   |
          |   ┌──────────────┐   |
          |   │  Subnet      │   |
          |   │  EC2 (t2.micro)│
          |   └──────┬───────┘   |
          |          │            |
          |     IAM Role/Policy   |
          +----------┼-------------+
                     │
              S3 Backend + DynamoDB Lock
       
