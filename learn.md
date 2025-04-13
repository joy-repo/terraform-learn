# Documentation for Terraform Input Parameters

## Overview
Terraform input parameters, also known as input variables, allow you to customize configurations without altering the code. They enable reusability and flexibility by letting you define values externally.

## Key Points
1. **Declaration**: Input variables are declared using the `variable` block in Terraform configuration files.
2. **Default Values**: Variables can have default values, which are used if no other value is provided.
3. **Type Constraints**: You can specify the type of a variable (e.g., `string`, `number`, `bool`, `list`, `map`) to enforce input validation.
4. **Variable Files**: Values for variables can be provided through `.tfvars` files or passed directly via the command line.
5. **Environment Variables**: Terraform also supports setting variable values using environment variables prefixed with `TF_VAR_`.

## Example
```hcl
variable "instance_type" {
    description = "Type of EC2 instance"
    type        = string
    default     = "t2.micro"
}

# Usage
resource "aws_instance" "example" {
    instance_type = var.instance_type
}
```

## tfvars and .auto.tfvars Files in Terraform

### What are tfvars Files?
tfvars files (with the extension `.tfvars`) are used to define values for input variables outside of the main Terraform configuration. They allow you to manage different sets of configurations without modifying your code. To use a tfvars file, you must explicitly reference it with the `-var-file=<filename>` option when running commands like `terraform plan` or `terraform apply`.

### What are .auto.tfvars Files?
Files with the `.auto.tfvars` extension are similar to tfvars files but with one key difference: Terraform automatically loads them. This makes managing variable values more convenient, as you don't need to specify them manually on the command line during execution.

### When to Use Which?
- **tfvars Files**: Use when you want explicit control over which variable files are being applied. This is useful for switching contexts (e.g., development, staging, production) by specifying different tfvars files.
- **.auto.tfvars Files**: Use when you prefer automatic loading of variable values. They offer simplicity and reduce potential mistakes related to forgetting to specify the variable file.

### Advantages
- **tfvars Files**
    - Explicit control over configuration.
    - Easier to manage multiple environments by switching in the CLI command.
    - Prevents accidental overrides since files aren’t loaded automatically.

- **.auto.tfvars Files**
    - Simplifies commands; no need to pass file names explicitly.
    - Automated variable loading reduces human error.
    - Streamlines workflows in single-environment projects or when variable values are standard.


    ## Examples for .tfvars and .auto.tfvars Files

    ### .tfvars File Example
    Create a file named, for example, "dev.tfvars":
    ```hcl
    instance_type = "t2.medium"
    region        = "us-west-2"
    environment   = "development"
    ```
    When using this file, you must reference it explicitly:
    ```bash
    terraform plan -var-file="dev.tfvars"
    ```

    ### .auto.tfvars File Example
    Create a file named with the `.auto.tfvars` extension, for example, "production.auto.tfvars":
    ```hcl
    instance_type = "t2.micro"
    region        = "us-east-1"
    environment   = "production"
    ```
    Terraform automatically loads this file, so no extra CLI flag is required.