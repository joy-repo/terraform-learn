# Introduction to Terraform Commands: init, plan, and apply

Terraform is an Infrastructure as Code tool that uses configuration files to provision and manage infrastructure. The core commands you'll use in a Terraform workflow are `init`, `plan`, and `apply`.

## terraform init
- **Purpose**: Initializes the working directory containing Terraform configuration files. This command downloads the required provider plugins and sets up the backend for the state file.
- **When to Use**: Run `terraform init` when you first create a configuration or when you change provider configurations.
  
**Example**:
```bash
terraform init
```
This command will output logs such as downloading providers, setting up the backend, and preparing the environment for further commands.

## terraform plan
- **Purpose**: Creates an execution plan by comparing the current state of your infrastructure with the configuration files. It shows you what changes will be made without applying them.
- **When to Use**: Run `terraform plan` before applying changes to review what actions Terraform intends to perform.
  
**Example**:
```bash
terraform plan
```
The output details what resources will be created, updated, or destroyed. This allows you to verify that your changes are expected and minimize the risk of unintentional modifications.

## terraform apply
- **Purpose**: Applies the changes required to reach the desired state of the configuration. This command executes the plan and actually provisions the infrastructure.
- **When to Use**: Once you’re satisfied with the plan, run `terraform apply` to implement the changes.
  
**Example**:
```bash
terraform apply
```
During execution, Terraform will prompt for confirmation before making any changes unless you use the `-auto-approve` flag.

## Full Example Workflow
Assume you have a configuration file `main.tf`. A typical workflow might look like:
1. **Initialize the working directory**:
    ```bash
    terraform init
    ```
2. **Review the changes**:
    ```bash
    terraform plan
    ```
3. **Apply the changes to update your infrastructure**:
    ```bash
    terraform apply
    ```

Each step ensures that you have a controlled process for managing infrastructure, reducing risks associated with changes.

# What is `tfstate`?

In Terraform, the `tfstate` file plays a critical role in managing infrastructure as code. It is a file used by Terraform to **store the current state of the infrastructure** that it manages.

## 📘 Purpose of `tfstate`

Terraform needs to keep track of what real-world infrastructure it is managing. This state is stored in a file called `terraform.tfstate`, and it allows Terraform to:

- **Map configuration to real-world resources**.
- **Track metadata** (like resource dependencies).
- **Detect changes** and plan updates (using `terraform plan` and `terraform apply`).

## 🗃️ What Does It Contain?

The `tfstate` file is a **JSON** file that includes:

- Resource IDs
- Attributes (like IP addresses, tags, etc.)
- Dependencies
- Outputs
- Module structure

Example snippet:
```json
{
  "resources": [
    {
      "type": "aws_instance",
      "name": "web",
      "instances": [
        {
          "attributes": {
            "id": "i-1234567890abcdef0",
            "ami": "ami-0abcdef1234567890",
            "instance_type": "t2.micro"
          }
        }
      ]
    }
  ]
}
```

# How to Create an AWS Backend for Terraform

Using an **AWS backend** allows Terraform to **store the `terraform.tfstate` file remotely** in Amazon S3 and optionally use **DynamoDB for state locking**. This enables **collaboration**, **consistency**, and **safe concurrent operations**.

---

## 🏗️ Prerequisites

- AWS CLI configured with proper credentials
- IAM permissions to access S3 and DynamoDB
- Terraform installed

---

## 📦 Step 1: Create an S3 Bucket for Remote State

```bash
aws s3api create-bucket \
  --bucket my-terraform-state-bucket \
  --region us-east-1
```

---
## Enable Versioning (Recommended)

```
aws s3api put-bucket-versioning \
  --bucket my-terraform-state-bucket \
  --versioning-configuration Status=Enabled
```

## Step 2: (Optional but Recommended) Create a DynamoDB Table for State Locking

```bash
aws dynamodb create-table \
  --table-name terraform-locks \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST
```


##  Step 3: Configure the Backend in Terraform

In your Terraform configuration (**main.tf** or a dedicated **backend.tf**):

```tf
terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket"
    key            = "envs/prod/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}

```

***Note: Do not run terraform init until after this file is ready. If you've already initialized with a different backend, use terraform init -reconfigure.***

