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
- ✅ VPC with configurable CIDR blocks
- ✅ Public and private subnets across multiple AZs
- ✅ Internet Gateway and NAT Gateway
- ✅ Route tables with proper routing

### Hybrid Connectivity
- ✅ Transit Gateway for multi-account connectivity
- ✅ Direct Connect Gateway with configurable prefixes
- ✅ VPN connections with BGP support
- ✅ Static and dynamic routing options

### Application Delivery
- ✅ Application Load Balancer with health checks
- ✅ Target groups with configurable health check settings
- ✅ CloudFront distribution with custom origins
- ✅ Global content delivery optimization

### Security & Protection
- ✅ WAF v2 Web ACL with AWS managed rules
- ✅ Rate limiting and IP-based blocking
- ✅ Shield Advanced protection for ALB and CloudFront
- ✅ Security groups with least-privilege access
- ✅ S3 bucket encryption and access controls

### Monitoring & Logging
- ✅ CloudWatch log groups with configurable retention
- ✅ ALB access logs stored in S3
- ✅ Comprehensive resource tagging
- ✅ Network summary outputs

## 📋 Prerequisites

- Terraform >= 1.0
- AWS Provider >= 5.0
- AWS CLI configured with appropriate permissions
- For Shield Advanced: AWS Shield Advanced subscription
- For Direct Connect: Direct Connect connection established

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

```hcl
module "enterprise_global" {
  source = "./tfm-aws-enterprise-global"

  environment = "prod"
  project_name = "enterprise-platform"

  # Custom VPC Configuration
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
    Project     = "enterprise-platform"
    Owner       = "Infrastructure Team"
    CostCenter  = "IT-002"
    DataClassification = "Internal"
  }
}
```

### Minimal Configuration

```hcl
module "enterprise_global" {
  source = "./tfm-aws-enterprise-global"

  environment = "dev"
  project_name = "test-app"

  # Only enable basic networking and ALB
  enable_cloudfront = false
  enable_waf = false
  enable_shield_advanced = false
  enable_direct_connect = false
  enable_vpn = false
  enable_nat_gateway = false

  common_tags = {
    Environment = "dev"
    Project     = "test-app"
  }
}
```

## 📊 Outputs

The module provides comprehensive outputs for integration with other modules:

```hcl
# Network Information
output "vpc_id" {
  value = module.enterprise_global.vpc_id
}

output "public_subnet_ids" {
  value = module.enterprise_global.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.enterprise_global.private_subnet_ids
}

# Load Balancer Information
output "alb_dns_name" {
  value = module.enterprise_global.alb_dns_name
}

output "target_group_arn" {
  value = module.enterprise_global.target_group_arn
}

# CloudFront Information
output "cloudfront_domain_name" {
  value = module.enterprise_global.cloudfront_domain_name
}

# Security Information
output "waf_web_acl_arn" {
  value = module.enterprise_global.waf_web_acl_arn
}

# Network Summary
output "network_summary" {
  value = module.enterprise_global.network_summary
}
```

## 🔒 Security Considerations

### WAF Rules
The module includes the following WAF rules by default:
- **AWS Managed Rules Common Rule Set**: Protects against common web vulnerabilities
- **AWS Managed Rules Known Bad Inputs**: Blocks known malicious inputs
- **Rate Limiting**: Blocks requests exceeding 2000 requests per IP per 5 minutes

### Security Groups
- **ALB Security Group**: Allows HTTP/HTTPS from anywhere
- **Application Security Group**: Allows traffic only from ALB

### Encryption
- S3 buckets use AES256 encryption
- CloudFront uses HTTPS by default
- All sensitive data is encrypted at rest

## 💰 Cost Optimization

### Recommendations
1. **Use appropriate CloudFront price class** based on your global distribution needs
2. **Enable ALB deletion protection** only in production environments
3. **Configure log retention** based on compliance requirements
4. **Use Shield Advanced** only for critical applications
5. **Optimize NAT Gateway usage** by placing it in a single AZ for dev/test

### Cost Estimation
- **Basic setup** (VPC + ALB): ~$50-100/month
- **With CloudFront**: +$20-50/month
- **With Shield Advanced**: +$3000/month
- **With Direct Connect**: +$300-500/month

## 🧪 Testing

### Validation
```bash
# Validate Terraform configuration
terraform validate

# Format code
terraform fmt

# Plan deployment
terraform plan

# Apply configuration
terraform apply
```

### Testing with Terratest
```go
package test

import (
    "testing"
    "github.com/gruntwork-io/terratest/modules/terraform"
    "github.com/stretchr/testify/assert"
)

func TestEnterpriseGlobalModule(t *testing.T) {
    terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
        TerraformDir: "../",
        Vars: map[string]interface{}{
            "environment": "test",
            "project_name": "test-module",
        },
    })

    defer terraform.Destroy(t, terraformOptions)
    terraform.InitAndApply(t, terraformOptions)

    // Test outputs
    vpcId := terraform.Output(t, terraformOptions, "vpc_id")
    assert.NotEmpty(t, vpcId)
}
```

## 🔄 Multi-Account Setup

For multi-account deployments, use the Transit Gateway outputs:

```hcl
# In Account A (Hub)
module "hub_network" {
  source = "./tfm-aws-enterprise-global"
  # ... configuration
}

# In Account B (Spoke)
module "spoke_network" {
  source = "./tfm-aws-enterprise-global"
  
  # Reference hub Transit Gateway
  transit_gateway_id = module.hub_network.transit_gateway_id
}
```

## 🚨 Troubleshooting

### Common Issues

1. **Direct Connect not working**
   - Verify Direct Connect connection is established
   - Check allowed prefixes configuration
   - Ensure proper BGP configuration

2. **VPN connection issues**
   - Verify customer gateway IP is reachable
   - Check BGP ASN configuration
   - Review route table associations

3. **WAF blocking legitimate traffic**
   - Review WAF logs in CloudWatch
   - Adjust rate limiting rules
   - Consider custom allow rules

4. **CloudFront not serving content**
   - Verify origin configuration
   - Check security group rules
   - Review cache behavior settings

## 📚 Additional Resources

- [AWS Transit Gateway Documentation](https://docs.aws.amazon.com/vpc/latest/tgw/)
- [AWS Direct Connect Documentation](https://docs.aws.amazon.com/directconnect/)
- [AWS WAF Documentation](https://docs.aws.amazon.com/waf/)
- [AWS Shield Documentation](https://docs.aws.amazon.com/shield/)
- [CloudFront Documentation](https://docs.aws.amazon.com/cloudfront/)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests
5. Submit a pull request

## 📄 License

This module is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## ⚠️ Disclaimer

This module is provided as-is without warranty. Always test in a non-production environment before deploying to production.