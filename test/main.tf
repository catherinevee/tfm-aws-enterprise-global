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

module "test_enterprise_global" {
  source = "../"

  environment = "test"
  project_name = "test-module"

  # Minimal configuration for testing
  vpc_cidr_block = "10.1.0.0/16"
  public_subnet_cidrs = ["10.1.1.0/24"]
  private_subnet_cidrs = ["10.1.10.0/24"]
  availability_zones = ["us-east-1a"]

  # Enable only essential features for testing
  enable_alb = true
  enable_waf = false
  enable_cloudfront = false
  enable_shield_advanced = false
  enable_direct_connect = false
  enable_vpn = false
  enable_nat_gateway = false
  enable_alb_logs = false

  common_tags = {
    Environment = "test"
    Project     = "test-module"
    TestRun     = "true"
  }
}

# Test outputs
output "test_vpc_id" {
  description = "Test VPC ID"
  value       = module.test_enterprise_global.vpc_id
}

output "test_alb_dns_name" {
  description = "Test ALB DNS Name"
  value       = module.test_enterprise_global.alb_dns_name
}

output "test_network_summary" {
  description = "Test network configuration summary"
  value       = module.test_enterprise_global.network_summary
} 