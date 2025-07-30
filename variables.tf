# VPC and Networking Variables
variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.11.0/24"]
}

variable "availability_zones" {
  description = "Availability zones for subnets"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "enable_dns_hostnames" {
  description = "Enable DNS hostnames in the VPC"
  type        = bool
  default     = true
}

variable "enable_dns_support" {
  description = "Enable DNS support in the VPC"
  type        = bool
  default     = true
}

variable "enable_classiclink" {
  description = "Enable ClassicLink for the VPC"
  type        = bool
  default     = false
}

variable "enable_classiclink_dns_support" {
  description = "Enable ClassicLink DNS support for the VPC"
  type        = bool
  default     = false
}

variable "assign_generated_ipv6_cidr_block" {
  description = "Assign generated IPv6 CIDR block to the VPC"
  type        = bool
  default     = false
}

variable "ipv6_cidr_block" {
  description = "IPv6 CIDR block for the VPC"
  type        = string
  default     = null
}

variable "ipv6_cidr_block_network_border_group" {
  description = "IPv6 CIDR block network border group"
  type        = string
  default     = null
}

variable "enable_nat_gateway" {
  description = "Enable NAT Gateway for private subnets"
  type        = bool
  default     = true
}

variable "nat_gateway_single_az_only" {
  description = "Create NAT Gateway in single AZ only (cost optimization)"
  type        = bool
  default     = false
}

variable "nat_gateway_connectivity_type" {
  description = "NAT Gateway connectivity type (private or public)"
  type        = string
  default     = "public"
  validation {
    condition     = contains(["private", "public"], var.nat_gateway_connectivity_type)
    error_message = "NAT Gateway connectivity type must be either 'private' or 'public'."
  }
}

# Subnet Customization
variable "public_subnet_map_public_ip_on_launch" {
  description = "Map public IP on launch for public subnets"
  type        = bool
  default     = true
}

variable "private_subnet_map_public_ip_on_launch" {
  description = "Map public IP on launch for private subnets"
  type        = bool
  default     = false
}

variable "public_subnet_assign_ipv6_address_on_creation" {
  description = "Assign IPv6 address on creation for public subnets"
  type        = bool
  default     = false
}

variable "private_subnet_assign_ipv6_address_on_creation" {
  description = "Assign IPv6 address on creation for private subnets"
  type        = bool
  default     = false
}

variable "public_subnet_ipv6_cidr_blocks" {
  description = "IPv6 CIDR blocks for public subnets"
  type        = list(string)
  default     = []
}

variable "private_subnet_ipv6_cidr_blocks" {
  description = "IPv6 CIDR blocks for private subnets"
  type        = list(string)
  default     = []
}

# Transit Gateway Variables
variable "transit_gateway_asn" {
  description = "ASN for Transit Gateway"
  type        = number
  default     = 64512
}

variable "transit_gateway_auto_accept_shared_attachments" {
  description = "Auto accept shared attachments for Transit Gateway"
  type        = string
  default     = "disable"
  validation {
    condition     = contains(["disable", "enable"], var.transit_gateway_auto_accept_shared_attachments)
    error_message = "Transit Gateway auto accept shared attachments must be either 'disable' or 'enable'."
  }
}

variable "transit_gateway_default_route_table_association" {
  description = "Default route table association for Transit Gateway"
  type        = string
  default     = "enable"
  validation {
    condition     = contains(["disable", "enable"], var.transit_gateway_default_route_table_association)
    error_message = "Transit Gateway default route table association must be either 'disable' or 'enable'."
  }
}

variable "transit_gateway_default_route_table_propagation" {
  description = "Default route table propagation for Transit Gateway"
  type        = string
  default     = "enable"
  validation {
    condition     = contains(["disable", "enable"], var.transit_gateway_default_route_table_propagation)
    error_message = "Transit Gateway default route table propagation must be either 'disable' or 'enable'."
  }
}

variable "transit_gateway_dns_support" {
  description = "DNS support for Transit Gateway"
  type        = string
  default     = "enable"
  validation {
    condition     = contains(["disable", "enable"], var.transit_gateway_dns_support)
    error_message = "Transit Gateway DNS support must be either 'disable' or 'enable'."
  }
}

variable "transit_gateway_vpn_ecmp_support" {
  description = "VPN ECMP support for Transit Gateway"
  type        = string
  default     = "enable"
  validation {
    condition     = contains(["disable", "enable"], var.transit_gateway_vpn_ecmp_support)
    error_message = "Transit Gateway VPN ECMP support must be either 'disable' or 'enable'."
  }
}

variable "transit_gateway_multicast_support" {
  description = "Multicast support for Transit Gateway"
  type        = string
  default     = "disable"
  validation {
    condition     = contains(["disable", "enable"], var.transit_gateway_multicast_support)
    error_message = "Transit Gateway multicast support must be either 'disable' or 'enable'."
  }
}

# Transit Gateway VPC Attachment
variable "transit_gateway_vpc_attachment_appliance_mode_support" {
  description = "Appliance mode support for Transit Gateway VPC attachment"
  type        = string
  default     = "disable"
  validation {
    condition     = contains(["disable", "enable"], var.transit_gateway_vpc_attachment_appliance_mode_support)
    error_message = "Transit Gateway VPC attachment appliance mode support must be either 'disable' or 'enable'."
  }
}

variable "transit_gateway_vpc_attachment_dns_support" {
  description = "DNS support for Transit Gateway VPC attachment"
  type        = string
  default     = "enable"
  validation {
    condition     = contains(["disable", "enable"], var.transit_gateway_vpc_attachment_dns_support)
    error_message = "Transit Gateway VPC attachment DNS support must be either 'disable' or 'enable'."
  }
}

variable "transit_gateway_vpc_attachment_ipv6_support" {
  description = "IPv6 support for Transit Gateway VPC attachment"
  type        = string
  default     = "disable"
  validation {
    condition     = contains(["disable", "enable"], var.transit_gateway_vpc_attachment_ipv6_support)
    error_message = "Transit Gateway VPC attachment IPv6 support must be either 'disable' or 'enable'."
  }
}

# Direct Connect Variables
variable "enable_direct_connect" {
  description = "Enable Direct Connect"
  type        = bool
  default     = false
}

variable "direct_connect_allowed_prefixes" {
  description = "Allowed prefixes for Direct Connect"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "direct_connect_gateway_name" {
  description = "Name for the Direct Connect Gateway"
  type        = string
  default     = null
}

# VPN Variables
variable "enable_vpn" {
  description = "Enable VPN connections"
  type        = bool
  default     = false
}

variable "vpn_connections" {
  description = "List of VPN connection configurations"
  type = list(object({
    customer_ip           = string
    bgp_asn              = number
    destination_cidr     = string
    static_routes_only   = bool
    tunnel_inside_ip_version = optional(string, "ipv4")
    tunnel_inside_cidr   = optional(string, "169.254.0.0/16")
    tunnel_inside_ipv6_cidr = optional(string, null)
    enable_acceleration = optional(bool, false)
    local_ipv4_network_cidr = optional(string, null)
    remote_ipv4_network_cidr = optional(string, null)
    local_ipv6_network_cidr = optional(string, null)
    remote_ipv6_network_cidr = optional(string, null)
    outside_ip_address_type = optional(string, "PublicIpv4")
    transport_transit_gateway_attachment_id = optional(string, null)
  }))
  default = []
}

# Load Balancer Variables
variable "enable_alb" {
  description = "Enable Application Load Balancer"
  type        = bool
  default     = true
}

variable "alb_name" {
  description = "Name for the Application Load Balancer"
  type        = string
  default     = null
}

variable "alb_internal" {
  description = "Whether the ALB is internal or internet-facing"
  type        = bool
  default     = false
}

variable "alb_load_balancer_type" {
  description = "Type of load balancer"
  type        = string
  default     = "application"
  validation {
    condition     = contains(["application", "network", "gateway"], var.alb_load_balancer_type)
    error_message = "Load balancer type must be one of: application, network, gateway."
  }
}

variable "alb_enable_deletion_protection" {
  description = "Enable deletion protection for ALB"
  type        = bool
  default     = false
}

variable "alb_enable_cross_zone_load_balancing" {
  description = "Enable cross-zone load balancing for ALB"
  type        = bool
  default     = true
}

variable "alb_enable_http2" {
  description = "Enable HTTP/2 for ALB"
  type        = bool
  default     = true
}

variable "alb_idle_timeout" {
  description = "Idle timeout for ALB in seconds"
  type        = number
  default     = 60
  validation {
    condition     = var.alb_idle_timeout >= 1 && var.alb_idle_timeout <= 4000
    error_message = "ALB idle timeout must be between 1 and 4000 seconds."
  }
}

variable "alb_desync_mitigation_mode" {
  description = "Desync mitigation mode for ALB"
  type        = string
  default     = "defensive"
  validation {
    condition     = contains(["defensive", "strictest", "monitor"], var.alb_desync_mitigation_mode)
    error_message = "ALB desync mitigation mode must be one of: defensive, strictest, monitor."
  }
}

variable "alb_drop_invalid_header_fields" {
  description = "Drop invalid header fields for ALB"
  type        = bool
  default     = false
}

variable "alb_preserve_host_header" {
  description = "Preserve host header for ALB"
  type        = bool
  default     = false
}

variable "alb_xff_header_processing_mode" {
  description = "XFF header processing mode for ALB"
  type        = string
  default     = "append"
  validation {
    condition     = contains(["append", "preserve", "remove"], var.alb_xff_header_processing_mode)
    error_message = "ALB XFF header processing mode must be one of: append, preserve, remove."
  }
}

variable "alb_xff_client_port" {
  description = "XFF client port for ALB"
  type        = bool
  default     = false
}

# ALB Target Group Variables
variable "target_group_name" {
  description = "Name for the target group"
  type        = string
  default     = null
}

variable "target_group_port" {
  description = "Port for the target group"
  type        = number
  default     = 80
}

variable "target_group_protocol" {
  description = "Protocol for the target group"
  type        = string
  default     = "HTTP"
  validation {
    condition     = contains(["HTTP", "HTTPS", "TCP", "TLS", "UDP", "TCP_UDP", "GENEVE"], var.target_group_protocol)
    error_message = "Target group protocol must be one of: HTTP, HTTPS, TCP, TLS, UDP, TCP_UDP, GENEVE."
  }
}

variable "target_group_protocol_version" {
  description = "Protocol version for the target group"
  type        = string
  default     = "HTTP1"
  validation {
    condition     = contains(["HTTP1", "HTTP2", "GRPC"], var.target_group_protocol_version)
    error_message = "Target group protocol version must be one of: HTTP1, HTTP2, GRPC."
  }
}

variable "target_group_target_type" {
  description = "Target type for the target group"
  type        = string
  default     = "ip"
  validation {
    condition     = contains(["instance", "ip", "lambda", "alb"], var.target_group_target_type)
    error_message = "Target group target type must be one of: instance, ip, lambda, alb."
  }
}

variable "target_group_vpc_id" {
  description = "VPC ID for the target group (if not using module VPC)"
  type        = string
  default     = null
}

variable "target_group_health_check_enabled" {
  description = "Enable health checks for target group"
  type        = bool
  default     = true
}

variable "target_group_health_check_interval" {
  description = "Health check interval in seconds"
  type        = number
  default     = 30
  validation {
    condition     = var.target_group_health_check_interval >= 5 && var.target_group_health_check_interval <= 300
    error_message = "Health check interval must be between 5 and 300 seconds."
  }
}

variable "target_group_health_check_path" {
  description = "Health check path"
  type        = string
  default     = "/health"
}

variable "target_group_health_check_port" {
  description = "Health check port"
  type        = string
  default     = "traffic-port"
}

variable "target_group_health_check_protocol" {
  description = "Health check protocol"
  type        = string
  default     = "HTTP"
  validation {
    condition     = contains(["HTTP", "HTTPS", "TCP", "TLS", "UDP", "TCP_UDP"], var.target_group_health_check_protocol)
    error_message = "Health check protocol must be one of: HTTP, HTTPS, TCP, TLS, UDP, TCP_UDP."
  }
}

variable "target_group_health_check_timeout" {
  description = "Health check timeout in seconds"
  type        = number
  default     = 5
  validation {
    condition     = var.target_group_health_check_timeout >= 2 && var.target_group_health_check_timeout <= 120
    error_message = "Health check timeout must be between 2 and 120 seconds."
  }
}

variable "target_group_healthy_threshold" {
  description = "Healthy threshold count"
  type        = number
  default     = 2
  validation {
    condition     = var.target_group_healthy_threshold >= 2 && var.target_group_healthy_threshold <= 10
    error_message = "Healthy threshold must be between 2 and 10."
  }
}

variable "target_group_unhealthy_threshold" {
  description = "Unhealthy threshold count"
  type        = number
  default     = 2
  validation {
    condition     = var.target_group_unhealthy_threshold >= 2 && var.target_group_unhealthy_threshold <= 10
    error_message = "Unhealthy threshold must be between 2 and 10."
  }
}

variable "target_group_health_check_matcher" {
  description = "Health check matcher (HTTP codes)"
  type        = string
  default     = "200"
}

variable "target_group_health_check_success_codes" {
  description = "Health check success codes"
  type        = string
  default     = null
}

variable "target_group_stickiness_enabled" {
  description = "Enable stickiness for target group"
  type        = bool
  default     = false
}

variable "target_group_stickiness_type" {
  description = "Stickiness type for target group"
  type        = string
  default     = "lb_cookie"
  validation {
    condition     = contains(["lb_cookie", "app_cookie"], var.target_group_stickiness_type)
    error_message = "Stickiness type must be either 'lb_cookie' or 'app_cookie'."
  }
}

variable "target_group_stickiness_cookie_duration" {
  description = "Stickiness cookie duration in seconds"
  type        = number
  default     = 86400
  validation {
    condition     = var.target_group_stickiness_cookie_duration >= 1 && var.target_group_stickiness_cookie_duration <= 604800
    error_message = "Stickiness cookie duration must be between 1 and 604800 seconds."
  }
}

variable "target_group_stickiness_cookie_name" {
  description = "Stickiness cookie name"
  type        = string
  default     = null
}

# ALB Listener Variables
variable "alb_listener_port" {
  description = "Port for ALB listener"
  type        = number
  default     = 80
  validation {
    condition     = var.alb_listener_port >= 1 && var.alb_listener_port <= 65535
    error_message = "ALB listener port must be between 1 and 65535."
  }
}

variable "alb_listener_protocol" {
  description = "Protocol for ALB listener"
  type        = string
  default     = "HTTP"
  validation {
    condition     = contains(["HTTP", "HTTPS", "TCP", "TLS", "UDP", "TCP_UDP"], var.alb_listener_protocol)
    error_message = "ALB listener protocol must be one of: HTTP, HTTPS, TCP, TLS, UDP, TCP_UDP."
  }
}

variable "alb_listener_ssl_policy" {
  description = "SSL policy for HTTPS listener"
  type        = string
  default     = "ELBSecurityPolicy-TLS-1-2-2017-01"
}

variable "alb_listener_certificate_arn" {
  description = "Certificate ARN for HTTPS listener"
  type        = string
  default     = null
}

variable "alb_listener_default_action_type" {
  description = "Default action type for ALB listener"
  type        = string
  default     = "forward"
  validation {
    condition     = contains(["forward", "redirect", "fixed-response", "authenticate-cognito", "authenticate-oidc"], var.alb_listener_default_action_type)
    error_message = "ALB listener default action type must be one of: forward, redirect, fixed-response, authenticate-cognito, authenticate-oidc."
  }
}

variable "alb_listener_redirect_config" {
  description = "Redirect configuration for ALB listener"
  type = object({
    status_code = string
    protocol    = optional(string, "#{protocol}")
    port        = optional(string, "#{port}")
    host        = optional(string, "#{host}")
    path        = optional(string, "/#{path}")
    query       = optional(string, "#{query}")
  })
  default = null
}

variable "alb_listener_fixed_response_config" {
  description = "Fixed response configuration for ALB listener"
  type = object({
    content_type = string
    message_body = optional(string, null)
    status_code  = optional(string, "200")
  })
  default = null
}

# CloudFront Variables
variable "enable_cloudfront" {
  description = "Enable CloudFront distribution"
  type        = bool
  default     = false
}

variable "cloudfront_price_class" {
  description = "CloudFront price class"
  type        = string
  default     = "PriceClass_100"
  validation {
    condition     = contains(["PriceClass_100", "PriceClass_200", "PriceClass_All"], var.cloudfront_price_class)
    error_message = "CloudFront price class must be one of: PriceClass_100, PriceClass_200, PriceClass_All."
  }
}

variable "origin_domain_name" {
  description = "Origin domain name for CloudFront (used when ALB is disabled)"
  type        = string
  default     = ""
}

variable "cloudfront_origin_id" {
  description = "Origin ID for CloudFront"
  type        = string
  default     = "ALB-Origin"
}

variable "cloudfront_origin_protocol_policy" {
  description = "Origin protocol policy for CloudFront"
  type        = string
  default     = "http-only"
  validation {
    condition     = contains(["http-only", "https-only", "match-viewer"], var.cloudfront_origin_protocol_policy)
    error_message = "CloudFront origin protocol policy must be one of: http-only, https-only, match-viewer."
  }
}

variable "cloudfront_origin_ssl_protocols" {
  description = "Origin SSL protocols for CloudFront"
  type        = list(string)
  default     = ["TLSv1.2"]
  validation {
    condition = alltrue([
      for protocol in var.cloudfront_origin_ssl_protocols : 
      contains(["SSLv3", "TLSv1", "TLSv1.1", "TLSv1.2"], protocol)
    ])
    error_message = "CloudFront origin SSL protocols must be one of: SSLv3, TLSv1, TLSv1.1, TLSv1.2."
  }
}

variable "cloudfront_origin_http_port" {
  description = "Origin HTTP port for CloudFront"
  type        = number
  default     = 80
}

variable "cloudfront_origin_https_port" {
  description = "Origin HTTPS port for CloudFront"
  type        = number
  default     = 443
}

variable "cloudfront_origin_keepalive_timeout" {
  description = "Origin keepalive timeout for CloudFront"
  type        = number
  default     = 5
}

variable "cloudfront_origin_read_timeout" {
  description = "Origin read timeout for CloudFront"
  type        = number
  default     = 30
}

variable "cloudfront_origin_connection_timeout" {
  description = "Origin connection timeout for CloudFront"
  type        = number
  default     = 10
}

variable "cloudfront_origin_connection_attempts" {
  description = "Origin connection attempts for CloudFront"
  type        = number
  default     = 3
}

variable "cloudfront_origin_shield_region" {
  description = "Origin shield region for CloudFront"
  type        = string
  default     = null
}

variable "cloudfront_origin_shield_enabled" {
  description = "Enable origin shield for CloudFront"
  type        = bool
  default     = false
}

variable "cloudfront_default_root_object" {
  description = "Default root object for CloudFront"
  type        = string
  default     = "index.html"
}

variable "cloudfront_enabled" {
  description = "Enable CloudFront distribution"
  type        = bool
  default     = true
}

variable "cloudfront_is_ipv6_enabled" {
  description = "Enable IPv6 for CloudFront"
  type        = bool
  default     = true
}

variable "cloudfront_http_version" {
  description = "HTTP version for CloudFront"
  type        = string
  default     = "http2"
  validation {
    condition     = contains(["http1.1", "http2", "http3"], var.cloudfront_http_version)
    error_message = "CloudFront HTTP version must be one of: http1.1, http2, http3."
  }
}

variable "cloudfront_aliases" {
  description = "Aliases for CloudFront distribution"
  type        = list(string)
  default     = []
}

variable "cloudfront_web_acl_id" {
  description = "WAF Web ACL ID for CloudFront"
  type        = string
  default     = null
}

variable "cloudfront_viewer_certificate" {
  description = "Viewer certificate configuration for CloudFront"
  type = object({
    cloudfront_default_certificate = optional(bool, true)
    acm_certificate_arn           = optional(string, null)
    ssl_support_method            = optional(string, "sni-only")
    minimum_protocol_version      = optional(string, "TLSv1")
    certificate_source            = optional(string, "cloudfront")
  })
  default = {
    cloudfront_default_certificate = true
  }
}

variable "cloudfront_cache_behavior" {
  description = "Cache behavior configuration for CloudFront"
  type = object({
    allowed_methods  = optional(list(string), ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"])
    cached_methods   = optional(list(string), ["GET", "HEAD"])
    target_origin_id = optional(string, "ALB-Origin")
    compress         = optional(bool, true)
    query_string     = optional(bool, false)
    cookies_forward  = optional(string, "none")
    headers_forward  = optional(list(string), [])
    viewer_protocol_policy = optional(string, "redirect-to-https")
    min_ttl         = optional(number, 0)
    default_ttl     = optional(number, 3600)
    max_ttl         = optional(number, 86400)
  })
  default = {}
}

variable "cloudfront_geo_restriction" {
  description = "Geo restriction configuration for CloudFront"
  type = object({
    restriction_type = optional(string, "none")
    locations        = optional(list(string), [])
  })
  default = {
    restriction_type = "none"
  }
}

variable "cloudfront_custom_error_responses" {
  description = "Custom error responses for CloudFront"
  type = list(object({
    error_code            = number
    response_code         = optional(string, null)
    response_page_path    = optional(string, null)
    error_caching_min_ttl = optional(number, 300)
  }))
  default = []
}

# WAF Variables
variable "enable_waf" {
  description = "Enable WAF Web ACL"
  type        = bool
  default     = true
}

variable "waf_web_acl_name" {
  description = "Name for WAF Web ACL"
  type        = string
  default     = null
}

variable "waf_web_acl_scope" {
  description = "Scope for WAF Web ACL"
  type        = string
  default     = "REGIONAL"
  validation {
    condition     = contains(["REGIONAL", "CLOUDFRONT"], var.waf_web_acl_scope)
    error_message = "WAF Web ACL scope must be either 'REGIONAL' or 'CLOUDFRONT'."
  }
}

variable "waf_default_action" {
  description = "Default action for WAF Web ACL"
  type        = string
  default     = "allow"
  validation {
    condition     = contains(["allow", "block"], var.waf_default_action)
    error_message = "WAF default action must be either 'allow' or 'block'."
  }
}

variable "waf_rules" {
  description = "Custom WAF rules"
  type = list(object({
    name     = string
    priority = number
    action   = optional(string, "allow")
    block_action = optional(object({
      custom_response = optional(object({
        response_code = number
        response_header = optional(list(object({
          name  = string
          value = string
        })), [])
      }), null)
    }), null)
    allow_action = optional(object({
      custom_response = optional(object({
        response_code = number
        response_header = optional(list(object({
          name  = string
          value = string
        })), [])
      }), null)
    }), null)
    statement = object({
      managed_rule_group_statement = optional(object({
        name        = string
        vendor_name = string
        rule_action_override = optional(list(object({
          action_to_use = object({
            allow = optional(object({}), null)
            block = optional(object({}), null)
          })
          name = string
        })), [])
      }), null)
      rate_based_statement = optional(object({
        limit              = number
        aggregate_key_type = optional(string, "IP")
        scope_down_statement = optional(object({}), null)
      }), null)
      ip_set_reference_statement = optional(object({
        arn = string
        ip_set_forwarded_ip_config = optional(object({
          header_name                 = string
          fallback_behavior           = string
          position                    = string
        }), null)
      }), null)
    })
    visibility_config = object({
      cloudwatch_metrics_enabled = bool
      metric_name                = string
      sampled_requests_enabled   = bool
    })
  }))
  default = []
}

variable "waf_visibility_config" {
  description = "Visibility configuration for WAF Web ACL"
  type = object({
    cloudwatch_metrics_enabled = optional(bool, true)
    metric_name                = optional(string, "WebACLMetric")
    sampled_requests_enabled   = optional(bool, true)
  })
  default = {}
}

# Shield Variables
variable "enable_shield_advanced" {
  description = "Enable Shield Advanced protection"
  type        = bool
  default     = false
}

variable "shield_protection_name_alb" {
  description = "Name for Shield protection on ALB"
  type        = string
  default     = null
}

variable "shield_protection_name_cloudfront" {
  description = "Name for Shield protection on CloudFront"
  type        = string
  default     = null
}

# Security Group Variables
variable "alb_security_group_name" {
  description = "Name for ALB security group"
  type        = string
  default     = null
}

variable "alb_security_group_description" {
  description = "Description for ALB security group"
  type        = string
  default     = "Security group for Application Load Balancer"
}

variable "alb_security_group_rules" {
  description = "Custom security group rules for ALB"
  type = list(object({
    type        = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = optional(list(string), [])
    security_groups = optional(list(string), [])
    description = optional(string, null)
  }))
  default = []
}

variable "app_security_group_name" {
  description = "Name for application security group"
  type        = string
  default     = null
}

variable "app_security_group_description" {
  description = "Description for application security group"
  type        = string
  default     = "Security group for application servers"
}

variable "app_security_group_rules" {
  description = "Custom security group rules for application servers"
  type = list(object({
    type        = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = optional(list(string), [])
    security_groups = optional(list(string), [])
    description = optional(string, null)
  }))
  default = []
}

# Logging Variables
variable "log_retention_days" {
  description = "CloudWatch log retention in days"
  type        = number
  default     = 30
  validation {
    condition     = contains([1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653], var.log_retention_days)
    error_message = "Log retention days must be one of the allowed values: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653."
  }
}

variable "cloudwatch_log_group_name" {
  description = "Name for CloudWatch log group"
  type        = string
  default     = null
}

variable "cloudwatch_log_group_kms_key_id" {
  description = "KMS key ID for CloudWatch log group encryption"
  type        = string
  default     = null
}

variable "enable_alb_logs" {
  description = "Enable ALB access logs"
  type        = bool
  default     = true
}

variable "alb_logs_bucket_name" {
  description = "Name for S3 bucket storing ALB logs"
  type        = string
  default     = null
}

variable "alb_logs_bucket_prefix" {
  description = "Prefix for ALB logs in S3 bucket"
  type        = string
  default     = "alb-logs"
}

variable "alb_logs_bucket_versioning" {
  description = "Enable versioning for ALB logs S3 bucket"
  type        = bool
  default     = true
}

variable "alb_logs_bucket_encryption" {
  description = "Encryption configuration for ALB logs S3 bucket"
  type = object({
    sse_algorithm = optional(string, "AES256")
    kms_master_key_id = optional(string, null)
  })
  default = {
    sse_algorithm = "AES256"
  }
}

variable "alb_logs_bucket_lifecycle_rules" {
  description = "Lifecycle rules for ALB logs S3 bucket"
  type = list(object({
    id      = string
    enabled = bool
    expiration = optional(object({
      days = number
    }), null)
    noncurrent_version_expiration = optional(object({
      noncurrent_days = number
    }), null)
    abort_incomplete_multipart_upload = optional(object({
      days_after_initiation = number
    }), null)
  }))
  default = []
}

# Common Variables
variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
  validation {
    condition     = contains(["dev", "staging", "prod", "test"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod, test."
  }
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
  default     = "enterprise-global"
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default = {
    Environment = "dev"
    Project     = "enterprise-global"
    ManagedBy   = "terraform"
  }
}

# Additional Customization Variables
variable "enable_flow_logs" {
  description = "Enable VPC Flow Logs"
  type        = bool
  default     = false
}

variable "flow_logs_iam_role_arn" {
  description = "IAM role ARN for VPC Flow Logs"
  type        = string
  default     = null
}

variable "flow_logs_log_destination" {
  description = "Log destination for VPC Flow Logs"
  type        = string
  default     = null
}

variable "flow_logs_log_destination_type" {
  description = "Log destination type for VPC Flow Logs"
  type        = string
  default     = "cloud-watch-logs"
  validation {
    condition     = contains(["cloud-watch-logs", "s3", "kinesis-data-firehose"], var.flow_logs_log_destination_type)
    error_message = "Flow logs log destination type must be one of: cloud-watch-logs, s3, kinesis-data-firehose."
  }
}

variable "flow_logs_traffic_type" {
  description = "Traffic type for VPC Flow Logs"
  type        = string
  default     = "ALL"
  validation {
    condition     = contains(["ACCEPT", "REJECT", "ALL"], var.flow_logs_traffic_type)
    error_message = "Flow logs traffic type must be one of: ACCEPT, REJECT, ALL."
  }
}

variable "flow_logs_max_aggregation_interval" {
  description = "Maximum aggregation interval for VPC Flow Logs"
  type        = number
  default     = 600
  validation {
    condition     = contains([60, 600], var.flow_logs_max_aggregation_interval)
    error_message = "Flow logs max aggregation interval must be either 60 or 600 seconds."
  }
}

variable "enable_vpc_endpoints" {
  description = "Enable VPC endpoints for AWS services"
  type        = bool
  default     = false
}

variable "vpc_endpoints" {
  description = "List of VPC endpoints to create"
  type = list(object({
    service_name = string
    vpc_endpoint_type = optional(string, "Gateway")
    policy = optional(string, null)
    private_dns_enabled = optional(bool, true)
    subnet_ids = optional(list(string), [])
    security_group_ids = optional(list(string), [])
  }))
  default = []
} 