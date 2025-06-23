locals {
  bucket_id = "my-tf-test-bucket"
}

resource "aws_s3_bucket" "bucket" {
  bucket = local.bucket_id
}

module "load_balancer_bring_your_own_bucket" {
  source          = "../../"
  name_prefix     = "test-alb"
  vpc_id          = module.base-network.vpc_id
  public_subnets  = [for subnet in module.base-network.public_subnets : subnet.id]
  private_subnets = [for subnet in module.base-network.private_subnets : subnet.id]
  log_bucket_id   = local.bucket_id
}
