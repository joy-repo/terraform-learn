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

# Ways to Set Variables in Terraform

Terraform allows you to supply variable values in several ways:

## 1. Default Values
Define defaults directly within the configuration using the variable block. If no value is provided elsewhere, Terraform uses these defaults.

## 2. tfvars Files
Create a file (e.g., dev.tfvars) containing variable assignments:
```hcl
instance_type = "t2.medium"
region        = "us-west-2"
```
Then reference the file explicitly:
```bash
terraform plan -var-file="dev.tfvars"
```

## 3. .auto.tfvars Files
Files ending with `.auto.tfvars` are automatically loaded by Terraform, eliminating the need for an explicit reference.

## 4. Environment Variables
Set variables as environment variables with the prefix TF_VAR_. For example:
```bash
export TF_VAR_instance_type="t2.micro"
```

## 5. Command-Line Flags
Pass variable values directly during execution:
```bash
terraform apply -var="instance_type=t2.small"
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

    # Terraform Variable Types

    Terraform supports a variety of variable types which improve configuration validation and clarity. These types enforce constraints on variable values, ensuring that your inputs meet expected formats.

    ## Primitive Types

    ### string
    Represents a sequence of characters.
    ```hcl
    variable "example_string" {
        type    = string
        default = "Hello, Terraform"
    }
    ```

    ### number
    Represents numeric values.
    ```hcl
    variable "example_number" {
        type    = number
        default = 42
    }
    ```

    ### bool
    Represents boolean values (true or false).
    ```hcl
    variable "example_bool" {
        type    = bool
        default = true
    }
    ```

    ## Complex Types

    ### list
    An ordered sequence of values.
    ```hcl
    variable "example_list" {
        type    = list(string)
        default = ["one", "two", "three"]
    }
    ```

    ### map
    A collection of key-value pairs.
    ```hcl
    variable "example_map" {
        type    = map(string)
        default = {
            key1 = "value1",
            key2 = "value2"
        }
    }
    ```

    ### set
    An unordered collection of unique values.
    ```hcl
    variable "example_set" {
        type    = set(string)
        default = ["apple", "banana", "cherry"]
    }
    ```

    ### object
    A collection of named attributes with their own types.
    ```hcl
    variable "example_object" {
        type = object({
            name = string,
            age  = number
        })
        default = {
            name = "Alice",
            age  = 30
        }
    }
    ```

    ### tuple
    A fixed-length sequence defined by specific types.
    ```hcl
    variable "example_tuple" {
        type    = tuple([string, number, bool])
        default = ["status", 200, true]
    }
    ```

    ## Any Type

    The "any" type allows any value and disables type checking.
    ```hcl
    variable "example_any" {
        type    = any
        default = "Any value is allowed"
    }
    ```

    Terraform's flexible type system helps enforce the correctness of variable values, leading to more reliable and maintainable configurations.