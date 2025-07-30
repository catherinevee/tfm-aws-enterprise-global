terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Data sources for current AWS account and region
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# VPC and Networking Resources
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support
  assign_generated_ipv6_cidr_block = var.assign_generated_ipv6_cidr_block
  ipv6_cidr_block      = var.ipv6_cidr_block
  ipv6_cidr_block_network_border_group = var.ipv6_cidr_block_network_border_group

  tags = merge(var.common_tags, {
    Name = "${var.environment}-${var.project_name}-vpc"
  })
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.common_tags, {
    Name = "${var.environment}-${var.project_name}-igw"
  })
}

# Public Subnets
resource "aws_subnet" "public" {
  count             = length(var.public_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  map_public_ip_on_launch = true

  tags = merge(var.common_tags, {
    Name = "${var.environment}-${var.project_name}-public-${var.availability_zones[count.index]}"
    Tier = "Public"
  })
}

# Private Subnets
resource "aws_subnet" "private" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = merge(var.common_tags, {
    Name = "${var.environment}-${var.project_name}-private-${var.availability_zones[count.index]}"
    Tier = "Private"
  })
}

# NAT Gateway
resource "aws_eip" "nat" {
  count = var.enable_nat_gateway ? 1 : 0
  domain = "vpc"

  tags = merge(var.common_tags, {
    Name = "${var.environment}-${var.project_name}-nat-eip"
  })
}

resource "aws_nat_gateway" "main" {
  count         = var.enable_nat_gateway ? 1 : 0
  allocation_id = aws_eip.nat[0].id
  subnet_id     = aws_subnet.public[0].id

  tags = merge(var.common_tags, {
    Name = "${var.environment}-${var.project_name}-nat-gateway"
  })

  depends_on = [aws_internet_gateway.main]
}

# Route Tables
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = merge(var.common_tags, {
    Name = "${var.environment}-${var.project_name}-public-rt"
  })
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  dynamic "route" {
    for_each = var.enable_nat_gateway ? [1] : []
    content {
      cidr_block     = "0.0.0.0/0"
      nat_gateway_id = aws_nat_gateway.main[0].id
    }
  }

  tags = merge(var.common_tags, {
    Name = "${var.environment}-${var.project_name}-private-rt"
  })
}

# Route Table Associations
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

# Transit Gateway
resource "aws_ec2_transit_gateway" "main" {
  description = "Transit Gateway for ${var.project_name}"

  default_route_table_association = var.transit_gateway_default_route_table_association
  default_route_table_propagation = var.transit_gateway_default_route_table_propagation
  amazon_side_asn                 = var.transit_gateway_asn
  auto_accept_shared_attachments  = var.transit_gateway_auto_accept_shared_attachments
  dns_support                     = var.transit_gateway_dns_support
  vpn_ecmp_support                = var.transit_gateway_vpn_ecmp_support
  multicast_support               = var.transit_gateway_multicast_support

  tags = merge(var.common_tags, {
    Name = "${var.environment}-${var.project_name}-tgw"
  })
}

# Transit Gateway VPC Attachment
resource "aws_ec2_transit_gateway_vpc_attachment" "main" {
  subnet_ids         = aws_subnet.private[*].id
  transit_gateway_id = aws_ec2_transit_gateway.main.id
  vpc_id             = aws_vpc.main.id

  tags = merge(var.common_tags, {
    Name = "${var.environment}-${var.project_name}-tgw-attachment"
  })
}

# Direct Connect Gateway
resource "aws_dx_gateway" "main" {
  count = var.enable_direct_connect ? 1 : 0
  name  = "${var.environment}-${var.project_name}-dx-gateway"

  tags = merge(var.common_tags, {
    Name = "${var.environment}-${var.project_name}-dx-gateway"
  })
}

