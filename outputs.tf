#------------------------------------------------------------------------------
# APPLICATION LOAD BALANCER
#------------------------------------------------------------------------------
output "aws_lb_lb_id" {
  description = "The ARN of the load balancer (matches arn)."
  value       = aws_lb.lb.id
}

output "aws_lb_lb_arn" {
  description = "The ARN of the load balancer (matches id)."
  value       = aws_lb.lb.arn
}

output "aws_lb_lb_arn_suffix" {
  description = "The ARN suffix for use with CloudWatch Metrics."
  value       = aws_lb.lb.arn_suffix
}

output "aws_lb_lb_dns_name" {
  description = "The DNS name of the load balancer."
  value       = aws_lb.lb.dns_name
}

output "aws_lb_lb_zone_id" {
  description = "The canonical hosted zone ID of the load balancer (to be used in a Route 53 Alias record)."
  value       = aws_lb.lb.zone_id
}

#------------------------------------------------------------------------------
# ACCESS CONTROL TO APPLICATION LOAD BALANCER
#------------------------------------------------------------------------------
output "aws_security_group_lb_access_sg_id" {
  description = "The ID of the security group"
  value       = aws_security_group.lb_access_sg.id
}

output "aws_security_group_lb_access_sg_arn" {
  description = "The ARN of the security group"
  value       = aws_security_group.lb_access_sg.arn
}

output "aws_security_group_lb_access_sg_vpc_id" {
  description = "The VPC ID."
  value       = aws_security_group.lb_access_sg.vpc_id
}

output "aws_security_group_lb_access_sg_owner_id" {
  description = "The owner ID."
  value       = aws_security_group.lb_access_sg.owner_id
}

output "aws_security_group_lb_access_sg_name" {
  description = "The name of the security group"
  value       = aws_security_group.lb_access_sg.name
}

output "aws_security_group_lb_access_sg_description" {
  description = "The description of the security group"
  value       = aws_security_group.lb_access_sg.description
}

output "aws_security_group_lb_access_sg_ingress" {
  description = "The ingress rules."
  value       = aws_security_group.lb_access_sg.ingress
}

output "aws_security_group_lb_access_sg_egress" {
  description = "The egress rules."
  value       = aws_security_group.lb_access_sg.egress
}

#------------------------------------------------------------------------------
# AWS LOAD BALANCER - Target Groups
#------------------------------------------------------------------------------
output "lb_http_tgs_ids" {
  description = "List of HTTP Target Groups IDs"
  value       = [for tg in aws_lb_target_group.lb_http_tgs : tg.id]
}

output "lb_http_tgs_arns" {
  description = "List of HTTP Target Groups ARNs"
  value       = [for tg in aws_lb_target_group.lb_http_tgs : tg.arn]
}

output "lb_http_tgs_names" {
  description = "List of HTTP Target Groups Names"
  value       = [for tg in aws_lb_target_group.lb_http_tgs : tg.name]
}

output "lb_http_tgs_ports" {
  description = "List of HTTP Target Groups ports"
  value       = [for tg in aws_lb_target_group.lb_http_tgs : tostring(tg.port)]
}

output "lb_http_tgs_map_arn_port" {
  value = zipmap(
    [for tg in aws_lb_target_group.lb_http_tgs : tg.arn],
    [for tg in aws_lb_target_group.lb_http_tgs : tostring(tg.port)]
  )
}

output "lb_https_tgs_ids" {
  description = "List of HTTPS Target Groups IDs"
  value       = [for tg in aws_lb_target_group.lb_https_tgs : tg.id]
}

output "lb_https_tgs_arns" {
  description = "List of HTTPS Target Groups ARNs"
  value       = [for tg in aws_lb_target_group.lb_https_tgs : tg.arn]
}

output "lb_https_tgs_names" {
  description = "List of HTTPS Target Groups Names"
  value       = [for tg in aws_lb_target_group.lb_https_tgs : tg.name]
}

output "lb_https_tgs_ports" {
  description = "List of HTTPS Target Groups ports"
  value       = [for tg in aws_lb_target_group.lb_https_tgs : tostring(tg.port)]
}

output "lb_https_tgs_map_arn_port" {
  value = zipmap(
    [for tg in aws_lb_target_group.lb_https_tgs : tg.arn],
    [for tg in aws_lb_target_group.lb_https_tgs : tostring(tg.port)]
  )
}

#------------------------------------------------------------------------------
# AWS LOAD BALANCER - Listeners
#------------------------------------------------------------------------------
output "lb_http_listeners_ids" {
  description = "List of HTTP Listeners IDs"
  value       = [for listener in aws_lb_listener.lb_http_listeners : listener.id]
}

output "lb_http_listeners_arns" {
  description = "List of HTTP Listeners ARNs"
  value       = [for listener in aws_lb_listener.lb_http_listeners : listener.arn]
}

output "lb_https_listeners_ids" {
  description = "List of HTTPS Listeners IDs"
  value       = [for listener in aws_lb_listener.lb_https_listeners : listener.id]
}

output "lb_https_listeners_arns" {
  description = "List of HTTPS Listeners ARNs"
  value       = [for listener in aws_lb_listener.lb_https_listeners : listener.arn]
}

#------------------------------------------------------------------------------
# S3 LB Logging Bucket
#------------------------------------------------------------------------------
output "lb_logs_s3_bucket_id" {
  description = "LB Logging S3 Bucket ID"
  value       = aws_s3_bucket.logs.id
}

output "lb_logs_s3_bucket_arn" {
  description = "LB Logging S3 Bucket ARN"
  value       = aws_s3_bucket.logs.arn
}
