# AWS Enterprise Global Infrastructure Terraform Module

A comprehensive Terraform module for deploying enterprise-grade AWS infrastructure with Direct Connect + VPN backup, multi-account Transit Gateway architecture, CloudFront global distributions, and network security with WAF + Shield.

## 🏗️ Architecture Overview

This module provides a complete enterprise infrastructure solution including:

- **Networking**: VPC with public/private subnets, NAT Gateway, and Transit Gateway
- **Connectivity**: Direct Connect with VPN backup for hybrid connectivity
- **Load Balancing**: Application Load Balancer with health checks
- **Global Distribution**: CloudFront CDN for global content delivery
- **Security**: WAF v2 with managed rules and Shield Advanced protection
- **Monitoring**: CloudWatch logging and S3 access logs
- **Multi-Account**: Transit Gateway for connecting multiple AWS accounts

## 🚀 Features

### Core Infrastructure
- ✅ VPC with configurable CIDR blocks and IPv6 support
- ✅ Public and private subnets across multiple AZs with customizable settings
- ✅ Internet Gateway and NAT Gateway with configurable options
- ✅ Route tables with proper routing and customizable configurations

### Hybrid Connectivity
- ✅ Transit Gateway for multi-account connectivity with full customization
- ✅ Direct Connect Gateway with configurable prefixes and settings
- ✅ VPN connections with BGP support and customizable configurations
- ✅ Static and dynamic routing options

### Application Delivery
- ✅ Application Load Balancer with comprehensive health check settings
- ✅ Target groups with fully configurable health check parameters
- ✅ CloudFront distribution with custom origins and caching behaviors
- ✅ Global content delivery optimization

### Security & Protection
- ✅ WAF v2 Web ACL with AWS managed rules and custom configurations
- ✅ Rate limiting and IP-based blocking with customizable thresholds
- ✅ Shield Advanced protection for ALB and CloudFront
- ✅ Security groups with least-privilege access and customizable rules
- ✅ S3 bucket encryption and access controls

### Monitoring & Logging
- ✅ CloudWatch log groups with configurable retention and naming
- ✅ ALB access logs stored in S3 with customizable settings
- ✅ VPC Flow Logs with configurable destinations and intervals
- ✅ Comprehensive resource tagging
- ✅ Network summary outputs

## 📋 Prerequisites

- Terraform >= 1.13.0
- AWS Provider >= 6.2.0
- AWS CLI configured with appropriate permissions
- For Shield Advanced: AWS Shield Advanced subscription
- For Direct Connect: Direct Connect connection established

## 📊 Resource Map

For a comprehensive overview of all AWS resources created by this module, including dependencies, cost estimates, and scaling considerations, see the [Resource Map](RESOURCE_MAP.md).

## 🔧 Usage

### Basic Usage

```hcl
module "enterprise_global" {
  source = "./tfm-aws-enterprise-global"

  environment = "prod"
  project_name = "my-enterprise-app"

  # VPC Configuration
  vpc_cidr_block = "10.0.0.0/16"
  public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.10.0/24", "10.0.11.0/24"]
  availability_zones = ["us-east-1a", "us-east-1b"]

  # Enable all features
  enable_alb = true
  enable_cloudfront = true
  enable_waf = true
  enable_shield_advanced = true
  enable_direct_connect = true
  enable_vpn = true

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

  common_tags = {
    Environment = "prod"
    Project     = "my-enterprise-app"
    Owner       = "DevOps Team"
    CostCenter  = "IT-001"
  }
}
```

### Advanced Configuration

This module provides extensive customization options for all resources. Here are some key configuration areas:

#### VPC Configuration
```hcl
# VPC Advanced Settings
enable_dns_hostnames = true                    # Enable DNS hostnames for instances
enable_dns_support = true                      # Enable DNS support for the VPC
assign_generated_ipv6_cidr_block = false       # Assign IPv6 CIDR block
ipv6_cidr_block = null                        # Custom IPv6 CIDR block
ipv6_cidr_block_network_border_group = null   # Network border group for IPv6
```