# Direct Connect Gateway Association
resource "aws_dx_gateway_association" "main" {
  count = var.enable_direct_connect ? 1 : 0
  dx_gateway_id         = aws_dx_gateway.main[0].id
  associated_gateway_id = aws_ec2_transit_gateway.main.id

  allowed_prefixes = var.direct_connect_allowed_prefixes
}

# Customer Gateway for VPN
resource "aws_customer_gateway" "main" {
  count      = var.enable_vpn ? length(var.vpn_connections) : 0
  bgp_asn    = var.vpn_connections[count.index].bgp_asn
  ip_address = var.vpn_connections[count.index].customer_ip
  type       = "ipsec.1"

  tags = merge(var.common_tags, {
    Name = "${var.environment}-${var.project_name}-cgw-${count.index + 1}"
  })
}

# VPN Connection
resource "aws_vpn_connection" "main" {
  count               = var.enable_vpn ? length(var.vpn_connections) : 0
  customer_gateway_id = aws_customer_gateway.main[count.index].id
  transit_gateway_id  = aws_ec2_transit_gateway.main.id
  type                = "ipsec.1"

  static_routes_only = var.vpn_connections[count.index].static_routes_only

  tags = merge(var.common_tags, {
    Name = "${var.environment}-${var.project_name}-vpn-${count.index + 1}"
  })
}

# VPN Static Routes
resource "aws_vpn_connection_route" "main" {
  count                  = var.enable_vpn ? length(var.vpn_connections) : 0
  destination_cidr_block = var.vpn_connections[count.index].destination_cidr
  vpn_connection_id      = aws_vpn_connection.main[count.index].id
}

# Application Load Balancer
resource "aws_lb" "main" {
  count              = var.enable_alb ? 1 : 0
  name               = var.alb_name != null ? var.alb_name : "${var.environment}-${var.project_name}-alb"
  internal           = var.alb_internal
  load_balancer_type = var.alb_load_balancer_type
  security_groups    = [aws_security_group.alb[0].id]
  subnets            = aws_subnet.public[*].id

  enable_deletion_protection = var.alb_enable_deletion_protection
  enable_cross_zone_load_balancing = var.alb_enable_cross_zone_load_balancing
  enable_http2 = var.alb_enable_http2
  idle_timeout = var.alb_idle_timeout

  tags = merge(var.common_tags, {
    Name = var.alb_name != null ? var.alb_name : "${var.environment}-${var.project_name}-alb"
  })
}

# ALB Target Group
resource "aws_lb_target_group" "main" {
  count    = var.enable_alb ? 1 : 0
  name     = "${var.environment}-${var.project_name}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    enabled             = true
    healthy_threshold   = 2
    interval            = 30
    matcher             = "200"
    path                = "/health"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
  }

  tags = merge(var.common_tags, {
    Name = "${var.environment}-${var.project_name}-target-group"
  })
}

# ALB Listener
resource "aws_lb_listener" "main" {
  count             = var.enable_alb ? 1 : 0
  load_balancer_arn = aws_lb.main[0].arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main[0].arn
  }
}

