# AWS Enterprise Global Infrastructure - Customization Guide

This guide provides comprehensive documentation for customizing the AWS Enterprise Global Infrastructure Terraform module. Each section includes detailed explanations of variables, their default values, and practical examples.

## Table of Contents

1. [Basic Configuration](#basic-configuration)
2. [VPC Configuration](#vpc-configuration)
3. [Subnet Configuration](#subnet-configuration)
4. [NAT Gateway Configuration](#nat-gateway-configuration)
5. [Transit Gateway Configuration](#transit-gateway-configuration)
6. [Load Balancer Configuration](#load-balancer-configuration)
7. [Target Group Configuration](#target-group-configuration)
8. [CloudFront Configuration](#cloudfront-configuration)
9. [WAF Configuration](#waf-configuration)
10. [Security Group Configuration](#security-group-configuration)
11. [Shield Advanced Configuration](#shield-advanced-configuration)
12. [Monitoring and Logging Configuration](#monitoring-and-logging-configuration)
13. [Flow Logs Configuration](#flow-logs-configuration)
14. [VPC Endpoints Configuration](#vpc-endpoints-configuration)
15. [Direct Connect Configuration](#direct-connect-configuration)
16. [VPN Configuration](#vpn-configuration)
17. [Usage Examples](#usage-examples)
18. [Best Practices](#best-practices)
19. [Troubleshooting](#troubleshooting)

## Basic Configuration

### Environment and Project Settings

```hcl
# Basic Configuration Variables
environment = "prod"                    # Default: "dev" - Environment name for resource naming
project_name = "my-enterprise-app"      # Default: "my-project" - Project name for resource naming

# Common Tags
common_tags = {
  Environment = "prod"                  # Default: "dev" - Environment tag
  Project     = "my-enterprise-app"     # Default: "my-project" - Project tag
  Owner       = "DevOps Team"           # Default: "DevOps Team" - Owner tag
  CostCenter  = "IT-001"                # Default: "IT-001" - Cost center tag
  ManagedBy   = "Terraform"             # Additional tag for resource management
  Backup      = "true"                  # Additional tag for backup policies
}
```

**Best Practices:**
- Use consistent environment names across your organization
- Include cost allocation tags for billing purposes
- Add security and compliance tags as needed

## VPC Configuration

### Core VPC Settings

```hcl
# VPC Basic Configuration
vpc_cidr_block = "10.0.0.0/16"          # Default: "10.0.0.0/16" - VPC CIDR block
availability_zones = ["us-east-1a", "us-east-1b"]  # Default: ["us-east-1a", "us-east-1b"]

# VPC DNS Configuration
enable_dns_hostnames = true             # Default: true - Enable DNS hostnames for instances
enable_dns_support = true               # Default: true - Enable DNS support for the VPC

# IPv6 Configuration
assign_generated_ipv6_cidr_block = false  # Default: false - Assign IPv6 CIDR block
ipv6_cidr_block = null                  # Default: null - Custom IPv6 CIDR block
ipv6_cidr_block_network_border_group = null  # Default: null - Network border group for IPv6
```

**IPv6 Configuration Examples:**

```hcl
# Enable IPv6 with auto-assigned CIDR
assign_generated_ipv6_cidr_block = true

# Use custom IPv6 CIDR
ipv6_cidr_block = "2001:db8::/56"
ipv6_cidr_block_network_border_group = "us-east-1"
```

## Subnet Configuration

### Public and Private Subnet Settings

```hcl
# Subnet CIDR Configuration
public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]    # Default: ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.10.0/24", "10.0.11.0/24"] # Default: ["10.0.10.0/24", "10.0.11.0/24"]

# Public IP Configuration
public_subnet_map_public_ip_on_launch = true    # Default: true - Auto-assign public IPs to public subnets
private_subnet_map_public_ip_on_launch = false  # Default: false - Don't auto-assign public IPs to private subnets

# IPv6 Configuration for Subnets
public_subnet_assign_ipv6_address_on_creation = false   # Default: false - Auto-assign IPv6 addresses to public subnets
private_subnet_assign_ipv6_address_on_creation = false  # Default: false - Auto-assign IPv6 addresses to private subnets
public_subnet_ipv6_cidr_blocks = null          # Default: null - IPv6 CIDR blocks for public subnets
private_subnet_ipv6_cidr_blocks = null         # Default: null - IPv6 CIDR blocks for private subnets
```

**Advanced Subnet Configuration:**

```hcl
# Multi-AZ setup with larger subnets
public_subnet_cidrs = ["10.0.1.0/23", "10.0.3.0/23", "10.0.5.0/23"]
private_subnet_cidrs = ["10.0.10.0/23", "10.0.12.0/23", "10.0.14.0/23"]
availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]

# IPv6 enabled subnets
public_subnet_assign_ipv6_address_on_creation = true
private_subnet_assign_ipv6_address_on_creation = true
public_subnet_ipv6_cidr_blocks = ["2001:db8::/64", "2001:db8:1::/64"]
private_subnet_ipv6_cidr_blocks = ["2001:db8:10::/64", "2001:db8:11::/64"]
```

## NAT Gateway Configuration

### NAT Gateway Settings

```hcl
# NAT Gateway Configuration
enable_nat_gateway = true               # Default: true - Enable NAT Gateway for private subnets
nat_gateway_single_az_only = false      # Default: false - Create NAT Gateway in single AZ only
nat_gateway_connectivity_type = "public"  # Default: "public" - NAT Gateway connectivity type
```

**Cost Optimization Examples:**

```hcl
# Development environment - single NAT Gateway for cost savings
enable_nat_gateway = true
nat_gateway_single_az_only = true

# Production environment - NAT Gateway per AZ for high availability
enable_nat_gateway = true
nat_gateway_single_az_only = false

# Disable NAT Gateway for public-only workloads
enable_nat_gateway = false
```

## Transit Gateway Configuration

### Transit Gateway Settings

```hcl
# Transit Gateway Basic Configuration
transit_gateway_asn = 64512             # Default: 64512 - Amazon side ASN
transit_gateway_auto_accept_shared_attachments = "disable"  # Default: "disable" - Auto-accept shared attachments
transit_gateway_default_route_table_association = "enable"  # Default: "enable" - Enable default route table association
transit_gateway_default_route_table_propagation = "enable"  # Default: "enable" - Enable default route table propagation

# Transit Gateway Advanced Features
transit_gateway_dns_support = "enable"   # Default: "enable" - Enable DNS support
transit_gateway_vpn_ecmp_support = "enable"  # Default: "enable" - Enable VPN ECMP support
transit_gateway_multicast_support = "disable"  # Default: "disable" - Enable multicast support
```

**Transit Gateway Configuration Examples:**

```hcl
# Multi-account Transit Gateway
transit_gateway_asn = 65000
transit_gateway_auto_accept_shared_attachments = "enable"
transit_gateway_default_route_table_association = "enable"
transit_gateway_default_route_table_propagation = "enable"

# Transit Gateway with multicast support
transit_gateway_multicast_support = "enable"
```

## Load Balancer Configuration

### Application Load Balancer Settings

```hcl
# ALB Basic Configuration
enable_alb = true                       # Default: false - Enable Application Load Balancer
alb_name = null                         # Default: null - Custom ALB name (uses default naming if null)
alb_internal = false                    # Default: false - Internet-facing load balancer
alb_load_balancer_type = "application"  # Default: "application" - Load balancer type

# ALB Advanced Configuration
alb_enable_deletion_protection = false  # Default: false - Enable deletion protection
alb_enable_cross_zone_load_balancing = true  # Default: true - Enable cross-zone load balancing
alb_enable_http2 = true                 # Default: true - Enable HTTP/2
alb_idle_timeout = 60                   # Default: 60 - Idle timeout in seconds
```

**ALB Configuration Examples:**

```hcl
# Internal ALB for private applications
enable_alb = true
alb_internal = true
alb_name = "internal-app-alb"

# Production ALB with deletion protection
enable_alb = true
alb_enable_deletion_protection = true
alb_idle_timeout = 120

# ALB with custom name and HTTP/2 disabled
enable_alb = true
alb_name = "my-custom-alb"
alb_enable_http2 = false
```

## Target Group Configuration

### Target Group Settings

```hcl
# Target Group Basic Configuration
target_group_port = 80                  # Default: 80 - Target port
target_group_protocol = "HTTP"          # Default: "HTTP" - Target protocol

# Health Check Configuration
target_group_health_check_enabled = true  # Default: true - Enable health checks
target_group_health_check_interval = 30   # Default: 30 - Health check interval in seconds
target_group_health_check_path = "/health"  # Default: "/health" - Health check path
target_group_health_check_protocol = "HTTP"  # Default: "HTTP" - Health check protocol
target_group_health_check_timeout = 5    # Default: 5 - Health check timeout in seconds
target_group_healthy_threshold = 2       # Default: 2 - Healthy threshold count
target_group_unhealthy_threshold = 2     # Default: 2 - Unhealthy threshold count
target_group_health_check_matcher = "200"  # Default: "200" - Health check matcher
```

**Target Group Configuration Examples:**

```hcl
# HTTPS target group
target_group_port = 443
target_group_protocol = "HTTPS"
target_group_health_check_protocol = "HTTPS"
target_group_health_check_path = "/api/health"

# Custom health check configuration
target_group_health_check_interval = 15
target_group_health_check_timeout = 10
target_group_healthy_threshold = 3
target_group_unhealthy_threshold = 3
target_group_health_check_matcher = "200,302"
```

## CloudFront Configuration

### CloudFront Distribution Settings

```hcl
# CloudFront Basic Configuration
enable_cloudfront = true                # Default: false - Enable CloudFront distribution
cloudfront_price_class = "PriceClass_100"  # Default: "PriceClass_100" - Price class for edge locations
origin_domain_name = null               # Default: null - Origin domain name (uses ALB if null)
cloudfront_origin_id = "ALB-Origin"     # Default: "ALB-Origin" - Origin identifier

# CloudFront Origin Configuration
cloudfront_origin_protocol_policy = "http-only"  # Default: "http-only" - Origin protocol policy
cloudfront_origin_ssl_protocols = ["TLSv1.2"]  # Default: ["TLSv1.2"] - SSL protocols
cloudfront_origin_http_port = 80        # Default: 80 - HTTP port
cloudfront_origin_https_port = 443      # Default: 443 - HTTPS port

# CloudFront Distribution Settings
cloudfront_enabled = true               # Default: true - Enable the distribution
cloudfront_is_ipv6_enabled = true       # Default: true - Enable IPv6 support
cloudfront_default_root_object = "index.html"  # Default: "index.html" - Default root object
```

**CloudFront Configuration Examples:**

```hcl
# Global distribution with custom origin
enable_cloudfront = true
cloudfront_price_class = "PriceClass_All"
origin_domain_name = "my-custom-origin.example.com"
cloudfront_origin_id = "CustomOrigin"

# CloudFront with HTTPS origin
cloudfront_origin_protocol_policy = "https-only"
cloudfront_origin_ssl_protocols = ["TLSv1.2", "TLSv1.3"]

# CloudFront with custom default object
cloudfront_default_root_object = "app.html"
```

## WAF Configuration

### WAF Web ACL Settings

```hcl
# WAF Basic Configuration
enable_waf = true                       # Default: false - Enable WAF Web ACL
waf_web_acl_name = null                 # Default: null - Custom WAF Web ACL name
waf_web_acl_scope = "REGIONAL"          # Default: "REGIONAL" - WAF scope (REGIONAL or CLOUDFRONT)
```

**WAF Configuration Examples:**

```hcl
# Regional WAF for ALB
enable_waf = true
waf_web_acl_name = "my-regional-waf"
waf_web_acl_scope = "REGIONAL"

# CloudFront WAF
enable_waf = true
waf_web_acl_name = "my-cloudfront-waf"
waf_web_acl_scope = "CLOUDFRONT"
```

## Security Group Configuration

### Security Group Settings

```hcl
# ALB Security Group Configuration
alb_security_group_name = null          # Default: null - Custom ALB security group name
alb_security_group_description = null   # Default: null - Custom ALB security group description

# App Security Group Configuration
app_security_group_name = null          # Default: null - Custom app security group name
app_security_group_description = null   # Default: null - Custom app security group description
```

**Security Group Configuration Examples:**

```hcl
# Custom security group names
alb_security_group_name = "my-alb-sg"
alb_security_group_description = "Security group for my application load balancer"
app_security_group_name = "my-app-sg"
app_security_group_description = "Security group for my application servers"
```

## Shield Advanced Configuration

### Shield Advanced Settings

```hcl
# Shield Advanced Configuration
enable_shield_advanced = true           # Default: false - Enable Shield Advanced protection
shield_protection_name_alb = null       # Default: null - Custom Shield protection name for ALB
shield_protection_name_cloudfront = null  # Default: null - Custom Shield protection name for CloudFront
```

**Shield Advanced Configuration Examples:**

```hcl
# Shield Advanced for production workloads
enable_shield_advanced = true
shield_protection_name_alb = "prod-alb-shield"
shield_protection_name_cloudfront = "prod-cloudfront-shield"
```

## Monitoring and Logging Configuration

### CloudWatch and S3 Logging Settings

```hcl
# CloudWatch Configuration
log_retention_days = 30                 # Default: 30 - Log retention period in days
cloudwatch_log_group_name = null        # Default: null - Custom CloudWatch log group name

# ALB Logging Configuration
enable_alb_logs = true                  # Default: false - Enable ALB access logs
alb_logs_bucket_name = null             # Default: null - Custom ALB logs bucket name
alb_logs_bucket_prefix = "alb-logs"     # Default: "alb-logs" - ALB logs bucket prefix
alb_logs_bucket_versioning = "Enabled"  # Default: "Enabled" - Bucket versioning status
alb_logs_bucket_encryption = "AES256"   # Default: "AES256" - Server-side encryption algorithm
```

**Monitoring Configuration Examples:**

```hcl
# Extended log retention for compliance
log_retention_days = 90
cloudwatch_log_group_name = "/aws/prod/my-app-logs"

# ALB logging with custom bucket
enable_alb_logs = true
alb_logs_bucket_name = "my-custom-alb-logs-bucket"
alb_logs_bucket_prefix = "my-app/alb-logs"
```

## Flow Logs Configuration

### VPC Flow Logs Settings

```hcl
# Flow Logs Configuration
enable_flow_logs = true                 # Default: false - Enable VPC flow logs
flow_logs_iam_role_arn = null           # Default: null - IAM role ARN for flow logs
flow_logs_log_destination = null        # Default: null - Log destination for flow logs
flow_logs_log_destination_type = "cloud-watch-logs"  # Default: "cloud-watch-logs" - Log destination type
flow_logs_traffic_type = "ALL"          # Default: "ALL" - Traffic type for flow logs
flow_logs_max_aggregation_interval = 600  # Default: 600 - Max aggregation interval for flow logs
```

**Flow Logs Configuration Examples:**

```hcl
# Flow logs to CloudWatch
enable_flow_logs = true
flow_logs_log_destination_type = "cloud-watch-logs"
flow_logs_traffic_type = "ALL"

# Flow logs to S3
enable_flow_logs = true
flow_logs_log_destination = "arn:aws:s3:::my-flow-logs-bucket"
flow_logs_log_destination_type = "s3"
flow_logs_max_aggregation_interval = 60
```

## VPC Endpoints Configuration

### VPC Endpoints Settings

```hcl
# VPC Endpoints Configuration
enable_vpc_endpoints = true             # Default: false - Enable VPC endpoints
vpc_endpoints = []                      # Default: [] - VPC endpoint configurations
```

**VPC Endpoints Configuration Examples:**

```hcl
# Common VPC endpoints
enable_vpc_endpoints = true
vpc_endpoints = [
  {
    service_name = "com.amazonaws.us-east-1.s3"
    vpc_endpoint_type = "Gateway"
    route_table_ids = ["rtb-12345678"]
  },
  {
    service_name = "com.amazonaws.us-east-1.dynamodb"
    vpc_endpoint_type = "Gateway"
    route_table_ids = ["rtb-12345678"]
  },
  {
    service_name = "com.amazonaws.us-east-1.secretsmanager"
    vpc_endpoint_type = "Interface"
    subnet_ids = ["subnet-12345678", "subnet-87654321"]
    security_group_ids = ["sg-12345678"]
  }
]
```

## Direct Connect Configuration

### Direct Connect Settings

```hcl
# Direct Connect Configuration
enable_direct_connect = true            # Default: false - Enable Direct Connect
direct_connect_allowed_prefixes = ["10.0.0.0/16", "192.168.0.0/16"]  # Default: [] - Allowed prefixes
```

**Direct Connect Configuration Examples:**

```hcl
# Direct Connect with multiple prefixes
enable_direct_connect = true
direct_connect_allowed_prefixes = [
  "10.0.0.0/16",
  "10.1.0.0/16",
  "192.168.0.0/16",
  "172.16.0.0/12"
]
```

## VPN Configuration

### VPN Connection Settings

```hcl
# VPN Configuration
enable_vpn = true                       # Default: false - Enable VPN connections
vpn_connections = [                     # Default: [] - VPN connection configurations
  {
    customer_ip         = "203.0.113.1"
    bgp_asn            = 65000
    destination_cidr   = "192.168.0.0/16"
    static_routes_only = true
  }
]
```

**VPN Configuration Examples:**

```hcl
# Multiple VPN connections
enable_vpn = true
vpn_connections = [
  {
    customer_ip         = "203.0.113.1"
    bgp_asn            = 65000
    destination_cidr   = "192.168.0.0/16"
    static_routes_only = true
  },
  {
    customer_ip         = "203.0.113.2"
    bgp_asn            = 65001
    destination_cidr   = "192.168.1.0/24"
    static_routes_only = false
  }
]
```

## Usage Examples

### Minimal Configuration

```hcl
module "enterprise_global" {
  source = "./tfm-aws-enterprise-global"

  environment = "dev"
  project_name = "minimal-example"

  # Basic VPC configuration
  vpc_cidr_block = "10.0.0.0/16"
  public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.10.0/24", "10.0.11.0/24"]
  availability_zones = ["us-east-1a", "us-east-1b"]

  # Enable only essential features
  enable_alb = true
  enable_waf = true

  # Disable expensive features
  enable_nat_gateway = false
  enable_cloudfront = false
  enable_shield_advanced = false
  enable_direct_connect = false
  enable_vpn = false
  enable_alb_logs = false

  common_tags = {
    Environment = "dev"
    Project     = "minimal-example"
    Owner       = "DevOps Team"
  }
}
```

### Production Configuration

```hcl
module "enterprise_global" {
  source = "./tfm-aws-enterprise-global"

  environment = "prod"
  project_name = "production-app"

  # VPC Configuration
  vpc_cidr_block = "10.0.0.0/16"
  public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnet_cidrs = ["10.0.10.0/24", "10.0.11.0/24", "10.0.12.0/24"]
  availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]

  # Enable all features
  enable_alb = true
  enable_cloudfront = true
  enable_waf = true
  enable_shield_advanced = true
  enable_direct_connect = true
  enable_vpn = true
  enable_alb_logs = true
  enable_flow_logs = true
  enable_vpc_endpoints = true

  # Production ALB settings
  alb_enable_deletion_protection = true
  alb_idle_timeout = 120

  # Production logging
  log_retention_days = 90
  alb_logs_bucket_prefix = "prod/alb-logs"

  # VPN Configuration
  vpn_connections = [
    {
      customer_ip         = "203.0.113.1"
      bgp_asn            = 65000
      destination_cidr   = "192.168.0.0/16"
      static_routes_only = true
    }
  ]

  # Direct Connect Configuration
  direct_connect_allowed_prefixes = ["10.0.0.0/16", "192.168.0.0/16"]

  # VPC Endpoints
  vpc_endpoints = [
    {
      service_name = "com.amazonaws.us-east-1.s3"
      vpc_endpoint_type = "Gateway"
    },
    {
      service_name = "com.amazonaws.us-east-1.secretsmanager"
      vpc_endpoint_type = "Interface"
    }
  ]

  common_tags = {
    Environment = "prod"
    Project     = "production-app"
    Owner       = "DevOps Team"
    CostCenter  = "IT-001"
    Backup      = "true"
    Compliance  = "SOX"
  }
}
```

## Best Practices

### Security Best Practices

1. **Enable WAF for all public-facing resources**
2. **Use Shield Advanced for critical applications**
3. **Implement least-privilege security group rules**
4. **Enable VPC Flow Logs for network monitoring**
5. **Use VPC endpoints for AWS service access**

### Cost Optimization Best Practices

1. **Use single NAT Gateway for development environments**
2. **Disable expensive features in non-production environments**
3. **Configure appropriate log retention periods**
4. **Use CloudFront price classes based on your global reach**
5. **Monitor and optimize ALB idle timeouts**

### Performance Best Practices

1. **Use multiple availability zones for high availability**
2. **Configure appropriate health check intervals**
3. **Enable cross-zone load balancing**
4. **Use HTTP/2 for better performance**
5. **Configure appropriate CloudFront TTL settings**

### Operational Best Practices

1. **Use consistent naming conventions**
2. **Implement comprehensive tagging strategy**
3. **Enable deletion protection for production resources**
4. **Configure monitoring and alerting**
5. **Document all custom configurations**

## Troubleshooting

### Common Issues and Solutions

#### NAT Gateway Issues
- **Issue**: High costs in development environments
- **Solution**: Use `nat_gateway_single_az_only = true` or disable NAT Gateway entirely

#### Security Group Issues
- **Issue**: Application connectivity problems
- **Solution**: Verify security group rules and ensure proper port configurations

#### CloudFront Issues
- **Issue**: Content not updating
- **Solution**: Check CloudFront cache settings and invalidate cache if needed

#### WAF Issues
- **Issue**: Legitimate traffic being blocked
- **Solution**: Review WAF rules and adjust rate limiting thresholds

#### VPN Issues
- **Issue**: VPN connection failures
- **Solution**: Verify BGP ASN configuration and route table settings

### Debugging Tips

1. **Check Terraform plan output** for configuration issues
2. **Review CloudWatch logs** for application-level issues
3. **Use VPC Flow Logs** for network connectivity troubleshooting
4. **Monitor WAF metrics** for security-related issues
5. **Check ALB target group health** for load balancer issues

### Support Resources

- [AWS VPC Documentation](https://docs.aws.amazon.com/vpc/)
- [AWS Transit Gateway Documentation](https://docs.aws.amazon.com/vpc/latest/tgw/)
- [AWS CloudFront Documentation](https://docs.aws.amazon.com/cloudfront/)
- [AWS WAF Documentation](https://docs.aws.amazon.com/waf/)
- [Terraform AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs) 