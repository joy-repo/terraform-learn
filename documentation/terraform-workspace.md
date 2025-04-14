# 🧩 What is a Terraform Workspace?

Terraform **workspaces** are a feature that enables you to use the **same Terraform configuration** to manage **multiple state files**. This is useful when you want to deploy the same infrastructure in different environments (e.g., `dev`, `staging`, `prod`) **without duplicating code**.

---

## 🔄 Default Behavior

By default, 
Terraform has a single workspace named `default`. When you initialize Terraform, it stores the state in `terraform.tfstate` under this workspace.

---

## 🧪 Why Use Workspaces?

Workspaces allow you to:
- Maintain **isolated state** per environment
- Reuse the same **configuration**
- Avoid manually editing state or duplicating Terraform code


---

## 🧰 Common Workspace Commands

```bash
terraform workspace list #Lists all existing workspaces.
terraform workspace new <name> # Creates a new workspace (e.g., dev, prod).
terraform workspace select <name> # Switches to an existing workspace.
terraform workspace show  # Displays the currently active workspace.
```

### How Workspaces Affect State

Each workspace has its own state file. If using local backend, they are stored in:

* Local Env :

```bash
terraform.tfstate.d/<workspace_name>/terraform.tfstate

```

* AWS backend:

can use : ${terraform.workspace}

```hcl
terraform {
  backend "s3" {
    bucket = "my-terraform-state-bucket"
    key    = "envs/${terraform.workspace}/terraform.tfstate"
    region = "us-east-1"
  }
}

```

```bash
terraform workspace new dev
terraform apply     # deploys infrastructure to dev

terraform workspace new prod
terraform apply     # deploys infrastructure to prod
```