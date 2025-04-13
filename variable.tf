variable "aws_region" {
  default     = "us-east-1"
  description = "AWS region to deploy resources"
}

variable "aws_profile" {
  type        = string
  default     = "default"
  description = "AWS CLI profile name"
}

variable "aws_access_key" {
  type        = string
  default     = ""
  description = "AWS Access Key (optional)"
}

variable "aws_secret_key" {
  type        = string
  default     = ""
  description = "AWS Secret Key (optional)"
}

variable "key_name" {
  description = "SSH key pair name"
  type        = string
}
