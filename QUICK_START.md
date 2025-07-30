# Quick Start Guide

This guide will help you deploy the AWS Enterprise Global Infrastructure module quickly.

## Prerequisites

1. **AWS CLI configured** with appropriate permissions
2. **Terraform >= 1.0** installed
3. **AWS Provider >= 5.0** available

## Quick Deployment

### 1. Clone or Download the Module

```bash
git clone <repository-url>
cd tfm-aws-enterprise-global
```

### 2. Choose Your Configuration

#### Option A: Basic Setup (Recommended for first-time users)

```bash
cd examples/basic
```

#### Option B: Advanced Setup (Full enterprise features)

```bash
cd examples/advanced
```

### 3. Initialize and Deploy

```bash
# Initialize Terraform
terraform init

# Review the plan
terraform plan

# Apply the configuration
terraform apply
```

### 4. Verify Deployment

After successful deployment, you'll see outputs like:

```
Outputs:

vpc_id = "vpc-xxxxxxxxx"
alb_dns_name = "dev-basic-example-alb-xxxxxxxxx.us-east-1.elb.amazonaws.com"
network_summary = {
  "alb_enabled" = true
  "cloudfront_enabled" = false
  "direct_connect" = false
  "private_subnets" = 2
  "public_subnets" = 2
  "shield_enabled" = false
  "transit_gateway_id" = "tgw-xxxxxxxxx"
  "vpc_cidr" = "10.0.0.0/16"
  "vpc_id" = "vpc-xxxxxxxxx"
  "vpn_connections" = 0
  "waf_enabled" = true
}
```

## Customization

### Modify Variables

Edit the `main.tf` file in your chosen example directory:

```hcl
module "enterprise_global" {
  source = "../../"

  environment = "prod"  # Change environment
  project_name = "my-app"  # Change project name
  
  # Customize VPC CIDR
  vpc_cidr_block = "172.16.0.0/16"
  
  # Enable additional features
  enable_cloudfront = true
  enable_shield_advanced = true
}
```

### Common Customizations

1. **Change Region**: Modify the provider block
2. **Add VPN Connections**: Configure `vpn_connections` variable
3. **Enable Direct Connect**: Set `enable_direct_connect = true`
4. **Custom Security Rules**: Modify security group configurations

## Testing Your Deployment

### 1. Test ALB Health Check

```bash
# Get the ALB DNS name from outputs
curl -I http://<alb-dns-name>/health
```

### 2. Test Network Connectivity

```bash
# Test VPC connectivity (if you have instances)
aws ec2 describe-instances --filters "Name=vpc-id,Values=<vpc-id>"
```

### 3. Verify Security Groups

```bash
# Check security group rules
aws ec2 describe-security-groups --group-ids <security-group-id>
```

## Cleanup

To remove all resources:

```bash
terraform destroy
```

## Troubleshooting

### Common Issues

1. **Permission Denied**: Ensure your AWS credentials have sufficient permissions
2. **VPC CIDR Conflict**: Change the VPC CIDR block if it conflicts with existing VPCs
3. **Resource Limits**: Check AWS service limits in your account

### Getting Help

- Check the main [README.md](README.md) for detailed documentation
- Review the [examples](examples/) directory for more configurations
- Use `terraform plan` to preview changes before applying

## Next Steps

1. **Add Application Servers**: Deploy EC2 instances or ECS services
2. **Configure DNS**: Set up Route 53 for custom domain names
3. **Enable Monitoring**: Add CloudWatch alarms and dashboards
4. **Implement CI/CD**: Integrate with your deployment pipeline

## Cost Optimization

- Use the basic example for development/testing
- Enable Shield Advanced only for production workloads
- Consider using Spot instances for non-critical workloads
- Monitor costs with AWS Cost Explorer

---

**Note**: Always test in a non-production environment first! 