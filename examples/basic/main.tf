terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "enterprise_global" {
  source = "../../"

  environment = "dev"
  project_name = "basic-example"

  # VPC Configuration
  vpc_cidr_block = "10.0.0.0/16"
  public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.10.0/24", "10.0.11.0/24"]
  availability_zones = ["us-east-1a", "us-east-1b"]

  # Enable basic features
  enable_alb = true
  enable_waf = true
  enable_cloudfront = false
  enable_shield_advanced = false
  enable_direct_connect = false
  enable_vpn = false

  # Disable expensive features for dev environment
  enable_nat_gateway = false
  enable_alb_logs = false

  common_tags = {
    Environment = "dev"
    Project     = "basic-example"
    Owner       = "DevOps Team"
    CostCenter  = "DEV-001"
  }
}

# Outputs
output "vpc_id" {
  description = "VPC ID"
  value       = module.enterprise_global.vpc_id
}

output "alb_dns_name" {
  description = "ALB DNS Name"
  value       = module.enterprise_global.alb_dns_name
}

output "network_summary" {
  description = "Network configuration summary"
  value       = module.enterprise_global.network_summary
} 