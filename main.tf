#------------------------------------------------------------------------------
# S3 BUCKET - For access logs
#------------------------------------------------------------------------------
resource "aws_s3_bucket" "logs" {
  bucket = "${var.name_prefix}-lb-logs"
  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-lb-logs"
    },
  )
}

resource "aws_s3_bucket_acl" "logs" {
  bucket = aws_s3_bucket.logs.id
  acl    = "log-delivery-write"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "logs" {
  count = var.enable_s3_bucket_server_side_encryption ? 1 : 0

  bucket = aws_s3_bucket.logs.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.s3_bucket_server_side_encryption_key_arn
      sse_algorithm     = "aws:kms"
    }
  }
}

#------------------------------------------------------------------------------
# IAM POLICY DOCUMENT - For access logs to the S3 bucket
#------------------------------------------------------------------------------
data "aws_elb_service_account" "default" {}

data "aws_iam_policy_document" "lb_logs_access_policy_document" {
  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = [data.aws_elb_service_account.default.arn]
    }

    actions = [
      "s3:PutObject",
    ]

    resources = [
      "${aws_s3_bucket.logs.arn}/*",
      "arn:aws:s3:::${var.name_prefix}-lb-logs/*",
    ]
  }
}

#------------------------------------------------------------------------------
# IAM POLICY - For access logs to the s3 bucket
#------------------------------------------------------------------------------
resource "aws_s3_bucket_policy" "lb_logs_access_policy" {
  bucket = aws_s3_bucket.logs.id
  policy = data.aws_iam_policy_document.lb_logs_access_policy_document.json
}

#------------------------------------------------------------------------------
# S3 bucket block public access
#------------------------------------------------------------------------------
resource "aws_s3_bucket_public_access_block" "lb_logs_block_public_access" {
  count = var.block_s3_bucket_public_access ? 1 : 0

  bucket = aws_s3_bucket.logs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  depends_on = [aws_s3_bucket_policy.lb_logs_access_policy]
}

#------------------------------------------------------------------------------
# APPLICATION LOAD BALANCER
#------------------------------------------------------------------------------
resource "aws_lb" "lb" {
  name                             = "${var.name_prefix}-lb"
  internal                         = var.internal
  load_balancer_type               = "application"
  drop_invalid_header_fields       = var.drop_invalid_header_fields
  subnets                          = var.internal ? var.private_subnets : var.public_subnets
  idle_timeout                     = var.idle_timeout
  enable_deletion_protection       = var.enable_deletion_protection
  enable_cross_zone_load_balancing = var.enable_cross_zone_load_balancing
  enable_http2                     = var.enable_http2
  ip_address_type                  = var.ip_address_type
  security_groups = compact(
    concat(var.security_groups, [aws_security_group.lb_access_sg.id]),
  )

  access_logs {
    bucket  = aws_s3_bucket.logs.id
    enabled = true
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-lb"
    },
  )
}

#------------------------------------------------------------------------------
# ACCESS CONTROL TO APPLICATION LOAD BALANCER
#------------------------------------------------------------------------------
resource "aws_security_group" "lb_access_sg" {
  name        = "${var.name_prefix}-lb-access-sg"
  description = "Controls access to the Load Balancer"
  vpc_id      = var.vpc_id
  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-lb-access-sg"
    },
  )
}

resource "aws_security_group_rule" "ingress_through_http" {
  for_each          = var.http_ports
  security_group_id = aws_security_group.lb_access_sg.id
  type              = "ingress"
  from_port         = each.value.listener_port
  to_port           = each.value.listener_port
  protocol          = "tcp"
  cidr_blocks       = var.http_ingress_cidr_blocks
  prefix_list_ids   = var.http_ingress_prefix_list_ids
}

resource "aws_security_group_rule" "ingress_through_https" {
  for_each          = var.https_ports
  security_group_id = aws_security_group.lb_access_sg.id
  type              = "ingress"
  from_port         = each.value.listener_port
  to_port           = each.value.listener_port
  protocol          = "tcp"
  cidr_blocks       = var.https_ingress_cidr_blocks
  prefix_list_ids   = var.https_ingress_prefix_list_ids
}

#------------------------------------------------------------------------------
# AWS LOAD BALANCER - Target Groups
#------------------------------------------------------------------------------
resource "aws_lb_target_group" "lb_http_tgs" {
  for_each = {
    for name, config in var.http_ports : name => config
    if lookup(config, "type", "") == "" || lookup(config, "type", "") == "forward"
  }
  name                          = "${var.name_prefix}-http-${each.value.target_group_port}"
  port                          = each.value.target_group_port
  protocol                      = lookup(each.value, "target_group_protocol", "") == "" ? "HTTP" : each.value.target_group_protocol
  vpc_id                        = var.vpc_id
  deregistration_delay          = var.deregistration_delay
  slow_start                    = var.slow_start
  load_balancing_algorithm_type = var.load_balancing_algorithm_type
  dynamic "stickiness" {
    for_each = var.stickiness == null ? [] : [var.stickiness]
    content {
      type            = stickiness.value.type
      cookie_duration = stickiness.value.cookie_duration
      enabled         = stickiness.value.enabled
    }
  }
  health_check {
    enabled             = var.target_group_health_check_enabled
    interval            = var.target_group_health_check_interval
    path                = var.target_group_health_check_path
    protocol            = lookup(each.value, "target_group_protocol", "") == "" ? "HTTP" : each.value.target_group_protocol
    timeout             = var.target_group_health_check_timeout
    healthy_threshold   = var.target_group_health_check_healthy_threshold
    unhealthy_threshold = var.target_group_health_check_unhealthy_threshold
    matcher             = var.target_group_health_check_matcher
  }
  target_type = "ip"
  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-http-${each.value.target_group_port}"
    },
  )
  lifecycle {
    create_before_destroy = true
  }
  depends_on = [aws_lb.lb]
}

