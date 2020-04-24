# ---------------------------------------------------------------------------------------------------------------------
# APPLICATION LOAD BALANCER
# ---------------------------------------------------------------------------------------------------------------------
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

# ---------------------------------------------------------------------------------------------------------------------
# ACCESS CONTROL TO APPLICATION LOAD BALANCER
# ---------------------------------------------------------------------------------------------------------------------
output "aws_security_group_lb_access_sg_id" {
  description = "The ID of the security group"
  value = aws_security_group.lb_access_sg.id
}

output "aws_security_group_lb_access_sg_arn" {
  description = "The ARN of the security group"
  value = aws_security_group.lb_access_sg.arn
}

output "aws_security_group_lb_access_sg_vpc_id" {
  description = "The VPC ID."
  value = aws_security_group.lb_access_sg.vpc_id
}

output "aws_security_group_lb_access_sg_owner_id" {
  description = "The owner ID."
  value = aws_security_group.lb_access_sg.owner_id
}

output "aws_security_group_lb_access_sg_name" {
  description = "The name of the security group"
  value = aws_security_group.lb_access_sg.name
}

output "aws_security_group_lb_access_sg_description" {
  description = "The description of the security group"
  value = aws_security_group.lb_access_sg.description
}

output "aws_security_group_lb_access_sg_ingress" {
  description = "The ingress rules."
  value = aws_security_group.lb_access_sg.ingress
}

output "aws_security_group_lb_access_sg_egress" {
  description = "The egress rules."
  value = aws_security_group.lb_access_sg.egress
}