#### Subnet Configuration
```hcl
# Subnet Settings
public_subnet_map_public_ip_on_launch = true   # Auto-assign public IPs to public subnets
private_subnet_map_public_ip_on_launch = false # Don't auto-assign public IPs to private subnets
public_subnet_assign_ipv6_address_on_creation = false  # Auto-assign IPv6 addresses
private_subnet_assign_ipv6_address_on_creation = false # Auto-assign IPv6 addresses
public_subnet_ipv6_cidr_blocks = null         # IPv6 CIDR blocks for public subnets
private_subnet_ipv6_cidr_blocks = null        # IPv6 CIDR blocks for private subnets
```

#### NAT Gateway Configuration
```hcl
# NAT Gateway Settings
enable_nat_gateway = true                      # Enable NAT Gateway for private subnets
nat_gateway_single_az_only = false            # Create NAT Gateway in single AZ only
nat_gateway_connectivity_type = "public"       # NAT Gateway connectivity type
```

#### Transit Gateway Configuration
```hcl
# Transit Gateway Settings
transit_gateway_asn = 64512                    # Amazon side ASN
transit_gateway_auto_accept_shared_attachments = "disable"  # Auto-accept shared attachments
transit_gateway_default_route_table_association = "enable"  # Enable default route table association
transit_gateway_default_route_table_propagation = "enable"  # Enable default route table propagation
transit_gateway_dns_support = "enable"         # Enable DNS support
transit_gateway_vpn_ecmp_support = "enable"    # Enable VPN ECMP support
transit_gateway_multicast_support = "disable"  # Enable multicast support
```

#### Load Balancer Configuration
```hcl
# ALB Settings
enable_alb = true                              # Enable Application Load Balancer
alb_name = null                                # Custom ALB name
alb_internal = false                           # Internet-facing load balancer
alb_load_balancer_type = "application"         # Load balancer type
alb_enable_deletion_protection = false         # Enable deletion protection
alb_enable_cross_zone_load_balancing = true    # Enable cross-zone load balancing
alb_enable_http2 = true                        # Enable HTTP/2
alb_idle_timeout = 60                          # Idle timeout in seconds
```

#### Target Group Configuration
```hcl
# Target Group Settings
target_group_port = 80                         # Target port
target_group_protocol = "HTTP"                 # Target protocol
target_group_health_check_enabled = true       # Enable health checks
target_group_health_check_interval = 30        # Health check interval in seconds
target_group_health_check_path = "/health"     # Health check path
target_group_health_check_protocol = "HTTP"    # Health check protocol
target_group_health_check_timeout = 5          # Health check timeout in seconds
target_group_healthy_threshold = 2             # Healthy threshold count
target_group_unhealthy_threshold = 2           # Unhealthy threshold count
target_group_health_check_matcher = "200"      # Health check matcher
```

#### CloudFront Configuration
```hcl
# CloudFront Settings
enable_cloudfront = true                       # Enable CloudFront distribution
cloudfront_price_class = "PriceClass_100"      # Price class for edge locations
origin_domain_name = null                      # Origin domain name
cloudfront_origin_id = "ALB-Origin"            # Origin identifier
cloudfront_origin_protocol_policy = "http-only" # Origin protocol policy
cloudfront_origin_ssl_protocols = ["TLSv1.2"]  # SSL protocols
cloudfront_origin_http_port = 80               # HTTP port
cloudfront_origin_https_port = 443             # HTTPS port
cloudfront_enabled = true                      # Enable the distribution
cloudfront_is_ipv6_enabled = true              # Enable IPv6 support
cloudfront_default_root_object = "index.html"  # Default root object
```

#### WAF Configuration
```hcl
# WAF Settings
enable_waf = true                              # Enable WAF Web ACL
waf_web_acl_name = null                        # Custom WAF Web ACL name
waf_web_acl_scope = "REGIONAL"                 # WAF scope (REGIONAL or CLOUDFRONT)
```

#### Security Group Configuration
```hcl
# Security Group Settings
alb_security_group_name = null                 # Custom ALB security group name
alb_security_group_description = null          # Custom ALB security group description
app_security_group_name = null                 # Custom app security group name
app_security_group_description = null          # Custom app security group description
```

