#------------------------------------------------------------------------------
# Misc
#------------------------------------------------------------------------------
variable "name_prefix" {
  description = "Name prefix for resources on AWS. Max length is 15 characters."
  type        = string
  validation {
    condition     = length(var.name_prefix) <= 15
    error_message = "The name prefix must be 15 characters or less."
  }
}

variable "use_random_name_for_lb" {
  description = "If true the LB name will be a random string"
  type        = bool
  default     = false
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Resource tags"
}

#------------------------------------------------------------------------------
# AWS Networking
#------------------------------------------------------------------------------
variable "vpc_id" {
  description = "ID of the VPC"
}

#------------------------------------------------------------------------------
# S3 logs bucket
#------------------------------------------------------------------------------
variable "enable_s3_logs" {
  description = "(Optional) If true, all LoadBalancer logs will be sent to S3.  If true, and log_bucket_id is *not* provided, this module will create the bucket with other provided s3 bucket configuration options"
  type        = bool
  default     = true
}

variable "log_bucket_id" {
  description = "(Optional) if provided, the ID of a previously-defined S3 bucket to send LB logs to."
  type        = string
  default     = null
}

variable "block_s3_bucket_public_access" {
  description = "(Optional) If true, public access to the S3 bucket will be blocked.  Ignored if log_bucket_id is provided."
  type        = bool
  default     = true
}

variable "enable_s3_bucket_server_side_encryption" {
  description = "(Optional) If true, server side encryption will be applied.  Ignored if log_bucket_id is provided."
  type        = bool
  default     = true
}

variable "s3_bucket_server_side_encryption_sse_algorithm" {
  description = "(Optional) The server-side encryption algorithm to use. Valid values are AES256 and aws:kms.   Ignored if log_bucket_id is provided."
  type        = string
  default     = "AES256"
}

variable "s3_bucket_server_side_encryption_key" {
  description = "(Optional) The AWS KMS master key ID used for the SSE-KMS encryption. This can only be used when you set the value of sse_algorithm as aws:kms. The default aws/s3 AWS KMS master key is used if this element is absent while the sse_algorithm is aws:kms.  Ignored if log_bucket_id is provided."
  type        = string
  default     = null
}

variable "access_logs_prefix" {
  description = "(Optional) if access logging to an S3 bucket, this sets a prefix in the bucket beneath which this LB's logs will be organized."
  type        = string
  default     = null
}

#------------------------------------------------------------------------------
# APPLICATION LOAD BALANCER
#------------------------------------------------------------------------------
variable "internal" {
  description = "(Optional) If true, the LB will be internal."
  type        = bool
  default     = false
}

variable "security_groups" {
  description = "(Optional) A list of security group IDs to assign to the LB."
  type        = list(string)
  default     = []
}

variable "drop_invalid_header_fields" {
  description = "(Optional) Indicates whether HTTP headers with header fields that are not valid are removed by the load balancer (true) or routed to targets (false). The default is false. Elastic Load Balancing requires that message header names contain only alphanumeric characters and hyphens."
  type        = bool
  default     = false
}

variable "private_subnets" {
  description = "A list of private subnet IDs to attach to the LB if it is INTERNAL."
  type        = list(string)
}

variable "public_subnets" {
  description = "A list of public subnet IDs to attach to the LB if it is NOT internal."
  type        = list(string)
}

variable "idle_timeout" {
  description = "(Optional) The time in seconds that the connection is allowed to be idle. Default: 60."
  type        = number
  default     = 60
}

variable "enable_deletion_protection" {
  description = "(Optional) If true, deletion of the load balancer will be disabled via the AWS API. This will prevent Terraform from deleting the load balancer. Defaults to false."
  type        = bool
  default     = false
}

variable "enable_cross_zone_load_balancing" {
  description = "(Optional) If true, cross-zone load balancing of the load balancer will be enabled. Defaults to false."
  type        = bool
  default     = false
}

variable "enable_http2" {
  description = "(Optional) Indicates whether HTTP/2 is enabled in the load balancer. Defaults to true."
  type        = bool
  default     = true
}

variable "ip_address_type" {
  description = "(Optional) The type of IP addresses used by the subnets for your load balancer. The possible values are ipv4 and dualstack. Defaults to ipv4"
  type        = string
  default     = "ipv4"
}

variable "waf_web_acl_arn" {
  description = "ARN of a WAFV2 to associate with the ALB"
  type        = string
  default     = ""
}

