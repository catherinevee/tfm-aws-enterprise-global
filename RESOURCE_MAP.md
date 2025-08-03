# Resource Map - AWS Enterprise Global Infrastructure Module

This document provides a comprehensive overview of all AWS resources created by the `tfm-aws-enterprise-global` Terraform module, organized by functional category.

## 📊 Resource Summary

| Category | Resource Count | Estimated Monthly Cost |
|----------|---------------|----------------------|
| **Networking** | 8-12 resources | $50-200 |
| **Connectivity** | 2-8 resources | $100-500 |
| **Load Balancing** | 3-4 resources | $20-100 |
| **Security** | 4-6 resources | $5-50 |
| **Monitoring** | 2-4 resources | $10-50 |
| **Global Distribution** | 1-2 resources | $10-100 |
| **Total** | **20-36 resources** | **$195-1000** |

*Cost estimates are approximate and vary based on usage patterns and region.*

## 🏗️ Resource Categories

### 1. Core Networking Resources

#### VPC and Subnets
- **`aws_vpc.main`** - Main VPC with configurable CIDR block and IPv6 support
- **`aws_subnet.public`** - Public subnets across multiple availability zones
- **`aws_subnet.private`** - Private subnets across multiple availability zones

#### Internet Connectivity
- **`aws_internet_gateway.main`** - Internet Gateway for public subnet access
- **`aws_eip.nat`** - Elastic IP for NAT Gateway (conditional)
- **`aws_nat_gateway.main`** - NAT Gateway for private subnet internet access (conditional)

#### Routing
- **`aws_route_table.public`** - Route table for public subnets with internet gateway route
- **`aws_route_table.private`** - Route table for private subnets with NAT gateway route (conditional)
- **`aws_route_table_association.public`** - Associates public subnets with public route table
- **`aws_route_table_association.private`** - Associates private subnets with private route table

### 2. Hybrid Connectivity Resources

#### Transit Gateway
- **`aws_ec2_transit_gateway.main`** - Transit Gateway for multi-account connectivity
- **`aws_ec2_transit_gateway_vpc_attachment.main`** - VPC attachment to Transit Gateway

#### Direct Connect
- **`aws_dx_gateway.main`** - Direct Connect Gateway (conditional)
- **`aws_dx_gateway_association.main`** - Direct Connect Gateway association (conditional)

#### VPN Connectivity
- **`aws_customer_gateway.main`** - Customer Gateway for VPN connections (conditional)
- **`aws_vpn_connection.main`** - VPN connections with BGP support (conditional)
- **`aws_vpn_connection_route.main`** - Static routes for VPN connections (conditional)

### 3. Application Delivery Resources

#### Load Balancing
- **`aws_lb.main`** - Application Load Balancer (conditional)
- **`aws_lb_target_group.main`** - Target group for ALB (conditional)
- **`aws_lb_listener.main`** - ALB listener for traffic routing (conditional)

#### Global Distribution
- **`aws_cloudfront_distribution.main`** - CloudFront distribution for global content delivery (conditional)

### 4. Security and Protection Resources

#### Web Application Firewall
- **`aws_wafv2_web_acl.main`** - WAF v2 Web ACL with managed rules (conditional)
- **`aws_wafv2_web_acl_association.main`** - WAF association with ALB/CloudFront (conditional)

#### Shield Advanced Protection
- **`aws_shield_protection.alb`** - Shield Advanced protection for ALB (conditional)
- **`aws_shield_protection.cloudfront`** - Shield Advanced protection for CloudFront (conditional)

#### Security Groups
- **`aws_security_group.alb`** - Security group for Application Load Balancer (conditional)
- **`aws_security_group.app`** - Security group for application instances

### 5. Monitoring and Logging Resources

#### CloudWatch Logging
- **`aws_cloudwatch_log_group.main`** - CloudWatch log group for application logs