#### Shield Advanced Configuration
```hcl
# Shield Advanced Settings
enable_shield_advanced = true                  # Enable Shield Advanced protection
shield_protection_name_alb = null              # Custom Shield protection name for ALB
shield_protection_name_cloudfront = null       # Custom Shield protection name for CloudFront
```

#### Monitoring and Logging Configuration
```hcl
# Monitoring Settings
log_retention_days = 30                        # Log retention period in days
cloudwatch_log_group_name = null               # Custom CloudWatch log group name
enable_alb_logs = true                         # Enable ALB access logs
alb_logs_bucket_name = null                    # Custom ALB logs bucket name
alb_logs_bucket_prefix = "alb-logs"            # ALB logs bucket prefix
alb_logs_bucket_versioning = "Enabled"         # Bucket versioning status
alb_logs_bucket_encryption = "AES256"          # Server-side encryption algorithm
```

#### Flow Logs Configuration
```hcl
# Flow Logs Settings
enable_flow_logs = true                        # Enable VPC flow logs
flow_logs_iam_role_arn = null                  # IAM role ARN for flow logs
flow_logs_log_destination = null               # Log destination for flow logs
flow_logs_log_destination_type = "cloud-watch-logs"  # Log destination type
flow_logs_traffic_type = "ALL"                 # Traffic type for flow logs
flow_logs_max_aggregation_interval = 600       # Max aggregation interval for flow logs
```

#### VPC Endpoints Configuration
```hcl
# VPC Endpoints Settings
enable_vpc_endpoints = true                    # Enable VPC endpoints
vpc_endpoints = []                             # VPC endpoint configurations
```

## 📖 Inputs

### Basic Configuration
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| environment | Environment name for resource naming | `string` | `"dev"` | no |
| project_name | Project name for resource naming | `string` | `"my-project"` | no |
| common_tags | Common tags to apply to all resources | `map(string)` | `{}` | no |

### VPC Configuration
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| vpc_cidr_block | CIDR block for the VPC | `string` | `"10.0.0.0/16"` | no |
| public_subnet_cidrs | CIDR blocks for public subnets | `list(string)` | `["10.0.1.0/24", "10.0.2.0/24"]` | no |
| private_subnet_cidrs | CIDR blocks for private subnets | `list(string)` | `["10.0.10.0/24", "10.0.11.0/24"]` | no |
| availability_zones | Availability zones for subnets | `list(string)` | `["us-east-1a", "us-east-1b"]` | no |
| enable_dns_hostnames | Enable DNS hostnames in the VPC | `bool` | `true` | no |
| enable_dns_support | Enable DNS support in the VPC | `bool` | `true` | no |
| assign_generated_ipv6_cidr_block | Assign generated IPv6 CIDR block to the VPC | `bool` | `false` | no |
| ipv6_cidr_block | IPv6 CIDR block for the VPC | `string` | `null` | no |
| ipv6_cidr_block_network_border_group | IPv6 CIDR block network border group | `string` | `null` | no |

### Subnet Configuration
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| public_subnet_map_public_ip_on_launch | Map public IP on launch for public subnets | `bool` | `true` | no |
| private_subnet_map_public_ip_on_launch | Map public IP on launch for private subnets | `bool` | `false` | no |
| public_subnet_assign_ipv6_address_on_creation | Assign IPv6 address on creation for public subnets | `bool` | `false` | no |
| private_subnet_assign_ipv6_address_on_creation | Assign IPv6 address on creation for private subnets | `bool` | `false` | no |
| public_subnet_ipv6_cidr_blocks | IPv6 CIDR blocks for public subnets | `list(string)` | `null` | no |
| private_subnet_ipv6_cidr_blocks | IPv6 CIDR blocks for private subnets | `list(string)` | `null` | no |

### NAT Gateway Configuration
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| enable_nat_gateway | Enable NAT Gateway for private subnets | `bool` | `true` | no |
| nat_gateway_single_az_only | Create NAT Gateway in single AZ only | `bool` | `false` | no |
| nat_gateway_connectivity_type | NAT Gateway connectivity type | `string` | `"public"` | no |

