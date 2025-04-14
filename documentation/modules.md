

# Refer : https://github.com/sidpalas/devops-directive-terraform-course/tree/main/06-organization-and-modules

# 📦 Terraform Modules - In-Depth Guide

Terraform **modules** are the **foundation of reusable infrastructure as code**. They allow you to **group and encapsulate resources** in a logical unit, promoting **modularity**, **reusability**, and **clean project structure**.

---

## 🧱 What is a Module?

A **module** in Terraform is a container for multiple resources that are used together. It consists of **Terraform configuration files** (`.tf`) grouped in a directory.

> You can think of modules like functions in programming: they encapsulate logic and allow you to reuse it with different inputs.

---

## 📂 Types of Modules

1. **Root Module**:  
   The primary directory where you run Terraform commands. It consists of your main configuration files.

2. **Child Modules**:  
   Other directories called from the root module using `module` blocks. These can be:
   - Local modules (inside your repo)
   - Remote modules (e.g., from GitHub, Terraform Registry, etc.)

---


## 📌 Basic Module Structure

modules/ 
 └── vpc/ 
    ├── main.tf 
    ├── variables.tf 
    └── outputs.tf


### `main.tf`
Defines the infrastructure resources.

### `variables.tf`
Declares all configurable input variables.

### `outputs.tf`
Defines outputs that can be used by other modules or root module.

## 🛠️ How to Use a Module

```hcl
module "vpc" {
  source = "./modules/vpc"

  ## input var for the child module

  cidr_block = "10.0.0.0/16"
  region     = "us-east-1"
  tags       = {
    Environment = "dev"
  }
}

```

##  Using Remote Modules

You can reference modules hosted externally:

**Terraform Registry:**

```hcl
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.0"
  name    = "my-vpc"
  cidr    = "10.0.0.0/16"
}



```

**GitHub:**

```hcl
module "vpc" {
  source = "git::https://github.com/user/repo.git//modules/vpc?ref=v1.0.0"
}

```

## Example: VPC Module

**modules/vpc/main.tf:***

```hcl
resource "aws_vpc" "main" {
  cidr_block = var.cidr_block
  tags       = var.tags
}

```

**modules/vpc/variables.tf:**

```hcl
variable "cidr_block" {
  type = string
}
variable "tags" {
  type = map(string)
}
```

**modules/vpc/outputs.tf:**

```hcl

output "vpc_id" {
  value = aws_vpc.main.id
}
```

### Using the above VPC module:

**Root - main.tf:**

```hcl
module "vpc" {
  source     = "./modules/vpc"
  cidr_block = "10.0.0.0/16"
  tags       = { Name = "prod-vpc" }
}

```
