# -------------------------------------
# Terraform configuration
# -------------------------------------
terraform {
  required_version = ">= 0.14.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.5.0"
    }
  }
}

# -------------------------------------
# Provider configuration
# -------------------------------------
provider "aws" {
  region = var.region
  default_tags {
    tags = {
      project    = var.project
      env        = var.env
      managed_by = "terraform"
    }
  }
}


# -------------------------------------
# Sample EC2
# -------------------------------------
module "target" {
  source = "./modules/target"

  project            = var.project
  env                = var.env
  security_group_ids = var.security_group_ids
  subnet_id          = var.subnet_id
}

# -------------------------------------
# Sample Alart
# -------------------------------------
module "alarm" {
  source = "./modules/alarm"

  project         = var.project
  env             = var.env
  ec2_instance_id = module.target.ec2_instance_id
}