### Transit Gateway Configuration
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| transit_gateway_asn | Amazon side ASN for Transit Gateway | `number` | `64512` | no |
| transit_gateway_auto_accept_shared_attachments | Auto-accept shared attachments | `string` | `"disable"` | no |
| transit_gateway_default_route_table_association | Enable default route table association | `string` | `"enable"` | no |
| transit_gateway_default_route_table_propagation | Enable default route table propagation | `string` | `"enable"` | no |
| transit_gateway_dns_support | Enable DNS support | `string` | `"enable"` | no |
| transit_gateway_vpn_ecmp_support | Enable VPN ECMP support | `string` | `"enable"` | no |
| transit_gateway_multicast_support | Enable multicast support | `string` | `"disable"` | no |

### Load Balancer Configuration
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| enable_alb | Enable Application Load Balancer | `bool` | `false` | no |
| alb_name | Custom ALB name | `string` | `null` | no |
| alb_internal | Internal load balancer | `bool` | `false` | no |
| alb_load_balancer_type | Load balancer type | `string` | `"application"` | no |
| alb_enable_deletion_protection | Enable deletion protection | `bool` | `false` | no |
| alb_enable_cross_zone_load_balancing | Enable cross-zone load balancing | `bool` | `true` | no |
| alb_enable_http2 | Enable HTTP/2 | `bool` | `true` | no |
| alb_idle_timeout | Idle timeout in seconds | `number` | `60` | no |

### Target Group Configuration
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| target_group_port | Target port | `number` | `80` | no |
| target_group_protocol | Target protocol | `string` | `"HTTP"` | no |
| target_group_health_check_enabled | Enable health checks | `bool` | `true` | no |
| target_group_health_check_interval | Health check interval in seconds | `number` | `30` | no |
| target_group_health_check_path | Health check path | `string` | `"/health"` | no |
| target_group_health_check_protocol | Health check protocol | `string` | `"HTTP"` | no |
| target_group_health_check_timeout | Health check timeout in seconds | `number` | `5` | no |
| target_group_healthy_threshold | Healthy threshold count | `number` | `2` | no |
| target_group_unhealthy_threshold | Unhealthy threshold count | `number` | `2` | no |
| target_group_health_check_matcher | Health check matcher | `string` | `"200"` | no |

### CloudFront Configuration
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| enable_cloudfront | Enable CloudFront distribution | `bool` | `false` | no |
| cloudfront_price_class | Price class for edge locations | `string` | `"PriceClass_100"` | no |
| origin_domain_name | Origin domain name | `string` | `null` | no |
| cloudfront_origin_id | Origin identifier | `string` | `"ALB-Origin"` | no |
| cloudfront_origin_protocol_policy | Origin protocol policy | `string` | `"http-only"` | no |
| cloudfront_origin_ssl_protocols | SSL protocols | `list(string)` | `["TLSv1.2"]` | no |
| cloudfront_origin_http_port | HTTP port | `number` | `80` | no |
| cloudfront_origin_https_port | HTTPS port | `number` | `443` | no |
| cloudfront_enabled | Enable the distribution | `bool` | `true` | no |
| cloudfront_is_ipv6_enabled | Enable IPv6 support | `bool` | `true` | no |
| cloudfront_default_root_object | Default root object | `string` | `"index.html"` | no |

### WAF Configuration
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| enable_waf | Enable WAF Web ACL | `bool` | `false` | no |
| waf_web_acl_name | Custom WAF Web ACL name | `string` | `null` | no |
| waf_web_acl_scope | WAF scope | `string` | `"REGIONAL"` | no |

### Security Group Configuration
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| alb_security_group_name | Custom ALB security group name | `string` | `null` | no |
| alb_security_group_description | Custom ALB security group description | `string` | `null` | no |
| app_security_group_name | Custom app security group name | `string` | `null` | no |
| app_security_group_description | Custom app security group description | `string` | `null` | no |

### Shield Advanced Configuration
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| enable_shield_advanced | Enable Shield Advanced protection | `bool` | `false` | no |
| shield_protection_name_alb | Custom Shield protection name for ALB | `string` | `null` | no |
| shield_protection_name_cloudfront | Custom Shield protection name for CloudFront | `string` | `null` | no |

