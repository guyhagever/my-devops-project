# Terraform configuration example
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    # Add your providers here, for example:
    # aws = {
    #   source = "hashicorp/aws"
    #   version = "~> 3.0"
    # }
  }
}

# Example: Using local backend (update as needed)
backend "local" {
  path = "./terraform.tfstate"
}

provider "local" {
  # This is just a placeholder provider
}

# Example resource (for demonstration):
resource "local_file" "example" {
  filename = "${path.module}/example.txt"
  content  = "Hello from Terraform!"
}
