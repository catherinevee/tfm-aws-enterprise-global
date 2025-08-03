

# Data sources for current AWS account and region
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# VPC and Networking Resources
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = var.enable_dns_hostnames  # Default: true - Enables DNS hostnames for instances
  enable_dns_support   = var.enable_dns_support    # Default: true - Enables DNS support for the VPC
  assign_generated_ipv6_cidr_block = var.assign_generated_ipv6_cidr_block  # Default: false - Assigns IPv6 CIDR block
  ipv6_cidr_block      = var.ipv6_cidr_block      # Default: null - Custom IPv6 CIDR block
  ipv6_cidr_block_network_border_group = var.ipv6_cidr_block_network_border_group  # Default: null - Network border group for IPv6

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

  map_public_ip_on_launch = var.public_subnet_map_public_ip_on_launch  # Default: true - Auto-assign public IPs
  assign_ipv6_address_on_creation = var.public_subnet_assign_ipv6_address_on_creation  # Default: false - Auto-assign IPv6 addresses
  ipv6_cidr_block = var.public_subnet_ipv6_cidr_blocks != null ? var.public_subnet_ipv6_cidr_blocks[count.index] : null  # Default: null - IPv6 CIDR block

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

  map_public_ip_on_launch = var.private_subnet_map_public_ip_on_launch  # Default: false - Don't auto-assign public IPs
  assign_ipv6_address_on_creation = var.private_subnet_assign_ipv6_address_on_creation  # Default: false - Auto-assign IPv6 addresses
  ipv6_cidr_block = var.private_subnet_ipv6_cidr_blocks != null ? var.private_subnet_ipv6_cidr_blocks[count.index] : null  # Default: null - IPv6 CIDR block

  tags = merge(var.common_tags, {
    Name = "${var.environment}-${var.project_name}-private-${var.availability_zones[count.index]}"
    Tier = "Private"
  })
}

# NAT Gateway
resource "aws_eip" "nat" {
  count = var.enable_nat_gateway ? 1 : 0
  domain = "vpc"  # Default: vpc - EIP domain type

  tags = merge(var.common_tags, {
    Name = "${var.environment}-${var.project_name}-nat-eip"
  })
}

resource "aws_nat_gateway" "main" {
  count         = var.enable_nat_gateway ? 1 : 0
  allocation_id = aws_eip.nat[0].id
  subnet_id     = aws_subnet.public[0].id  # Default: First public subnet - NAT Gateway placement

  tags = merge(var.common_tags, {
    Name = "${var.environment}-${var.project_name}-nat-gateway"
  })

  depends_on = [aws_internet_gateway.main]
}

# Route Tables
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"  # Default: 0.0.0.0/0 - Route all traffic to Internet Gateway
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
      cidr_block     = "0.0.0.0/0"  # Default: 0.0.0.0/0 - Route all traffic to NAT Gateway
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

  default_route_table_association = var.transit_gateway_default_route_table_association  # Default: enable - Enable default route table association
  default_route_table_propagation = var.transit_gateway_default_route_table_propagation  # Default: enable - Enable default route table propagation
  amazon_side_asn                 = var.transit_gateway_asn  # Default: 64512 - Amazon side ASN
  auto_accept_shared_attachments  = var.transit_gateway_auto_accept_shared_attachments  # Default: disable - Auto-accept shared attachments
  dns_support                     = var.transit_gateway_dns_support  # Default: enable - Enable DNS support
  vpn_ecmp_support                = var.transit_gateway_vpn_ecmp_support  # Default: enable - Enable VPN ECMP support
  multicast_support               = var.transit_gateway_multicast_support  # Default: disable - Enable multicast support

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
  amazon_side_asn = 64512
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
  internal           = var.alb_internal  # Default: false - Internet-facing load balancer
  load_balancer_type = var.alb_load_balancer_type  # Default: application - Application Load Balancer type
  security_groups    = [aws_security_group.alb[0].id]
  subnets            = aws_subnet.public[*].id

  enable_deletion_protection = var.alb_enable_deletion_protection  # Default: false - Enable deletion protection
  enable_cross_zone_load_balancing = var.alb_enable_cross_zone_load_balancing  # Default: true - Enable cross-zone load balancing
  enable_http2 = var.alb_enable_http2  # Default: true - Enable HTTP/2
  idle_timeout = var.alb_idle_timeout  # Default: 60 - Idle timeout in seconds

  tags = merge(var.common_tags, {
    Name = var.alb_name != null ? var.alb_name : "${var.environment}-${var.project_name}-alb"
  })
}

