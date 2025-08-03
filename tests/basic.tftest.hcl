variables {
  environment = "test"
  project_name = "test-module"
  vpc_cidr_block = "10.1.0.0/16"
  public_subnet_cidrs = ["10.1.1.0/24"]
  private_subnet_cidrs = ["10.1.10.0/24"]
  availability_zones = ["us-east-1a"]
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

run "validate_module" {
  command = plan
  
  assert {
    condition     = aws_vpc.main.cidr_block == "10.1.0.0/16"
    error_message = "VPC CIDR block should match input variable."
  }
  
  assert {
    condition     = length(aws_subnet.public) == 1
    error_message = "Should create exactly one public subnet."
  }
  
  assert {
    condition     = length(aws_subnet.private) == 1
    error_message = "Should create exactly one private subnet."
  }
  
  assert {
    condition     = aws_subnet.public[0].cidr_block == "10.1.1.0/24"
    error_message = "Public subnet CIDR should match input variable."
  }
  
  assert {
    condition     = aws_subnet.private[0].cidr_block == "10.1.10.0/24"
    error_message = "Private subnet CIDR should match input variable."
  }
  
  assert {
    condition     = aws_subnet.public[0].availability_zone == "us-east-1a"
    error_message = "Public subnet should be in the specified availability zone."
  }
  
  assert {
    condition     = aws_subnet.private[0].availability_zone == "us-east-1a"
    error_message = "Private subnet should be in the specified availability zone."
  }
  
  assert {
    condition     = aws_internet_gateway.main.vpc_id == aws_vpc.main.id
    error_message = "Internet Gateway should be attached to the VPC."
  }
  
  assert {
    condition     = aws_ec2_transit_gateway.main.amazon_side_asn == 64512
    error_message = "Transit Gateway should have the correct ASN."
  }
  
  assert {
    condition     = aws_ec2_transit_gateway_vpc_attachment.main.vpc_id == aws_vpc.main.id
    error_message = "Transit Gateway VPC attachment should be attached to the VPC."
  }
  
  assert {
    condition     = aws_ec2_transit_gateway_vpc_attachment.main.transit_gateway_id == aws_ec2_transit_gateway.main.id
    error_message = "Transit Gateway VPC attachment should be attached to the Transit Gateway."
  }
  
  assert {
    condition     = length(aws_lb.main) == 1
    error_message = "Should create exactly one ALB when enabled."
  }
  
  assert {
    condition     = aws_lb.main[0].internal == false
    error_message = "ALB should be internet-facing by default."
  }
  
  assert {
    condition     = aws_lb.main[0].load_balancer_type == "application"
    error_message = "ALB should be of application type."
  }
  
  assert {
    condition     = length(aws_lb_target_group.main) == 1
    error_message = "Should create exactly one target group when ALB is enabled."
  }
  
  assert {
    condition     = aws_lb_target_group.main[0].vpc_id == aws_vpc.main.id
    error_message = "Target group should be in the VPC."
  }
  
  assert {
    condition     = length(aws_lb_listener.main) == 1
    error_message = "Should create exactly one listener when ALB is enabled."
  }
  
  assert {
    condition     = aws_lb_listener.main[0].load_balancer_arn == aws_lb.main[0].arn
    error_message = "Listener should be attached to the ALB."
  }
  
  assert {
    condition     = length(aws_security_group.alb) == 1
    error_message = "Should create exactly one ALB security group when ALB is enabled."
  }
  
  assert {
    condition     = aws_security_group.alb[0].vpc_id == aws_vpc.main.id
    error_message = "ALB security group should be in the VPC."
  }
  
  assert {
    condition     = aws_security_group.app.vpc_id == aws_vpc.main.id
    error_message = "Application security group should be in the VPC."
  }
  
  assert {
    condition     = aws_cloudwatch_log_group.main.name == "${var.environment}-${var.project_name}-logs"
    error_message = "CloudWatch log group should have the correct name."
  }
  
  assert {
    condition     = aws_cloudwatch_log_group.main.retention_in_days == 30
    error_message = "CloudWatch log group should have the correct retention period."
  }
}

run "validate_outputs" {
  command = plan
  
  assert {
    condition     = vpc_id == aws_vpc.main.id
    error_message = "vpc_id output should match the VPC ID."
  }
  
  assert {
    condition     = vpc_cidr_block == aws_vpc.main.cidr_block
    error_message = "vpc_cidr_block output should match the VPC CIDR block."
  }
  
  assert {
    condition     = length(public_subnet_ids) == 1
    error_message = "public_subnet_ids output should contain one subnet ID."
  }
  
  assert {
    condition     = length(private_subnet_ids) == 1
    error_message = "private_subnet_ids output should contain one subnet ID."
  }
  
  assert {
    condition     = public_subnet_ids[0] == aws_subnet.public[0].id
    error_message = "public_subnet_ids output should match the public subnet ID."
  }
  
  assert {
    condition     = private_subnet_ids[0] == aws_subnet.private[0].id
    error_message = "private_subnet_ids output should match the private subnet ID."
  }
  
  assert {
    condition     = transit_gateway_id == aws_ec2_transit_gateway.main.id
    error_message = "transit_gateway_id output should match the Transit Gateway ID."
  }
  
  assert {
    condition     = transit_gateway_arn == aws_ec2_transit_gateway.main.arn
    error_message = "transit_gateway_arn output should match the Transit Gateway ARN."
  }
  
  assert {
    condition     = transit_gateway_vpc_attachment_id == aws_ec2_transit_gateway_vpc_attachment.main.id
    error_message = "transit_gateway_vpc_attachment_id output should match the VPC attachment ID."
  }
  
  assert {
    condition     = alb_id == aws_lb.main[0].id
    error_message = "alb_id output should match the ALB ID."
  }
  
  assert {
    condition     = alb_arn == aws_lb.main[0].arn
    error_message = "alb_arn output should match the ALB ARN."
  }
  
  assert {
    condition     = alb_dns_name == aws_lb.main[0].dns_name
    error_message = "alb_dns_name output should match the ALB DNS name."
  }
  
  assert {
    condition     = alb_zone_id == aws_lb.main[0].zone_id
    error_message = "alb_zone_id output should match the ALB zone ID."
  }
  
  assert {
    condition     = target_group_arn == aws_lb_target_group.main[0].arn
    error_message = "target_group_arn output should match the target group ARN."
  }
  
  assert {
    condition     = alb_security_group_id == aws_security_group.alb[0].id
    error_message = "alb_security_group_id output should match the ALB security group ID."
  }
  
  assert {
    condition     = app_security_group_id == aws_security_group.app.id
    error_message = "app_security_group_id output should match the application security group ID."
  }
  
  assert {
    condition     = cloudwatch_log_group_name == aws_cloudwatch_log_group.main.name
    error_message = "cloudwatch_log_group_name output should match the CloudWatch log group name."
  }
  
  assert {
    condition     = network_summary.vpc_id == aws_vpc.main.id
    error_message = "network_summary.vpc_id should match the VPC ID."
  }
  
  assert {
    condition     = network_summary.vpc_cidr == aws_vpc.main.cidr_block
    error_message = "network_summary.vpc_cidr should match the VPC CIDR block."
  }
  
  assert {
    condition     = network_summary.public_subnets == 1
    error_message = "network_summary.public_subnets should be 1."
  }
  
  assert {
    condition     = network_summary.private_subnets == 1
    error_message = "network_summary.private_subnets should be 1."
  }
  
  assert {
    condition     = network_summary.transit_gateway_id == aws_ec2_transit_gateway.main.id
    error_message = "network_summary.transit_gateway_id should match the Transit Gateway ID."
  }
  
  assert {
    condition     = network_summary.direct_connect == false
    error_message = "network_summary.direct_connect should be false."
  }
  
  assert {
    condition     = network_summary.vpn_connections == 0
    error_message = "network_summary.vpn_connections should be 0."
  }
  
  assert {
    condition     = network_summary.alb_enabled == true
    error_message = "network_summary.alb_enabled should be true."
  }
  
  assert {
    condition     = network_summary.cloudfront_enabled == false
    error_message = "network_summary.cloudfront_enabled should be false."
  }
  
  assert {
    condition     = network_summary.waf_enabled == false
    error_message = "network_summary.waf_enabled should be false."
  }
  
  assert {
    condition     = network_summary.shield_enabled == false
    error_message = "network_summary.shield_enabled should be false."
  }
} 