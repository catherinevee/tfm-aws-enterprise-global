# VPC Outputs
output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "vpc_cidr_block" {
  description = "CIDR block of the VPC"
  value       = aws_vpc.main.cidr_block
}

# Subnet Outputs
output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = aws_subnet.private[*].id
}

output "public_subnet_cidrs" {
  description = "CIDR blocks of the public subnets"
  value       = aws_subnet.public[*].cidr_block
}

output "private_subnet_cidrs" {
  description = "CIDR blocks of the private subnets"
  value       = aws_subnet.private[*].cidr_block
}

# Transit Gateway Outputs
output "transit_gateway_id" {
  description = "ID of the Transit Gateway"
  value       = aws_ec2_transit_gateway.main.id
}

output "transit_gateway_arn" {
  description = "ARN of the Transit Gateway"
  value       = aws_ec2_transit_gateway.main.arn
}

output "transit_gateway_vpc_attachment_id" {
  description = "ID of the Transit Gateway VPC attachment"
  value       = aws_ec2_transit_gateway_vpc_attachment.main.id
}

# Direct Connect Outputs
output "direct_connect_gateway_id" {
  description = "ID of the Direct Connect Gateway"
  value       = var.enable_direct_connect ? aws_dx_gateway.main[0].id : null
}

output "direct_connect_gateway_association_id" {
  description = "ID of the Direct Connect Gateway association"
  value       = var.enable_direct_connect ? aws_dx_gateway_association.main[0].id : null
}

# VPN Outputs
output "vpn_connection_ids" {
  description = "IDs of the VPN connections"
  value       = var.enable_vpn ? aws_vpn_connection.main[*].id : []
}

output "vpn_connection_tunnel1_addresses" {
  description = "Tunnel 1 addresses of the VPN connections"
  value       = var.enable_vpn ? aws_vpn_connection.main[*].tunnel1_address : []
}

output "vpn_connection_tunnel2_addresses" {
  description = "Tunnel 2 addresses of the VPN connections"
  value       = var.enable_vpn ? aws_vpn_connection.main[*].tunnel2_address : []
}

# Load Balancer Outputs
output "alb_id" {
  description = "ID of the Application Load Balancer"
  value       = var.enable_alb ? aws_lb.main[0].id : null
}

output "alb_arn" {
  description = "ARN of the Application Load Balancer"
  value       = var.enable_alb ? aws_lb.main[0].arn : null
}

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = var.enable_alb ? aws_lb.main[0].dns_name : null
}

output "alb_zone_id" {
  description = "Zone ID of the Application Load Balancer"
  value       = var.enable_alb ? aws_lb.main[0].zone_id : null
}

output "target_group_arn" {
  description = "ARN of the target group"
  value       = var.enable_alb ? aws_lb_target_group.main[0].arn : null
}

# CloudFront Outputs
output "cloudfront_distribution_id" {
  description = "ID of the CloudFront distribution"
  value       = var.enable_cloudfront ? aws_cloudfront_distribution.main[0].id : null
}

output "cloudfront_distribution_arn" {
  description = "ARN of the CloudFront distribution"
  value       = var.enable_cloudfront ? aws_cloudfront_distribution.main[0].arn : null
}

output "cloudfront_domain_name" {
  description = "Domain name of the CloudFront distribution"
  value       = var.enable_cloudfront ? aws_cloudfront_distribution.main[0].domain_name : null
}

# WAF Outputs
output "waf_web_acl_id" {
  description = "ID of the WAF Web ACL"
  value       = var.enable_waf ? aws_wafv2_web_acl.main[0].id : null
}

output "waf_web_acl_arn" {
  description = "ARN of the WAF Web ACL"
  value       = var.enable_waf ? aws_wafv2_web_acl.main[0].arn : null
}

# Shield Outputs
output "shield_protection_alb_id" {
  description = "ID of the Shield protection for ALB"
  value       = var.enable_shield_advanced && var.enable_alb ? aws_shield_protection.alb[0].id : null
}

output "shield_protection_cloudfront_id" {
  description = "ID of the Shield protection for CloudFront"
  value       = var.enable_shield_advanced && var.enable_cloudfront ? aws_shield_protection.cloudfront[0].id : null
}

# Security Group Outputs
output "alb_security_group_id" {
  description = "ID of the ALB security group"
  value       = var.enable_alb ? aws_security_group.alb[0].id : null
}

output "app_security_group_id" {
  description = "ID of the application security group"
  value       = aws_security_group.app.id
}

# Logging Outputs
output "cloudwatch_log_group_name" {
  description = "Name of the CloudWatch log group"
  value       = aws_cloudwatch_log_group.main.name
}

output "alb_logs_bucket_name" {
  description = "Name of the S3 bucket for ALB logs"
  value       = var.enable_alb_logs ? aws_s3_bucket.alb_logs[0].bucket : null
}

# Network Information
output "network_summary" {
  description = "Summary of network configuration"
  value = {
    vpc_id              = aws_vpc.main.id
    vpc_cidr            = aws_vpc.main.cidr_block
    public_subnets      = length(aws_subnet.public)
    private_subnets     = length(aws_subnet.private)
    transit_gateway_id  = aws_ec2_transit_gateway.main.id
    direct_connect      = var.enable_direct_connect
    vpn_connections     = var.enable_vpn ? length(var.vpn_connections) : 0
    alb_enabled         = var.enable_alb
    cloudfront_enabled  = var.enable_cloudfront
    waf_enabled         = var.enable_waf
    shield_enabled      = var.enable_shield_advanced
  }
} 