# CloudFront Distribution
resource "aws_cloudfront_distribution" "main" {
  count               = var.enable_cloudfront ? 1 : 0
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"
  price_class         = var.cloudfront_price_class

  origin {
    domain_name = var.enable_alb ? aws_lb.main[0].dns_name : var.origin_domain_name
    origin_id   = "ALB-Origin"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "ALB-Origin"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  tags = merge(var.common_tags, {
    Name = "${var.environment}-${var.project_name}-cloudfront"
  })
}

# WAF Web ACL
resource "aws_wafv2_web_acl" "main" {
  count = var.enable_waf ? 1 : 0
  name  = "${var.environment}-${var.project_name}-web-acl"
  scope = "REGIONAL"

  default_action {
    allow {}
  }

  rule {
    name     = "AWSManagedRulesCommonRuleSet"
    priority = 1

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesCommonRuleSetMetric"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWSManagedRulesKnownBadInputsRuleSet"
    priority = 2

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesKnownBadInputsRuleSetMetric"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "RateLimitRule"
    priority = 3

    action {
      block {}
    }

    statement {
      rate_based_statement {
        limit              = 2000
        aggregate_key_type = "IP"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "RateLimitRuleMetric"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "WebACLMetric"
    sampled_requests_enabled   = true
  }

  tags = merge(var.common_tags, {
    Name = "${var.environment}-${var.project_name}-web-acl"
  })
}

# WAF Web ACL Association with ALB
resource "aws_wafv2_web_acl_association" "main" {
  count        = var.enable_waf && var.enable_alb ? 1 : 0
  resource_arn = aws_lb.main[0].arn
  web_acl_arn  = aws_wafv2_web_acl.main[0].arn
}

# Shield Advanced Protection (if enabled)
resource "aws_shield_protection" "alb" {
  count        = var.enable_shield_advanced && var.enable_alb ? 1 : 0
  name         = "${var.environment}-${var.project_name}-shield-alb"
  resource_arn = aws_lb.main[0].arn
}

resource "aws_shield_protection" "cloudfront" {
  count        = var.enable_shield_advanced && var.enable_cloudfront ? 1 : 0
  name         = "${var.environment}-${var.project_name}-shield-cloudfront"
  resource_arn = aws_cloudfront_distribution.main[0].arn
}

# Security Groups
resource "aws_security_group" "alb" {
  count       = var.enable_alb ? 1 : 0
  name        = "${var.environment}-${var.project_name}-alb-sg"
  description = "Security group for Application Load Balancer"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS from anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, {
    Name = "${var.environment}-${var.project_name}-alb-sg"
  })
}

resource "aws_security_group" "app" {
  name        = "${var.environment}-${var.project_name}-app-sg"
  description = "Security group for application servers"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "HTTP from ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = var.enable_alb ? [aws_security_group.alb[0].id] : []
  }

  ingress {
    description     = "HTTPS from ALB"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = var.enable_alb ? [aws_security_group.alb[0].id] : []
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, {
    Name = "${var.environment}-${var.project_name}-app-sg"
  })
}

# CloudWatch Log Groups
resource "aws_cloudwatch_log_group" "main" {
  name              = "/aws/${var.environment}/${var.project_name}"
  retention_in_days = var.log_retention_days

  tags = merge(var.common_tags, {
    Name = "${var.environment}-${var.project_name}-log-group"
  })
}

# S3 Bucket for ALB Logs
resource "aws_s3_bucket" "alb_logs" {
  count  = var.enable_alb_logs ? 1 : 0
  bucket = "${var.environment}-${var.project_name}-alb-logs-${data.aws_caller_identity.current.account_id}"

  tags = merge(var.common_tags, {
    Name = "${var.environment}-${var.project_name}-alb-logs"
  })
}

resource "aws_s3_bucket_versioning" "alb_logs" {
  count  = var.enable_alb_logs ? 1 : 0
  bucket = aws_s3_bucket.alb_logs[0].id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "alb_logs" {
  count  = var.enable_alb_logs ? 1 : 0
  bucket = aws_s3_bucket.alb_logs[0].id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "alb_logs" {
  count  = var.enable_alb_logs ? 1 : 0
  bucket = aws_s3_bucket.alb_logs[0].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# ALB Logging Configuration
resource "aws_lb" "main_with_logging" {
  count              = var.enable_alb && var.enable_alb_logs ? 1 : 0
  name               = "${var.environment}-${var.project_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb[0].id]
  subnets            = aws_subnet.public[*].id

  enable_deletion_protection = var.alb_enable_deletion_protection

  access_logs {
    bucket  = aws_s3_bucket.alb_logs[0].bucket
    prefix  = "alb-logs"
    enabled = true
  }

  tags = merge(var.common_tags, {
    Name = "${var.environment}-${var.project_name}-alb"
  })
} 