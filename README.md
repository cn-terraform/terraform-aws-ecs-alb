# AWS ALB Terraform Module

Test Continuous Integration/Delivery environment on AWS ECS.

[![](https://github.com/cn-terraform/terraform-aws-ecs-alb/workflows/terraform/badge.svg)](https://github.com/cn-terraform/terraform-aws-ecs-alb/actions?query=workflow%3Aterraform)
[![](https://img.shields.io/github/license/cn-terraform/terraform-aws-ecs-alb)](https://github.com/cn-terraform/terraform-aws-ecs-alb)
[![](https://img.shields.io/github/issues/cn-terraform/terraform-aws-ecs-alb)](https://github.com/cn-terraform/terraform-aws-ecs-alb)
[![](https://img.shields.io/github/issues-closed/cn-terraform/terraform-aws-ecs-alb)](https://github.com/cn-terraform/terraform-aws-ecs-alb)
[![](https://img.shields.io/github/languages/code-size/cn-terraform/terraform-aws-ecs-alb)](https://github.com/cn-terraform/terraform-aws-alb)
[![](https://img.shields.io/github/repo-size/cn-terraform/terraform-aws-ecs-alb)](https://github.com/cn-terraform/terraform-aws-ecs-alb)

## Use this code as a Terraform module

Check valid versions on: 
* Github Releases: <https://github.com/cn-terraform/terraform-aws-ecs-alb/releases>
* Terraform Module Registry: <https://registry.terraform.io/modules/cn-terraform/ecs-alb/aws>

This terraform module creates an Application Load Balancer and security group rules in order allow traffic to it.

## Install pre commit hooks.

Please run this command right after cloning the repository.

        pre-commit install

For that you may need to install the following tools:
* [Pre-commit](https://pre-commit.com/) 
* [Terraform Docs](https://terraform-docs.io/)

In order to run all checks at any point run the following command:

        pre-commit run --all-files

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4 |
| <a name="requirement_null"></a> [null](#requirement\_null) | >= 3 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.93.0 |
| <a name="provider_null"></a> [null](#provider\_null) | 3.2.3 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.7.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_lb_logs_s3"></a> [lb\_logs\_s3](#module\_lb\_logs\_s3) | cn-terraform/logs-s3-bucket/aws | 1.0.6 |

## Resources

| Name | Type |
|------|------|
| [aws_lb.lb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.lb_http_listeners](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_listener.lb_https_listeners](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_listener_certificate.additional_certificates_for_https_listeners](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_certificate) | resource |
| [aws_lb_target_group.lb_http_tgs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_lb_target_group.lb_https_tgs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_security_group.lb_access_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.ingress_through_http](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ingress_through_https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_wafv2_web_acl_association.waf_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl_association) | resource |
| [null_resource.lb_http_tgs_config](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.lb_https_tgs_config](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [random_id.lb_http_tgs_id](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [random_id.lb_https_tgs_id](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [random_string.lb_name](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [aws_elb_service_account.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/elb_service_account) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_logs_prefix"></a> [access\_logs\_prefix](#input\_access\_logs\_prefix) | (Optional) if access logging to an S3 bucket, this sets a prefix in the bucket beneath which this LB's logs will be organized. | `string` | `null` | no |
| <a name="input_additional_certificates_arn_for_https_listeners"></a> [additional\_certificates\_arn\_for\_https\_listeners](#input\_additional\_certificates\_arn\_for\_https\_listeners) | (Optional) List of SSL server certificate ARNs for HTTPS listener. Use it if you need to set additional certificates besides default\_certificate\_arn | `list(any)` | `[]` | no |
| <a name="input_block_s3_bucket_public_access"></a> [block\_s3\_bucket\_public\_access](#input\_block\_s3\_bucket\_public\_access) | (Optional) If true, public access to the S3 bucket will be blocked.  Ignored if log\_bucket\_id is provided. | `bool` | `true` | no |
| <a name="input_default_certificate_arn"></a> [default\_certificate\_arn](#input\_default\_certificate\_arn) | (Optional) The ARN of the default SSL server certificate. Required if var.https\_ports is set. | `string` | `null` | no |
| <a name="input_deregistration_delay"></a> [deregistration\_delay](#input\_deregistration\_delay) | (Optional) The amount time for Elastic Load Balancing to wait before changing the state of a deregistering target from draining to unused. The range is 0-3600 seconds. The default value is 300 seconds. | `number` | `300` | no |
| <a name="input_drop_invalid_header_fields"></a> [drop\_invalid\_header\_fields](#input\_drop\_invalid\_header\_fields) | (Optional) Indicates whether HTTP headers with header fields that are not valid are removed by the load balancer (true) or routed to targets (false). The default is false. Elastic Load Balancing requires that message header names contain only alphanumeric characters and hyphens. | `bool` | `false` | no |
| <a name="input_enable_cross_zone_load_balancing"></a> [enable\_cross\_zone\_load\_balancing](#input\_enable\_cross\_zone\_load\_balancing) | (Optional) If true, cross-zone load balancing of the load balancer will be enabled. Defaults to false. | `bool` | `false` | no |
| <a name="input_enable_deletion_protection"></a> [enable\_deletion\_protection](#input\_enable\_deletion\_protection) | (Optional) If true, deletion of the load balancer will be disabled via the AWS API. This will prevent Terraform from deleting the load balancer. Defaults to false. | `bool` | `false` | no |
| <a name="input_enable_http2"></a> [enable\_http2](#input\_enable\_http2) | (Optional) Indicates whether HTTP/2 is enabled in the load balancer. Defaults to true. | `bool` | `true` | no |
| <a name="input_enable_s3_bucket_server_side_encryption"></a> [enable\_s3\_bucket\_server\_side\_encryption](#input\_enable\_s3\_bucket\_server\_side\_encryption) | (Optional) If true, server side encryption will be applied.  Ignored if log\_bucket\_id is provided. | `bool` | `true` | no |
| <a name="input_enable_s3_logs"></a> [enable\_s3\_logs](#input\_enable\_s3\_logs) | (Optional) If true, all LoadBalancer logs will be sent to S3.  If true, and log\_bucket\_id is *not* provided, this module will create the bucket with other provided s3 bucket configuration options | `bool` | `true` | no |
| <a name="input_http_ingress_cidr_blocks"></a> [http\_ingress\_cidr\_blocks](#input\_http\_ingress\_cidr\_blocks) | List of CIDR blocks to allowed to access the Load Balancer through HTTP | `list(string)` | <pre>[<br/>  "0.0.0.0/0"<br/>]</pre> | no |
| <a name="input_http_ingress_prefix_list_ids"></a> [http\_ingress\_prefix\_list\_ids](#input\_http\_ingress\_prefix\_list\_ids) | List of prefix list IDs blocks to allowed to access the Load Balancer through HTTP | `list(string)` | `[]` | no |
| <a name="input_http_ports"></a> [http\_ports](#input\_http\_ports) | Map containing objects to define listeners behaviour based on type field. If type field is `forward`, include listener\_port and the target\_group\_port. For `redirect` type, include listener port, host, path, port, protocol, query and status\_code. For `fixed-response`, include listener\_port, content\_type, message\_body and status\_code | <pre>map(object({<br/>    type = optional(string)<br/><br/>    listener_port     = number<br/>    target_group_port = number<br/><br/>    target_group_protocol         = optional(string, "HTTP")<br/>    target_group_protocol_version = optional(string, "HTTP1") # HTTP1, HTTP2 or GRPC<br/><br/>    # Health check options, overriding default values provided as module variables<br/>    target_group_health_check_enabled             = optional(bool)<br/>    target_group_health_check_interval            = optional(number)<br/>    target_group_health_check_path                = optional(string)<br/>    target_group_health_check_port                = optional(string)<br/>    target_group_health_check_protocol            = optional(string, "HTTP")<br/>    target_group_health_check_timeout             = optional(number)<br/>    target_group_health_check_healthy_threshold   = optional(number)<br/>    target_group_health_check_unhealthy_threshold = optional(number)<br/>    target_group_health_check_matcher             = optional(string)<br/><br/>    host         = optional(string, "#{host}")<br/>    path         = optional(string, "/#{path}")<br/>    port         = optional(string, "#{port}")<br/>    protocol     = optional(string, "#{protocol}")<br/>    query        = optional(string, "#{query}")<br/>    status_code  = optional(string) # Default for `type=redirect`: "HTTP_301". Default for `type=fixed-response`: "200".<br/>    content_type = optional(string, "text/plain")<br/>    message_body = optional(string, "Fixed response content")<br/>  }))</pre> | <pre>{<br/>  "default": {<br/>    "listener_port": 80,<br/>    "target_group_port": 80,<br/>    "type": "forward"<br/>  }<br/>}</pre> | no |
| <a name="input_https_ingress_cidr_blocks"></a> [https\_ingress\_cidr\_blocks](#input\_https\_ingress\_cidr\_blocks) | List of CIDR blocks to allowed to access the Load Balancer through HTTPS | `list(string)` | <pre>[<br/>  "0.0.0.0/0"<br/>]</pre> | no |
| <a name="input_https_ingress_prefix_list_ids"></a> [https\_ingress\_prefix\_list\_ids](#input\_https\_ingress\_prefix\_list\_ids) | List of prefix list IDs blocks to allowed to access the Load Balancer through HTTPS | `list(string)` | `[]` | no |
| <a name="input_https_ports"></a> [https\_ports](#input\_https\_ports) | Map containing objects to define listeners behaviour based on type field. If type field is `forward`, include listener\_port and the target\_group\_port. For `redirect` type, include listener port, host, path, port, protocol, query and status\_code. For `fixed-response`, include listener\_port, content\_type, message\_body and status\_code | <pre>map(object({<br/>    type = optional(string)<br/><br/>    listener_port     = number<br/>    target_group_port = number<br/><br/>    target_group_protocol         = optional(string, "HTTP")<br/>    target_group_protocol_version = optional(string, "HTTP1") # HTTP1, HTTP2 or GRPC<br/><br/>    # Health check options, overriding default values provided as module variables<br/>    target_group_health_check_enabled             = optional(bool)<br/>    target_group_health_check_interval            = optional(number)<br/>    target_group_health_check_path                = optional(string)<br/>    target_group_health_check_port                = optional(string)<br/>    target_group_health_check_protocol            = optional(string, "HTTP")<br/>    target_group_health_check_timeout             = optional(number)<br/>    target_group_health_check_healthy_threshold   = optional(number)<br/>    target_group_health_check_unhealthy_threshold = optional(number)<br/>    target_group_health_check_matcher             = optional(string)<br/><br/>    host         = optional(string, "#{host}")<br/>    path         = optional(string, "/#{path}")<br/>    port         = optional(string, "#{port}")<br/>    protocol     = optional(string, "#{protocol}")<br/>    query        = optional(string, "#{query}")<br/>    status_code  = optional(string) # Default for `type=redirect`: "HTTP_301". Default for `type=fixed-response`: "200".<br/>    content_type = optional(string, "text/plain")<br/>    message_body = optional(string, "Fixed response content")<br/>  }))</pre> | <pre>{<br/>  "default": {<br/>    "listener_port": 443,<br/>    "target_group_port": 443,<br/>    "type": "forward"<br/>  }<br/>}</pre> | no |
| <a name="input_idle_timeout"></a> [idle\_timeout](#input\_idle\_timeout) | (Optional) The time in seconds that the connection is allowed to be idle. Default: 60. | `number` | `60` | no |
| <a name="input_internal"></a> [internal](#input\_internal) | (Optional) If true, the LB will be internal. | `bool` | `false` | no |
| <a name="input_ip_address_type"></a> [ip\_address\_type](#input\_ip\_address\_type) | (Optional) The type of IP addresses used by the subnets for your load balancer. The possible values are ipv4 and dualstack. Defaults to ipv4 | `string` | `"ipv4"` | no |
| <a name="input_load_balancing_algorithm_type"></a> [load\_balancing\_algorithm\_type](#input\_load\_balancing\_algorithm\_type) | (Optional) Determines how the load balancer selects targets when routing requests. The value is round\_robin or least\_outstanding\_requests. The default is round\_robin. | `string` | `"round_robin"` | no |
| <a name="input_log_bucket_id"></a> [log\_bucket\_id](#input\_log\_bucket\_id) | (Optional) if provided, the ID of a previously-defined S3 bucket to send LB logs to. | `string` | `null` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Name prefix for resources on AWS. Max length is 15 characters. | `string` | n/a | yes |
| <a name="input_private_subnets"></a> [private\_subnets](#input\_private\_subnets) | A list of private subnet IDs to attach to the LB if it is INTERNAL. | `list(string)` | n/a | yes |
| <a name="input_public_subnets"></a> [public\_subnets](#input\_public\_subnets) | A list of public subnet IDs to attach to the LB if it is NOT internal. | `list(string)` | n/a | yes |
| <a name="input_s3_bucket_server_side_encryption_key"></a> [s3\_bucket\_server\_side\_encryption\_key](#input\_s3\_bucket\_server\_side\_encryption\_key) | (Optional) The AWS KMS master key ID used for the SSE-KMS encryption. This can only be used when you set the value of sse\_algorithm as aws:kms. The default aws/s3 AWS KMS master key is used if this element is absent while the sse\_algorithm is aws:kms.  Ignored if log\_bucket\_id is provided. | `string` | `null` | no |
| <a name="input_s3_bucket_server_side_encryption_sse_algorithm"></a> [s3\_bucket\_server\_side\_encryption\_sse\_algorithm](#input\_s3\_bucket\_server\_side\_encryption\_sse\_algorithm) | (Optional) The server-side encryption algorithm to use. Valid values are AES256 and aws:kms.   Ignored if log\_bucket\_id is provided. | `string` | `"AES256"` | no |
| <a name="input_security_groups"></a> [security\_groups](#input\_security\_groups) | (Optional) A list of security group IDs to assign to the LB. | `list(string)` | `[]` | no |
| <a name="input_slow_start"></a> [slow\_start](#input\_slow\_start) | (Optional) The amount time for targets to warm up before the load balancer sends them a full share of requests. The range is 30-900 seconds or 0 to disable. The default value is 0 seconds. | `number` | `0` | no |
| <a name="input_ssl_policy"></a> [ssl\_policy](#input\_ssl\_policy) | (Optional) The name of the SSL Policy for the listener. . Required if var.https\_ports is set. | `string` | `null` | no |
| <a name="input_stickiness"></a> [stickiness](#input\_stickiness) | (Optional) A Stickiness block. Provide three fields. type, the type of sticky sessions. The only current possible value is lb\_cookie. cookie\_duration, the time period, in seconds, during which requests from a client should be routed to the same target. After this time period expires, the load balancer-generated cookie is considered stale. The range is 1 second to 1 week (604800 seconds). The default value is 1 day (86400 seconds). enabled, boolean to enable / disable stickiness. Default is true. | <pre>object({<br/>    type            = string<br/>    cookie_duration = string<br/>    enabled         = bool<br/>  })</pre> | <pre>{<br/>  "cookie_duration": 86400,<br/>  "enabled": true,<br/>  "type": "lb_cookie"<br/>}</pre> | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Resource tags | `map(string)` | `{}` | no |
| <a name="input_target_group_health_check_enabled"></a> [target\_group\_health\_check\_enabled](#input\_target\_group\_health\_check\_enabled) | (Optional) Indicates whether health checks are enabled. Defaults to true. | `bool` | `true` | no |
| <a name="input_target_group_health_check_healthy_threshold"></a> [target\_group\_health\_check\_healthy\_threshold](#input\_target\_group\_health\_check\_healthy\_threshold) | (Optional) The number of consecutive health checks successes required before considering an unhealthy target healthy. Defaults to 3. | `number` | `3` | no |
| <a name="input_target_group_health_check_interval"></a> [target\_group\_health\_check\_interval](#input\_target\_group\_health\_check\_interval) | (Optional) The approximate amount of time, in seconds, between health checks of an individual target. Minimum value 5 seconds, Maximum value 300 seconds. Default 30 seconds. | `number` | `30` | no |
| <a name="input_target_group_health_check_matcher"></a> [target\_group\_health\_check\_matcher](#input\_target\_group\_health\_check\_matcher) | The HTTP codes to use when checking for a successful response from a target. You can specify multiple values (for example, "200,202") or a range of values (for example, "200-299"). Default is 200. | `string` | `"200"` | no |
| <a name="input_target_group_health_check_path"></a> [target\_group\_health\_check\_path](#input\_target\_group\_health\_check\_path) | The destination for the health check request. | `string` | `"/"` | no |
| <a name="input_target_group_health_check_port"></a> [target\_group\_health\_check\_port](#input\_target\_group\_health\_check\_port) | (Optional) The port to use to connect with the target. Valid values are either ports 1-65536, or traffic-port. Defaults to traffic-port. | `string` | `"traffic-port"` | no |
| <a name="input_target_group_health_check_protocol"></a> [target\_group\_health\_check\_protocol](#input\_target\_group\_health\_check\_protocol) | (Optional) The protocol the load balancer uses when performing health checks on targets. Valid values are HTTP and HTTPS. Defaults to HTTP. | `string` | `"HTTP"` | no |
| <a name="input_target_group_health_check_timeout"></a> [target\_group\_health\_check\_timeout](#input\_target\_group\_health\_check\_timeout) | (Optional) The amount of time, in seconds, during which no response means a failed health check. The range is 2 to 120 seconds, and the default is 5 seconds. | `number` | `5` | no |
| <a name="input_target_group_health_check_unhealthy_threshold"></a> [target\_group\_health\_check\_unhealthy\_threshold](#input\_target\_group\_health\_check\_unhealthy\_threshold) | (Optional) The number of consecutive health check failures required before considering the target unhealthy. Defaults to 3. | `number` | `3` | no |
| <a name="input_use_random_name_for_lb"></a> [use\_random\_name\_for\_lb](#input\_use\_random\_name\_for\_lb) | If true the LB name will be a random string | `bool` | `false` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID of the VPC | `any` | n/a | yes |
| <a name="input_waf_web_acl_arn"></a> [waf\_web\_acl\_arn](#input\_waf\_web\_acl\_arn) | ARN of a WAFV2 to associate with the ALB | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_lb_lb_arn"></a> [aws\_lb\_lb\_arn](#output\_aws\_lb\_lb\_arn) | The ARN of the load balancer (matches id). |
| <a name="output_aws_lb_lb_arn_suffix"></a> [aws\_lb\_lb\_arn\_suffix](#output\_aws\_lb\_lb\_arn\_suffix) | The ARN suffix for use with CloudWatch Metrics. |
| <a name="output_aws_lb_lb_dns_name"></a> [aws\_lb\_lb\_dns\_name](#output\_aws\_lb\_lb\_dns\_name) | The DNS name of the load balancer. |
| <a name="output_aws_lb_lb_id"></a> [aws\_lb\_lb\_id](#output\_aws\_lb\_lb\_id) | The ARN of the load balancer (matches arn). |
| <a name="output_aws_lb_lb_zone_id"></a> [aws\_lb\_lb\_zone\_id](#output\_aws\_lb\_lb\_zone\_id) | The canonical hosted zone ID of the load balancer (to be used in a Route 53 Alias record). |
| <a name="output_aws_security_group_lb_access_sg_arn"></a> [aws\_security\_group\_lb\_access\_sg\_arn](#output\_aws\_security\_group\_lb\_access\_sg\_arn) | The ARN of the security group |
| <a name="output_aws_security_group_lb_access_sg_description"></a> [aws\_security\_group\_lb\_access\_sg\_description](#output\_aws\_security\_group\_lb\_access\_sg\_description) | The description of the security group |
| <a name="output_aws_security_group_lb_access_sg_egress"></a> [aws\_security\_group\_lb\_access\_sg\_egress](#output\_aws\_security\_group\_lb\_access\_sg\_egress) | The egress rules. |
| <a name="output_aws_security_group_lb_access_sg_id"></a> [aws\_security\_group\_lb\_access\_sg\_id](#output\_aws\_security\_group\_lb\_access\_sg\_id) | The ID of the security group |
| <a name="output_aws_security_group_lb_access_sg_ingress"></a> [aws\_security\_group\_lb\_access\_sg\_ingress](#output\_aws\_security\_group\_lb\_access\_sg\_ingress) | The ingress rules. |
| <a name="output_aws_security_group_lb_access_sg_name"></a> [aws\_security\_group\_lb\_access\_sg\_name](#output\_aws\_security\_group\_lb\_access\_sg\_name) | The name of the security group |
| <a name="output_aws_security_group_lb_access_sg_owner_id"></a> [aws\_security\_group\_lb\_access\_sg\_owner\_id](#output\_aws\_security\_group\_lb\_access\_sg\_owner\_id) | The owner ID. |
| <a name="output_aws_security_group_lb_access_sg_vpc_id"></a> [aws\_security\_group\_lb\_access\_sg\_vpc\_id](#output\_aws\_security\_group\_lb\_access\_sg\_vpc\_id) | The VPC ID. |
| <a name="output_lb_http_listeners_arns"></a> [lb\_http\_listeners\_arns](#output\_lb\_http\_listeners\_arns) | List of HTTP Listeners ARNs |
| <a name="output_lb_http_listeners_ids"></a> [lb\_http\_listeners\_ids](#output\_lb\_http\_listeners\_ids) | List of HTTP Listeners IDs |
| <a name="output_lb_http_tgs_arns"></a> [lb\_http\_tgs\_arns](#output\_lb\_http\_tgs\_arns) | List of HTTP Target Groups ARNs |
| <a name="output_lb_http_tgs_ids"></a> [lb\_http\_tgs\_ids](#output\_lb\_http\_tgs\_ids) | List of HTTP Target Groups IDs |
| <a name="output_lb_http_tgs_map_arn_port"></a> [lb\_http\_tgs\_map\_arn\_port](#output\_lb\_http\_tgs\_map\_arn\_port) | n/a |
| <a name="output_lb_http_tgs_names"></a> [lb\_http\_tgs\_names](#output\_lb\_http\_tgs\_names) | List of HTTP Target Groups Names |
| <a name="output_lb_http_tgs_ports"></a> [lb\_http\_tgs\_ports](#output\_lb\_http\_tgs\_ports) | List of HTTP Target Groups ports |
| <a name="output_lb_https_listeners_arns"></a> [lb\_https\_listeners\_arns](#output\_lb\_https\_listeners\_arns) | List of HTTPS Listeners ARNs |
| <a name="output_lb_https_listeners_ids"></a> [lb\_https\_listeners\_ids](#output\_lb\_https\_listeners\_ids) | List of HTTPS Listeners IDs |
| <a name="output_lb_https_tgs_arns"></a> [lb\_https\_tgs\_arns](#output\_lb\_https\_tgs\_arns) | List of HTTPS Target Groups ARNs |
| <a name="output_lb_https_tgs_ids"></a> [lb\_https\_tgs\_ids](#output\_lb\_https\_tgs\_ids) | List of HTTPS Target Groups IDs |
| <a name="output_lb_https_tgs_map_arn_port"></a> [lb\_https\_tgs\_map\_arn\_port](#output\_lb\_https\_tgs\_map\_arn\_port) | n/a |
| <a name="output_lb_https_tgs_names"></a> [lb\_https\_tgs\_names](#output\_lb\_https\_tgs\_names) | List of HTTPS Target Groups Names |
| <a name="output_lb_https_tgs_ports"></a> [lb\_https\_tgs\_ports](#output\_lb\_https\_tgs\_ports) | List of HTTPS Target Groups ports |
| <a name="output_lb_logs_s3_bucket_arn"></a> [lb\_logs\_s3\_bucket\_arn](#output\_lb\_logs\_s3\_bucket\_arn) | LB Logging S3 Bucket ARN |
| <a name="output_lb_logs_s3_bucket_id"></a> [lb\_logs\_s3\_bucket\_id](#output\_lb\_logs\_s3\_bucket\_id) | LB Logging S3 Bucket ID |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