### Monitoring and Logging Configuration
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| log_retention_days | Log retention period in days | `number` | `30` | no |
| cloudwatch_log_group_name | Custom CloudWatch log group name | `string` | `null` | no |
| enable_alb_logs | Enable ALB access logs | `bool` | `false` | no |
| alb_logs_bucket_name | Custom ALB logs bucket name | `string` | `null` | no |
| alb_logs_bucket_prefix | ALB logs bucket prefix | `string` | `"alb-logs"` | no |
| alb_logs_bucket_versioning | Bucket versioning status | `string` | `"Enabled"` | no |
| alb_logs_bucket_encryption | Server-side encryption algorithm | `string` | `"AES256"` | no |

### Flow Logs Configuration
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| enable_flow_logs | Enable VPC flow logs | `bool` | `false` | no |
| flow_logs_iam_role_arn | IAM role ARN for flow logs | `string` | `null` | no |
| flow_logs_log_destination | Log destination for flow logs | `string` | `null` | no |
| flow_logs_log_destination_type | Log destination type | `string` | `"cloud-watch-logs"` | no |
| flow_logs_traffic_type | Traffic type for flow logs | `string` | `"ALL"` | no |
| flow_logs_max_aggregation_interval | Max aggregation interval for flow logs | `number` | `600` | no |

### VPC Endpoints Configuration
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| enable_vpc_endpoints | Enable VPC endpoints | `bool` | `false` | no |
| vpc_endpoints | VPC endpoint configurations | `list(object)` | `[]` | no |

### Direct Connect Configuration
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| enable_direct_connect | Enable Direct Connect | `bool` | `false` | no |
| direct_connect_allowed_prefixes | Allowed prefixes for Direct Connect | `list(string)` | `[]` | no |

### VPN Configuration
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| enable_vpn | Enable VPN connections | `bool` | `false` | no |
| vpn_connections | VPN connection configurations | `list(object)` | `[]` | no |

## 📤 Outputs

| Name | Description |
|------|-------------|
| vpc_id | ID of the VPC |
| vpc_cidr_block | CIDR block of the VPC |
| public_subnet_ids | IDs of the public subnets |
| private_subnet_ids | IDs of the private subnets |
| public_subnet_cidrs | CIDR blocks of the public subnets |
| private_subnet_cidrs | CIDR blocks of the private subnets |
| transit_gateway_id | ID of the Transit Gateway |
| transit_gateway_arn | ARN of the Transit Gateway |
| transit_gateway_vpc_attachment_id | ID of the Transit Gateway VPC attachment |
| direct_connect_gateway_id | ID of the Direct Connect Gateway |
| direct_connect_gateway_association_id | ID of the Direct Connect Gateway association |
| vpn_connection_ids | IDs of the VPN connections |
| vpn_connection_tunnel1_addresses | Tunnel 1 addresses of the VPN connections |
| vpn_connection_tunnel2_addresses | Tunnel 2 addresses of the VPN connections |
| alb_id | ID of the Application Load Balancer |
| alb_arn | ARN of the Application Load Balancer |
| alb_dns_name | DNS name of the Application Load Balancer |
| alb_zone_id | Zone ID of the Application Load Balancer |
| target_group_arn | ARN of the target group |
| cloudfront_distribution_id | ID of the CloudFront distribution |
| cloudfront_distribution_arn | ARN of the CloudFront distribution |
| cloudfront_domain_name | Domain name of the CloudFront distribution |
| waf_web_acl_id | ID of the WAF Web ACL |
| waf_web_acl_arn | ARN of the WAF Web ACL |
| shield_protection_alb_id | ID of the Shield protection for ALB |
| shield_protection_cloudfront_id | ID of the Shield protection for CloudFront |
| alb_security_group_id | ID of the ALB security group |
| app_security_group_id | ID of the app security group |
| cloudwatch_log_group_name | Name of the CloudWatch log group |
| alb_logs_bucket_name | Name of the ALB logs bucket |
| network_summary | Network configuration summary |

## 🔧 Examples

### Basic Example
See the [basic example](./examples/basic/) for a minimal configuration with essential features enabled.

### Advanced Example
See the [advanced example](./examples/advanced/) for a comprehensive configuration with all features enabled.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🆘 Support

For support and questions, please open an issue in the GitHub repository.