#### S3 Logging
- **`aws_s3_bucket.alb_logs`** - S3 bucket for ALB access logs (conditional)
- **`aws_s3_bucket_versioning.alb_logs`** - Versioning for ALB logs bucket (conditional)
- **`aws_s3_bucket_server_side_encryption_configuration.alb_logs`** - Encryption for ALB logs bucket (conditional)
- **`aws_s3_bucket_public_access_block.alb_logs`** - Public access blocking for ALB logs bucket (conditional)

## 🔗 Resource Dependencies

### Core Dependencies
```
aws_vpc.main
├── aws_subnet.public
├── aws_subnet.private
├── aws_internet_gateway.main
├── aws_route_table.public
├── aws_route_table.private
└── aws_ec2_transit_gateway_vpc_attachment.main
```

### Conditional Dependencies
```
enable_nat_gateway = true
├── aws_eip.nat
├── aws_nat_gateway.main
└── aws_route_table.private (updated)

enable_alb = true
├── aws_lb.main
├── aws_lb_target_group.main
├── aws_lb_listener.main
├── aws_security_group.alb
└── aws_wafv2_web_acl_association.main (if WAF enabled)

enable_cloudfront = true
├── aws_cloudfront_distribution.main
└── aws_wafv2_web_acl_association.main (if WAF enabled)

enable_direct_connect = true
├── aws_dx_gateway.main
└── aws_dx_gateway_association.main

enable_vpn = true
├── aws_customer_gateway.main
├── aws_vpn_connection.main
└── aws_vpn_connection_route.main

enable_waf = true
└── aws_wafv2_web_acl.main

enable_shield_advanced = true
├── aws_shield_protection.alb (if ALB enabled)
└── aws_shield_protection.cloudfront (if CloudFront enabled)

enable_alb_logs = true
├── aws_s3_bucket.alb_logs
├── aws_s3_bucket_versioning.alb_logs
├── aws_s3_bucket_server_side_encryption_configuration.alb_logs
└── aws_s3_bucket_public_access_block.alb_logs
```

## 🏷️ Resource Tagging Strategy

All resources are tagged with the following standard tags:
- **`Name`** - Resource-specific naming convention
- **`Environment`** - Environment identifier (dev, staging, prod)
- **`Project`** - Project name identifier
- **`Owner`** - Resource owner or team
- **`CostCenter`** - Cost allocation identifier
- **`Tier`** - Resource tier (Public, Private) for subnets

## 📈 Scaling Considerations

### Horizontal Scaling
- **Subnets**: Add more CIDR blocks to `public_subnet_cidrs` and `private_subnet_cidrs`
- **Availability Zones**: Extend `availability_zones` list for multi-AZ deployment
- **VPN Connections**: Add more entries to `vpn_connections` list

### Vertical Scaling
- **NAT Gateway**: Consider single-AZ deployment for cost optimization
- **ALB**: Adjust capacity units and target group settings
- **CloudFront**: Optimize cache behaviors and origin settings

## 🔒 Security Considerations

### Network Security
- Private subnets have no direct internet access (NAT Gateway required)
- Security groups follow least-privilege principle
- WAF provides application-layer protection
- Shield Advanced offers DDoS protection

### Data Protection
- S3 buckets have encryption enabled by default
- Public access is blocked on logging buckets
- CloudWatch logs have configurable retention periods
- All resources support customer-managed KMS keys

## 💰 Cost Optimization

### Development Environment
- Disable NAT Gateway (`enable_nat_gateway = false`)
- Disable ALB logs (`enable_alb_logs = false`)
- Use single AZ deployment
- Disable Shield Advanced (`enable_shield_advanced = false`)

### Production Environment
- Enable all security features
- Use multi-AZ deployment for high availability
- Enable comprehensive logging and monitoring
- Consider reserved capacity for predictable workloads

## 🚀 Deployment Recommendations

### Blue-Green Deployment
- Use separate VPCs for blue and green environments
- Share Transit Gateway for connectivity
- Use CloudFront for traffic switching

### Multi-Region Deployment
- Deploy module in each target region
- Use Transit Gateway for inter-region connectivity
- Configure CloudFront with multiple origins

### Disaster Recovery
- Use separate AWS accounts for DR
- Replicate critical data across regions
- Test failover procedures regularly 