# ALB Target Group
resource "aws_lb_target_group" "main" {
  count    = var.enable_alb ? 1 : 0
  name     = "${var.environment}-${var.project_name}-tg"
  port     = var.target_group_port  # Default: 80 - Target port
  protocol = var.target_group_protocol  # Default: HTTP - Target protocol
  vpc_id   = aws_vpc.main.id

  health_check {
    enabled             = var.target_group_health_check_enabled  # Default: true - Enable health checks
    healthy_threshold   = var.target_group_healthy_threshold  # Default: 2 - Healthy threshold count
    interval            = var.target_group_health_check_interval  # Default: 30 - Health check interval in seconds
    matcher             = var.target_group_health_check_matcher  # Default: 200 - Health check matcher
    path                = var.target_group_health_check_path  # Default: /health - Health check path
    port                = "traffic-port"  # Default: traffic-port - Health check port
    protocol            = var.target_group_health_check_protocol  # Default: HTTP - Health check protocol
    timeout             = var.target_group_health_check_timeout  # Default: 5 - Health check timeout in seconds
    unhealthy_threshold = var.target_group_unhealthy_threshold  # Default: 2 - Unhealthy threshold count
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
  enabled             = var.cloudfront_enabled  # Default: true - Enable the distribution
  is_ipv6_enabled     = var.cloudfront_is_ipv6_enabled  # Default: true - Enable IPv6 support
  default_root_object = var.cloudfront_default_root_object  # Default: index.html - Default root object
  price_class         = var.cloudfront_price_class  # Default: PriceClass_100 - Price class for edge locations

  origin {
    domain_name = var.enable_alb ? aws_lb.main[0].dns_name : var.origin_domain_name
    origin_id   = var.cloudfront_origin_id  # Default: ALB-Origin - Origin identifier

    custom_origin_config {
      http_port              = var.cloudfront_origin_http_port  # Default: 80 - HTTP port
      https_port             = var.cloudfront_origin_https_port  # Default: 443 - HTTPS port
      origin_protocol_policy = var.cloudfront_origin_protocol_policy  # Default: http-only - Origin protocol policy
      origin_ssl_protocols   = var.cloudfront_origin_ssl_protocols  # Default: ["TLSv1.2"] - SSL protocols
    }
  }

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]  # Default: All HTTP methods
    cached_methods   = ["GET", "HEAD"]  # Default: GET, HEAD - Cached methods
    target_origin_id = var.cloudfront_origin_id  # Default: ALB-Origin - Target origin

    forwarded_values {
      query_string = false  # Default: false - Forward query strings
      cookies {
        forward = "none"  # Default: none - Forward cookies
      }
    }

    viewer_protocol_policy = "redirect-to-https"  # Default: redirect-to-https - Viewer protocol policy
    min_ttl                = 0  # Default: 0 - Minimum TTL in seconds
    default_ttl            = 3600  # Default: 3600 - Default TTL in seconds
    max_ttl                = 86400  # Default: 86400 - Maximum TTL in seconds
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"  # Default: none - Geo restriction type
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true  # Default: true - Use CloudFront default certificate
  }

  tags = merge(var.common_tags, {
    Name = "${var.environment}-${var.project_name}-cloudfront"
  })
}