#------------------------------------------------------------------------------
# ACCESS CONTROL TO APPLICATION LOAD BALANCER
#------------------------------------------------------------------------------
variable "http_ports" {
  description = "Map containing objects to define listeners behaviour based on type field. If type field is `forward`, include listener_port and the target_group_port. For `redirect` type, include listener_port, host, path, port, protocol, query and status_code. For `fixed-response`, include listener_port, content_type, message_body and status_code"
  type = map(object({
    type = optional(string)

    listener_port = number

    target_group_port             = optional(number)
    target_group_protocol         = optional(string, "HTTP")
    target_group_protocol_version = optional(string, "HTTP1") # HTTP1, HTTP2 or GRPC

    # Health check options, overriding default values provided as module variables
    target_group_health_check_enabled             = optional(bool)
    target_group_health_check_interval            = optional(number)
    target_group_health_check_path                = optional(string)
    target_group_health_check_port                = optional(string)
    target_group_health_check_protocol            = optional(string, "HTTP")
    target_group_health_check_timeout             = optional(number)
    target_group_health_check_healthy_threshold   = optional(number)
    target_group_health_check_unhealthy_threshold = optional(number)
    target_group_health_check_matcher             = optional(string)

    host         = optional(string, "#{host}")
    path         = optional(string, "/#{path}")
    port         = optional(string, "#{port}")
    protocol     = optional(string, "#{protocol}")
    query        = optional(string, "#{query}")
    status_code  = optional(string) # Default for `type=redirect`: "HTTP_301". Default for `type=fixed-response`: "200".
    content_type = optional(string, "text/plain")
    message_body = optional(string, "Fixed response content")
  }))
  default = {
    default = {
      type              = "forward"
      listener_port     = 80
      target_group_port = 80
    }
  }
  validation {
    condition     = alltrue([for _, v in var.http_ports : v.type != "forward" || v.target_group_port != null])
    error_message = "target_group_port must be set if type is forward"
  }
  validation {
    condition     = alltrue([for _, v in var.http_ports : (v.type == "redirect" || v.type == "fixed-response") ? v.status_code != null : true])
    error_message = "status_code must be set if type is redirect or fixed-response"
  }
}

variable "https_ports" {
  description = "Map containing objects to define listeners behaviour based on type field. If type field is `forward`, include listener_port and the target_group_port. For `redirect` type, include listener_port, host, path, port, protocol, query and status_code. For `fixed-response`, include listener_port, content_type, message_body and status_code"
  type = map(object({
    type = optional(string)

    listener_port = number

    target_group_port             = optional(number)
    target_group_protocol         = optional(string, "HTTP")
    target_group_protocol_version = optional(string, "HTTP1") # HTTP1, HTTP2 or GRPC

    # Health check options, overriding default values provided as module variables
    target_group_health_check_enabled             = optional(bool)
    target_group_health_check_interval            = optional(number)
    target_group_health_check_path                = optional(string)
    target_group_health_check_port                = optional(string)
    target_group_health_check_protocol            = optional(string, "HTTP")
    target_group_health_check_timeout             = optional(number)
    target_group_health_check_healthy_threshold   = optional(number)
    target_group_health_check_unhealthy_threshold = optional(number)
    target_group_health_check_matcher             = optional(string)

    host         = optional(string, "#{host}")
    path         = optional(string, "/#{path}")
    port         = optional(string, "#{port}")
    protocol     = optional(string, "#{protocol}")
    query        = optional(string, "#{query}")
    status_code  = optional(string) # Default for `type=redirect`: "HTTP_301". Default for `type=fixed-response`: "200".
    content_type = optional(string, "text/plain")
    message_body = optional(string, "Fixed response content")
  }))
  default = {
    default = {
      type              = "forward"
      listener_port     = 443
      target_group_port = 443
    }
  }
  validation {
    condition     = alltrue([for _, v in var.https_ports : v.type != "forward" || v.target_group_port != null])
    error_message = "target_group_port must be set if type is forward"
  }
  validation {
    condition     = alltrue([for _, v in var.https_ports : (v.type == "redirect" || v.type == "fixed-response") ? v.status_code != null : true])
    error_message = "status_code must be set if type is redirect or fixed-response"
  }
}

/*
Other options for listeners (The same are valid also for https_ports variable):

  variable "http_ports" {
    description = "Map containing objects to define listeners behaviour based on type field. If type field is `forward`, include listener_port and the target_group_port. For `redirect` type, include listener port, host, path, port, protocol, query and status_code. For `fixed-response`, include listener_port, content_type, message_body and status_code"
    type        = map(any)
    default = {
      force-https = {
        type          = "redirect"
        listener_port = 80
        host          = "#{host}"
        path          = "/#{path}"
        port          = "443"
        protocol      = "https"
        query         = "#{query}"
        status_code   = "HTTP_301"
      }
    }
  }

Fixed response:
  variable "http_ports" {
    description = "Map containing objects to define listeners behaviour based on type field. If type field is `forward`, include listener_port and the target_group_port. For `redirect` type, include listener port, host, path, port, protocol, query and status_code. For `fixed-response`, include listener_port, content_type, message_body and status_code"
    type        = map(any)
    default = {
      fixed-response = {
        type          = "fixed-response"
        listener_port = 80
        content_type  = "text/plain"
        message_body  = "Server error"
        status_code   = "500"
      }
    }
  }

Additionally, you can have an HTTPS listener forwarding traffic to an HTTP target group by setting `target_group_protocol` to `HTTP`. The default for `https_ports` variable is `HTTPS`:

  variable "https_ports" {
    description = "Map containing objects to define listeners behaviour based on type field. If type field is `forward`, include listener_port and the target_group_port. For `redirect` type, include listener port, host, path, port, protocol, query and status_code. For `fixed-response`, include listener_port, content_type, message_body and status_code"
    type        = map(any)
    default = {
      https-to-http-tg = {
        type                  = "forward"
        listener_port         = 443
        target_group_port     = 80
        target_group_protocol = HTTP
      }
    }
  }

*/

