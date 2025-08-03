terraform {
  required_version = "1.13.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.2.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "enterprise_global" {
  source = "../../"

  # Basic Configuration
  environment = "dev"  # Default: dev - Environment name for resource naming
  project_name = "basic-example"  # Default: my-project - Project name for resource naming

  # VPC Configuration
  vpc_cidr_block = "10.0.0.0/16"  # Default: 10.0.0.0/16 - VPC CIDR block
  public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]  # Default: ["10.0.1.0/24", "10.0.2.0/24"] - Public subnet CIDRs
  private_subnet_cidrs = ["10.0.10.0/24", "10.0.11.0/24"]  # Default: ["10.0.10.0/24", "10.0.11.0/24"] - Private subnet CIDRs
  availability_zones = ["us-east-1a", "us-east-1b"]  # Default: ["us-east-1a", "us-east-1b"] - Availability zones

  # VPC Advanced Configuration
  enable_dns_hostnames = true  # Default: true - Enable DNS hostnames for instances
  enable_dns_support = true  # Default: true - Enable DNS support for the VPC
  assign_generated_ipv6_cidr_block = false  # Default: false - Assign IPv6 CIDR block
  ipv6_cidr_block = null  # Default: null - Custom IPv6 CIDR block
  ipv6_cidr_block_network_border_group = null  # Default: null - Network border group for IPv6

  # Subnet Configuration
  public_subnet_map_public_ip_on_launch = true  # Default: true - Auto-assign public IPs to public subnets
  private_subnet_map_public_ip_on_launch = false  # Default: false - Don't auto-assign public IPs to private subnets
  public_subnet_assign_ipv6_address_on_creation = false  # Default: false - Auto-assign IPv6 addresses to public subnets
  private_subnet_assign_ipv6_address_on_creation = false  # Default: false - Auto-assign IPv6 addresses to private subnets
  public_subnet_ipv6_cidr_blocks = null  # Default: null - IPv6 CIDR blocks for public subnets
  private_subnet_ipv6_cidr_blocks = null  # Default: null - IPv6 CIDR blocks for private subnets

  # NAT Gateway Configuration
  enable_nat_gateway = false  # Default: true - Enable NAT Gateway for private subnets (disabled for cost optimization in dev)
  nat_gateway_single_az_only = false  # Default: false - Create NAT Gateway in single AZ only
  nat_gateway_connectivity_type = "public"  # Default: public - NAT Gateway connectivity type

  # Transit Gateway Configuration
  transit_gateway_asn = 64512  # Default: 64512 - Amazon side ASN
  transit_gateway_auto_accept_shared_attachments = "disable"  # Default: disable - Auto-accept shared attachments
  transit_gateway_default_route_table_association = "enable"  # Default: enable - Enable default route table association
  transit_gateway_default_route_table_propagation = "enable"  # Default: enable - Enable default route table propagation
  transit_gateway_dns_support = "enable"  # Default: enable - Enable DNS support
  transit_gateway_vpn_ecmp_support = "enable"  # Default: enable - Enable VPN ECMP support
  transit_gateway_multicast_support = "disable"  # Default: disable - Enable multicast support

  # Direct Connect Configuration
  enable_direct_connect = false  # Default: false - Enable Direct Connect (disabled for basic example)
  direct_connect_allowed_prefixes = []  # Default: [] - Allowed prefixes for Direct Connect

  # VPN Configuration
  enable_vpn = false  # Default: false - Enable VPN connections (disabled for basic example)
  vpn_connections = []  # Default: [] - VPN connection configurations

  # Load Balancer Configuration
  enable_alb = true  # Default: false - Enable Application Load Balancer
  alb_name = null  # Default: null - Custom ALB name (uses default naming if null)
  alb_internal = false  # Default: false - Internet-facing load balancer
  alb_load_balancer_type = "application"  # Default: application - Load balancer type
  alb_enable_deletion_protection = false  # Default: false - Enable deletion protection
  alb_enable_cross_zone_load_balancing = true  # Default: true - Enable cross-zone load balancing
  alb_enable_http2 = true  # Default: true - Enable HTTP/2
  alb_idle_timeout = 60  # Default: 60 - Idle timeout in seconds

  # Target Group Configuration
  target_group_port = 80  # Default: 80 - Target port
  target_group_protocol = "HTTP"  # Default: HTTP - Target protocol
  target_group_health_check_enabled = true  # Default: true - Enable health checks
  target_group_health_check_interval = 30  # Default: 30 - Health check interval in seconds
  target_group_health_check_path = "/health"  # Default: /health - Health check path
  target_group_health_check_protocol = "HTTP"  # Default: HTTP - Health check protocol
  target_group_health_check_timeout = 5  # Default: 5 - Health check timeout in seconds
  target_group_healthy_threshold = 2  # Default: 2 - Healthy threshold count
  target_group_unhealthy_threshold = 2  # Default: 2 - Unhealthy threshold count
  target_group_health_check_matcher = "200"  # Default: 200 - Health check matcher

  # CloudFront Configuration
  enable_cloudfront = false  # Default: false - Enable CloudFront distribution (disabled for basic example)
  cloudfront_price_class = "PriceClass_100"  # Default: PriceClass_100 - Price class for edge locations
  origin_domain_name = null  # Default: null - Origin domain name (uses ALB if null)
  cloudfront_origin_id = "ALB-Origin"  # Default: ALB-Origin - Origin identifier
  cloudfront_origin_protocol_policy = "http-only"  # Default: http-only - Origin protocol policy
  cloudfront_origin_ssl_protocols = ["TLSv1.2"]  # Default: ["TLSv1.2"] - SSL protocols
  cloudfront_origin_http_port = 80  # Default: 80 - HTTP port
  cloudfront_origin_https_port = 443  # Default: 443 - HTTPS port
  cloudfront_enabled = true  # Default: true - Enable the distribution
  cloudfront_is_ipv6_enabled = true  # Default: true - Enable IPv6 support
  cloudfront_default_root_object = "index.html"  # Default: index.html - Default root object

  # WAF Configuration
  enable_waf = true  # Default: false - Enable WAF Web ACL
  waf_web_acl_name = null  # Default: null - Custom WAF Web ACL name (uses default naming if null)
  waf_web_acl_scope = "REGIONAL"  # Default: REGIONAL - WAF scope (REGIONAL or CLOUDFRONT)

  # Security Group Configuration
  alb_security_group_name = null  # Default: null - Custom ALB security group name (uses default naming if null)
  alb_security_group_description = null  # Default: null - Custom ALB security group description (uses default if null)
  app_security_group_name = null  # Default: null - Custom app security group name (uses default naming if null)
  app_security_group_description = null  # Default: null - Custom app security group description (uses default if null)

  # Shield Advanced Configuration
  enable_shield_advanced = false  # Default: false - Enable Shield Advanced protection (disabled for basic example)
  shield_protection_name_alb = null  # Default: null - Custom Shield protection name for ALB (uses default naming if null)
  shield_protection_name_cloudfront = null  # Default: null - Custom Shield protection name for CloudFront (uses default naming if null)

  # Monitoring and Logging Configuration
  log_retention_days = 30  # Default: 30 - Log retention period in days
  cloudwatch_log_group_name = null  # Default: null - Custom CloudWatch log group name (uses default naming if null)
  enable_alb_logs = false  # Default: false - Enable ALB access logs (disabled for cost optimization in dev)
  alb_logs_bucket_name = null  # Default: null - Custom ALB logs bucket name (uses default naming if null)
  alb_logs_bucket_prefix = "alb-logs"  # Default: alb-logs - ALB logs bucket prefix
  alb_logs_bucket_versioning = "Enabled"  # Default: Enabled - Bucket versioning status
  alb_logs_bucket_encryption = "AES256"  # Default: AES256 - Server-side encryption algorithm

  # Flow Logs Configuration
  enable_flow_logs = false  # Default: false - Enable VPC flow logs (disabled for basic example)
  flow_logs_iam_role_arn = null  # Default: null - IAM role ARN for flow logs
  flow_logs_log_destination = null  # Default: null - Log destination for flow logs
  flow_logs_log_destination_type = "cloud-watch-logs"  # Default: cloud-watch-logs - Log destination type
  flow_logs_traffic_type = "ALL"  # Default: ALL - Traffic type for flow logs
  flow_logs_max_aggregation_interval = 600  # Default: 600 - Max aggregation interval for flow logs

  # VPC Endpoints Configuration
  enable_vpc_endpoints = false  # Default: false - Enable VPC endpoints (disabled for basic example)
  vpc_endpoints = []  # Default: [] - VPC endpoint configurations

  # Common Tags
  common_tags = {
    Environment = "dev"  # Default: dev - Environment tag
    Project     = "basic-example"  # Default: my-project - Project tag
    Owner       = "DevOps Team"  # Default: DevOps Team - Owner tag
    CostCenter  = "DEV-001"  # Default: IT-001 - Cost center tag
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