# AWS ALB Terraform Module

Test Continuous Integration/Delivery environment on AWS ECS.

[![CircleCI](https://circleci.com/gh/cn-terraform/terraform-aws-alb/tree/master.svg?style=svg)](https://circleci.com/gh/cn-terraform/terraform-aws-alb/tree/master)
[![](https://img.shields.io/github/license/cn-terraform/terraform-aws-alb)](https://github.com/cn-terraform/terraform-aws-alb)
[![](https://img.shields.io/github/issues/cn-terraform/terraform-aws-alb)](https://github.com/cn-terraform/terraform-aws-alb)
[![](https://img.shields.io/github/issues-closed/cn-terraform/terraform-aws-alb)](https://github.com/cn-terraform/terraform-aws-alb)
[![](https://img.shields.io/github/languages/code-size/cn-terraform/terraform-aws-alb)](https://github.com/cn-terraform/terraform-aws-alb)
[![](https://img.shields.io/github/repo-size/cn-terraform/terraform-aws-alb)](https://github.com/cn-terraform/terraform-aws-alb)

## Use this code as a Terraform module

Check valid versions on:
* Github Releases: <https://github.com/cn-terraform/terraform-aws-alb/releases>
* Terraform Module Registry: <https://registry.terraform.io/modules/cn-terraform/ci-cd-system/aws>

This terraform module creates an Application Load Balancer and security group rules in order allow traffic to it. It does NOT create any Target Group or Listeners, please create those on your convenience based on the outputs provided by this module.