variable "http_ingress_cidr_blocks" {
  description = "List of CIDR blocks to allowed to access the Load Balancer through HTTP"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "http_ingress_prefix_list_ids" {
  description = "List of prefix list IDs blocks to allowed to access the Load Balancer through HTTP"
  type        = list(string)
  default     = []
}

variable "https_ingress_cidr_blocks" {
  description = "List of CIDR blocks to allowed to access the Load Balancer through HTTPS"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "https_ingress_prefix_list_ids" {
  description = "List of prefix list IDs blocks to allowed to access the Load Balancer through HTTPS"
  type        = list(string)
  default     = []
}

#------------------------------------------------------------------------------
# AWS LOAD BALANCER - Target Groups
#------------------------------------------------------------------------------
variable "deregistration_delay" {
  description = "(Optional) The amount time for Elastic Load Balancing to wait before changing the state of a deregistering target from draining to unused. The range is 0-3600 seconds. The default value is 300 seconds."
  type        = number
  default     = 300
}

variable "slow_start" {
  description = "(Optional) The amount time for targets to warm up before the load balancer sends them a full share of requests. The range is 30-900 seconds or 0 to disable. The default value is 0 seconds."
  type        = number
  default     = 0
}

variable "load_balancing_algorithm_type" {
  description = "(Optional) Determines how the load balancer selects targets when routing requests. The value is round_robin or least_outstanding_requests. The default is round_robin."
  type        = string
  default     = "round_robin"
}

variable "stickiness" {
  description = "(Optional) A Stickiness block. Provide three fields. type, the type of sticky sessions. The only current possible value is lb_cookie. cookie_duration, the time period, in seconds, during which requests from a client should be routed to the same target. After this time period expires, the load balancer-generated cookie is considered stale. The range is 1 second to 1 week (604800 seconds). The default value is 1 day (86400 seconds). enabled, boolean to enable / disable stickiness. Default is true."
  type = object({
    type            = string
    cookie_duration = string
    enabled         = bool
  })
  default = {
    type            = "lb_cookie"
    cookie_duration = 86400
    enabled         = true
  }
}

variable "target_group_health_check_enabled" {
  description = "(Optional) Indicates whether health checks are enabled. Defaults to true."
  type        = bool
  default     = true
}

variable "target_group_health_check_interval" {
  description = "(Optional) The approximate amount of time, in seconds, between health checks of an individual target. Minimum value 5 seconds, Maximum value 300 seconds. Default 30 seconds."
  type        = number
  default     = 30
}

variable "target_group_health_check_path" {
  description = "The destination for the health check request."
  type        = string
  default     = "/"
}

variable "target_group_health_check_port" {
  description = "(Optional) The port to use to connect with the target. Valid values are either ports 1-65536, or traffic-port. Defaults to traffic-port."
  type        = string
  default     = "traffic-port"
}

variable "target_group_health_check_protocol" {
  description = "(Optional) The protocol the load balancer uses when performing health checks on targets. Valid values are HTTP and HTTPS. Defaults to HTTP."
  type        = string
  default     = "HTTP"
}

variable "target_group_health_check_timeout" {
  description = "(Optional) The amount of time, in seconds, during which no response means a failed health check. The range is 2 to 120 seconds, and the default is 5 seconds."
  type        = number
  default     = 5
}

variable "target_group_health_check_healthy_threshold" {
  description = "(Optional) The number of consecutive health checks successes required before considering an unhealthy target healthy. Defaults to 3."
  type        = number
  default     = 3
}

variable "target_group_health_check_unhealthy_threshold" {
  description = "(Optional) The number of consecutive health check failures required before considering the target unhealthy. Defaults to 3."
  type        = number
  default     = 3
}

variable "target_group_health_check_matcher" {
  description = "The codes to use when checking for a successful response from a target. You can specify multiple values (for example, \"200,202\") or a range of values (for example, \"200-299\"). If the protocol version is set to \"GRPC\" the range is different from HTTP and HTTPS. The allowed range of codes for GRPC is \"0-99\". The default value is \"200\"."
  type        = string
  default     = "200"
}

variable "ssl_policy" {
  description = "(Optional) The name of the SSL Policy for the listener. . Required if var.https_ports is set."
  type        = string
  default     = null
}

variable "default_certificate_arn" {
  description = "(Optional) The ARN of the default SSL server certificate. Required if var.https_ports is set."
  type        = string
  default     = null
}

variable "additional_certificates_arn_for_https_listeners" {
  description = "(Optional) List of SSL server certificate ARNs for HTTPS listener. Use it if you need to set additional certificates besides default_certificate_arn"
  type        = list(any)
  default     = []
}
