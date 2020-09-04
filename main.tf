#------------------------------------------------------------------------------
# S3 BUCKET - For access logs
#------------------------------------------------------------------------------
# resource "aws_s3_bucket" "logs" {
#   bucket = "${var.name_prefix}-lb-logs"
#   region = var.region
#   tags = {
#     Name = "${var.name_prefix}-lb-logs"
#   }
# }

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
  # TODO - Enable this feature
  # access_logs {
  #   bucket  = aws_s3_bucket.logs.id
  #   prefix  = ""
  #   enabled = true
  # }
  tags = {
    Name = "${var.name_prefix}-lb"
  }
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
  tags = {
    Name = "${var.name_prefix}-lb-access-sg"
  }
}

resource "aws_security_group_rule" "ingress_through_http" {
  count             = var.enable_http ? length(var.http_ports) : 0
  security_group_id = aws_security_group.lb_access_sg.id
  type              = "ingress"
  from_port         = element(var.http_ports, count.index)
  to_port           = element(var.http_ports, count.index)
  protocol          = "tcp"
  cidr_blocks       = var.http_ingress_cidr_blocks
  prefix_list_ids   = var.http_ingress_prefix_list_ids
}

resource "aws_security_group_rule" "ingress_through_https" {
  count             = var.enable_https ? length(var.https_ports) : 0
  security_group_id = aws_security_group.lb_access_sg.id
  type              = "ingress"
  from_port         = element(var.https_ports, count.index)
  to_port           = element(var.https_ports, count.index)
  protocol          = "tcp"
  cidr_blocks       = var.https_ingress_cidr_blocks
  prefix_list_ids   = var.https_ingress_prefix_list_ids
}

#------------------------------------------------------------------------------
# AWS LOAD BALANCER - Target Groups
#------------------------------------------------------------------------------
resource "aws_lb_target_group" "lb_http_tgs" {
  count                         = var.enable_http ? length(var.http_ports) : 0
  name                          = "${var.name_prefix}-lb-http-tg-${count.index}"
  port                          = element(var.http_ports, count.index)
  protocol                      = "HTTP"
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
    protocol            = "HTTP"
    timeout             = var.target_group_health_check_timeout
    healthy_threshold   = var.target_group_health_check_healthy_threshold
    unhealthy_threshold = var.target_group_health_check_unhealthy_threshold
    matcher             = var.target_group_health_check_matcher
  }
  target_type = "ip"
  tags = {
    Name = "${var.name_prefix}-lb-http-tg-${count.index}"
  }
  lifecycle {
    create_before_destroy = true
  }
  depends_on = [aws_lb.lb]
}

resource "aws_lb_target_group" "lb_https_tgs" {
  count                         = var.enable_https ? length(var.https_ports) : 0
  name                          = "${var.name_prefix}-lb-https-tg-${count.index}"
  port                          = element(var.https_ports, count.index)
  protocol                      = "HTTPS"
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
    protocol            = "HTTPS"
    timeout             = var.target_group_health_check_timeout
    healthy_threshold   = var.target_group_health_check_healthy_threshold
    unhealthy_threshold = var.target_group_health_check_unhealthy_threshold
    matcher             = var.target_group_health_check_matcher
  }
  target_type = "ip"
  tags = {
    Name = "${var.name_prefix}-lb-https-tg-${count.index}"
  }
  lifecycle {
    create_before_destroy = true
  }
  depends_on = [aws_lb.lb]
}

#------------------------------------------------------------------------------
# AWS LOAD BALANCER - Listeners
#------------------------------------------------------------------------------
resource "aws_lb_listener" "lb_http_listeners" {
  count             = var.enable_http ? length(var.http_ports) : 0
  load_balancer_arn = aws_lb.lb.arn
  port              = element(aws_lb_target_group.lb_http_tgs.*.port, count.index)
  protocol          = element(aws_lb_target_group.lb_http_tgs.*.protocol, count.index)
  default_action {
    target_group_arn = element(aws_lb_target_group.lb_http_tgs.*.arn, count.index)
    type             = "forward"
  }
}

resource "aws_lb_listener" "lb_https_listeners" {
  count             = var.enable_https ? length(var.https_ports) : 0
  load_balancer_arn = aws_lb.lb.arn
  port              = element(aws_lb_target_group.lb_https_tgs.*.port, count.index)
  protocol          = element(aws_lb_target_group.lb_https_tgs.*.protocol, count.index)
  default_action {
    target_group_arn = element(aws_lb_target_group.lb_https_tgs.*.arn, count.index)
    type             = "forward"
  }
}
# TODO
# ssl_policy - (Optional) The name of the SSL Policy for the listener. Required if protocol is HTTPS or TLS.
# certificate_arn - (Optional) The ARN of the default SSL server certificate. Exactly one certificate is required if the protocol is HTTPS. For adding additional SSL certificates, see the aws_lb_listener_certificate resource.
