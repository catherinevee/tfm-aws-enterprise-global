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

  environment = "prod"
  project_name = "advanced-example"

  # VPC Configuration
  vpc_cidr_block = "172.16.0.0/16"
  public_subnet_cidrs = ["172.16.1.0/24", "172.16.2.0/24", "172.16.3.0/24"]
  private_subnet_cidrs = ["172.16.10.0/24", "172.16.11.0/24", "172.16.12.0/24"]
  availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]

  # Transit Gateway Configuration
  transit_gateway_asn = 64512

  # Load Balancer Configuration
  enable_alb = true
  enable_deletion_protection = true
  enable_alb_logs = true

  # CloudFront Configuration
  enable_cloudfront = true
  cloudfront_price_class = "PriceClass_200"

  # Security Configuration
  enable_waf = true
  enable_shield_advanced = true

  # Hybrid Connectivity
  enable_direct_connect = true
  direct_connect_allowed_prefixes = [
    "172.16.0.0/16",
    "192.168.0.0/16",
    "10.0.0.0/8"
  ]

  enable_vpn = true
  vpn_connections = [
    {
      customer_ip         = "203.0.113.1"
      bgp_asn            = 65000
      destination_cidr   = "192.168.0.0/16"
      static_routes_only = false
    },
    {
      customer_ip         = "203.0.113.2"
      bgp_asn            = 65001
      destination_cidr   = "10.0.0.0/8"
      static_routes_only = true
    }
  ]

  # Logging Configuration
  log_retention_days = 90

  common_tags = {
    Environment = "prod"
    Project     = "advanced-example"
    Owner       = "Infrastructure Team"
    CostCenter  = "PROD-001"
    DataClassification = "Internal"
    Backup = "true"
  }
}

# Outputs
output "vpc_id" {
  description = "VPC ID"
  value       = module.enterprise_global.vpc_id
}

output "transit_gateway_id" {
  description = "Transit Gateway ID"
  value       = module.enterprise_global.transit_gateway_id
}

output "alb_dns_name" {
  description = "ALB DNS Name"
  value       = module.enterprise_global.alb_dns_name
}

output "cloudfront_domain_name" {
  description = "CloudFront Domain Name"
  value       = module.enterprise_global.cloudfront_domain_name
}

output "waf_web_acl_arn" {
  description = "WAF Web ACL ARN"
  value       = module.enterprise_global.waf_web_acl_arn
}

output "direct_connect_gateway_id" {
  description = "Direct Connect Gateway ID"
  value       = module.enterprise_global.direct_connect_gateway_id
}

output "vpn_connection_ids" {
  description = "VPN Connection IDs"
  value       = module.enterprise_global.vpn_connection_ids
}

output "network_summary" {
  description = "Network configuration summary"
  value       = module.enterprise_global.network_summary
} 