# WAF Web ACL
resource "aws_wafv2_web_acl" "main" {
  count = var.enable_waf ? 1 : 0
  name  = var.waf_web_acl_name != null ? var.waf_web_acl_name : "${var.environment}-${var.project_name}-web-acl"
  scope = var.waf_web_acl_scope  # Default: REGIONAL - WAF scope (REGIONAL or CLOUDFRONT)

  default_action {
    allow {}  # Default: allow - Default action for unmatched requests
  }

  rule {
    name     = "AWSManagedRulesCommonRuleSet"
    priority = 1

    override_action {
      none {}  # Default: none - No override action
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true  # Default: true - Enable CloudWatch metrics
      metric_name                = "AWSManagedRulesCommonRuleSetMetric"
      sampled_requests_enabled   = true  # Default: true - Enable sampled requests
    }
  }

  rule {
    name     = "AWSManagedRulesKnownBadInputsRuleSet"
    priority = 2

    override_action {
      none {}  # Default: none - No override action
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true  # Default: true - Enable CloudWatch metrics
      metric_name                = "AWSManagedRulesKnownBadInputsRuleSetMetric"
      sampled_requests_enabled   = true  # Default: true - Enable sampled requests
    }
  }

  rule {
    name     = "RateLimitRule"
    priority = 3

    action {
      block {}  # Default: block - Block action for rate limit violations
    }

    statement {
      rate_based_statement {
        limit              = 2000  # Default: 2000 - Rate limit per 5 minutes
        aggregate_key_type = "IP"  # Default: IP - Aggregate by IP address
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true  # Default: true - Enable CloudWatch metrics
      metric_name                = "RateLimitRuleMetric"
      sampled_requests_enabled   = true  # Default: true - Enable sampled requests
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true  # Default: true - Enable CloudWatch metrics
    metric_name                = "WebACLMetric"
    sampled_requests_enabled   = true  # Default: true - Enable sampled requests
  }

  tags = merge(var.common_tags, {
    Name = var.waf_web_acl_name != null ? var.waf_web_acl_name : "${var.environment}-${var.project_name}-web-acl"
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
  name        = var.alb_security_group_name != null ? var.alb_security_group_name : "${var.environment}-${var.project_name}-alb-sg"
  description = var.alb_security_group_description != null ? var.alb_security_group_description : "Security group for Application Load Balancer"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80  # Default: 80 - HTTP port
    to_port     = 80  # Default: 80 - HTTP port
    protocol    = "tcp"  # Default: tcp - TCP protocol
    cidr_blocks = ["0.0.0.0/0"]  # Default: 0.0.0.0/0 - Allow from anywhere
  }

  ingress {
    description = "HTTPS from anywhere"
    from_port   = 443  # Default: 443 - HTTPS port
    to_port     = 443  # Default: 443 - HTTPS port
    protocol    = "tcp"  # Default: tcp - TCP protocol
    cidr_blocks = ["0.0.0.0/0"]  # Default: 0.0.0.0/0 - Allow from anywhere
  }

  egress {
    from_port   = 0  # Default: 0 - All ports
    to_port     = 0  # Default: 0 - All ports
    protocol    = "-1"  # Default: -1 - All protocols
    cidr_blocks = ["0.0.0.0/0"]  # Default: 0.0.0.0/0 - Allow to anywhere
  }

  tags = merge(var.common_tags, {
    Name = var.alb_security_group_name != null ? var.alb_security_group_name : "${var.environment}-${var.project_name}-alb-sg"
  })
}

resource "aws_security_group" "app" {
  name        = var.app_security_group_name != null ? var.app_security_group_name : "${var.environment}-${var.project_name}-app-sg"
  description = var.app_security_group_description != null ? var.app_security_group_description : "Security group for application servers"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "HTTP from ALB"
    from_port       = 80  # Default: 80 - HTTP port
    to_port         = 80  # Default: 80 - HTTP port
    protocol        = "tcp"  # Default: tcp - TCP protocol
    security_groups = var.enable_alb ? [aws_security_group.alb[0].id] : []  # Default: ALB security group - Allow from ALB only
  }

  ingress {
    description     = "HTTPS from ALB"
    from_port       = 443  # Default: 443 - HTTPS port
    to_port         = 443  # Default: 443 - HTTPS port
    protocol        = "tcp"  # Default: tcp - TCP protocol
    security_groups = var.enable_alb ? [aws_security_group.alb[0].id] : []  # Default: ALB security group - Allow from ALB only
  }

  egress {
    from_port   = 0  # Default: 0 - All ports
    to_port     = 0  # Default: 0 - All ports
    protocol    = "-1"  # Default: -1 - All protocols
    cidr_blocks = ["0.0.0.0/0"]  # Default: 0.0.0.0/0 - Allow to anywhere
  }

  tags = merge(var.common_tags, {
    Name = var.app_security_group_name != null ? var.app_security_group_name : "${var.environment}-${var.project_name}-app-sg"
  })
}

# CloudWatch Log Groups
resource "aws_cloudwatch_log_group" "main" {
  name              = var.cloudwatch_log_group_name != null ? var.cloudwatch_log_group_name : "/aws/${var.environment}/${var.project_name}"
  retention_in_days = var.log_retention_days  # Default: 30 - Log retention period in days

  tags = merge(var.common_tags, {
    Name = "${var.environment}-${var.project_name}-log-group"
  })
}

# S3 Bucket for ALB Logs
resource "aws_s3_bucket" "alb_logs" {
  count  = var.enable_alb_logs ? 1 : 0
  bucket = var.alb_logs_bucket_name != null ? var.alb_logs_bucket_name : "${var.environment}-${var.project_name}-alb-logs-${data.aws_caller_identity.current.account_id}"

  tags = merge(var.common_tags, {
    Name = "${var.environment}-${var.project_name}-alb-logs"
  })
}

resource "aws_s3_bucket_versioning" "alb_logs" {
  count  = var.enable_alb_logs ? 1 : 0
  bucket = aws_s3_bucket.alb_logs[0].id
  versioning_configuration {
    status = var.alb_logs_bucket_versioning  # Default: Enabled - Bucket versioning status
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "alb_logs" {
  count  = var.enable_alb_logs ? 1 : 0
  bucket = aws_s3_bucket.alb_logs[0].id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = var.alb_logs_bucket_encryption  # Default: AES256 - Server-side encryption algorithm
    }
  }
}

resource "aws_s3_bucket_public_access_block" "alb_logs" {
  count  = var.enable_alb_logs ? 1 : 0
  bucket = aws_s3_bucket.alb_logs[0].id

  block_public_acls       = true  # Default: true - Block public ACLs
  block_public_policy     = true  # Default: true - Block public bucket policies
  ignore_public_acls      = true  # Default: true - Ignore public ACLs
  restrict_public_buckets = true  # Default: true - Restrict public bucket access
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