resource "aws_lb_target_group" "lb_https_tgs" {
  for_each = {
    for name, config in var.https_ports : name => config
    if lookup(config, "type", "") == "" || lookup(config, "type", "") == "forward"
  }
  name                          = "${var.name_prefix}-https-${each.value.target_group_port}"
  port                          = each.value.target_group_port
  protocol                      = lookup(each.value, "target_group_protocol", "") == "" ? "HTTPS" : each.value.target_group_protocol
  vpc_id                        = var.vpc_id
  deregistration_delay          = var.deregistration_delay
  slow_start                    = var.slow_start
  load_balancing_algorithm_type = var.load_balancing_algorithm_type
  dynamic "stickiness" {
    for_each = var.stickiness == null ? [] : [var.stickiness]
    content {
      type            = stickiness.value.type
      cookie_duration = stickiness.value.cookie_duration
      enabled         = stickiness.value.enabled
    }
  }
  health_check {
    enabled             = var.target_group_health_check_enabled
    interval            = var.target_group_health_check_interval
    path                = var.target_group_health_check_path
    protocol            = lookup(each.value, "target_group_protocol", "") == "" ? "HTTPS" : each.value.target_group_protocol
    timeout             = var.target_group_health_check_timeout
    healthy_threshold   = var.target_group_health_check_healthy_threshold
    unhealthy_threshold = var.target_group_health_check_unhealthy_threshold
    matcher             = var.target_group_health_check_matcher
  }
  target_type = "ip"
  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-https-${each.value.target_group_port}"
    },
  )
  lifecycle {
    create_before_destroy = true
  }
  depends_on = [aws_lb.lb]
}

#------------------------------------------------------------------------------
# AWS LOAD BALANCER - Listeners
#------------------------------------------------------------------------------
resource "aws_lb_listener" "lb_http_listeners" {
  for_each          = var.http_ports
  load_balancer_arn = aws_lb.lb.arn
  port              = each.value.listener_port
  protocol          = "HTTP"

  dynamic "default_action" {
    for_each = lookup(each.value, "type", "") == "redirect" ? [1] : []
    content {
      type = "redirect"

      redirect {
        host        = lookup(each.value, "host", "#{host}")
        path        = lookup(each.value, "path", "/#{path}")
        port        = lookup(each.value, "port", "#{port}")
        protocol    = lookup(each.value, "protocol", "#{protocol}")
        query       = lookup(each.value, "query", "#{query}")
        status_code = lookup(each.value, "status_code", "HTTP_301")
      }
    }
  }

  dynamic "default_action" {
    for_each = lookup(each.value, "type", "") == "fixed-response" ? [1] : []
    content {
      type = "fixed-response"

      fixed_response {
        content_type = lookup(each.value, "content_type", "text/plain")
        message_body = lookup(each.value, "message_body", "Fixed response content")
        status_code  = lookup(each.value, "status_code", "200")
      }
    }
  }

  # We fallback to using forward type action if type is not defined
  dynamic "default_action" {
    for_each = (lookup(each.value, "type", "") == "" || lookup(each.value, "type", "") == "forward") ? [1] : []
    content {
      target_group_arn = aws_lb_target_group.lb_http_tgs[each.key].arn
      type             = "forward"
    }
  }

  tags = var.tags
}

resource "aws_lb_listener" "lb_https_listeners" {
  for_each          = var.https_ports
  load_balancer_arn = aws_lb.lb.arn
  port              = each.value.listener_port
  protocol          = "HTTPS"
  ssl_policy        = var.ssl_policy
  certificate_arn   = var.default_certificate_arn

  dynamic "default_action" {
    for_each = lookup(each.value, "type", "") == "redirect" ? [1] : []
    content {
      type = "redirect"

      redirect {
        host        = lookup(each.value, "host", "#{host}")
        path        = lookup(each.value, "path", "/#{path}")
        port        = lookup(each.value, "port", "#{port}")
        protocol    = lookup(each.value, "protocol", "#{protocol}")
        query       = lookup(each.value, "query", "#{query}")
        status_code = lookup(each.value, "status_code", "HTTP_301")
      }
    }
  }

  dynamic "default_action" {
    for_each = lookup(each.value, "type", "") == "fixed-response" ? [1] : []
    content {
      type = "fixed-response"

      fixed_response {
        content_type = lookup(each.value, "content_type", "text/plain")
        message_body = lookup(each.value, "message_body", "Fixed response content")
        status_code  = lookup(each.value, "status_code", "200")
      }
    }
  }

  # We fallback to using forward type action if type is not defined
  dynamic "default_action" {
    for_each = (lookup(each.value, "type", "") == "" || lookup(each.value, "type", "") == "forward") ? [1] : []
    content {
      target_group_arn = aws_lb_target_group.lb_https_tgs[each.key].arn
      type             = "forward"
    }
  }

  tags = var.tags
}

locals {
  list_maps_listener_certificate_arns = flatten([
    for cert_arn in var.additional_certificates_arn_for_https_listeners : [
      for listener in aws_lb_listener.lb_https_listeners : {
        name            = "${listener}-${cert_arn}"
        listener_arn    = listener.arn
        certificate_arn = cert_arn
      }
    ]
  ])

  map_listener_certificate_arns = {
    for obj in local.list_maps_listener_certificate_arns : obj.name => {
      listener_arn    = obj.listener_arn,
      certificate_arn = obj.certificate_arn
    }
  }
}

resource "aws_lb_listener_certificate" "additional_certificates_for_https_listeners" {
  for_each        = local.map_listener_certificate_arns
  listener_arn    = each.value.listener_arn
  certificate_arn = each.value.certificate_arn
}
