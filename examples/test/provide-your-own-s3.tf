resource "aws_s3_bucket" "bucket" {
  bucket = "my-tf-test-bucket"
}

module "load_balancer_bring_your_own_bucket" {
  source          = "../../"
  name_prefix     = "test-alb"
  vpc_id          = module.base-network.vpc_id
  private_subnets = module.base-network.private_subnets_ids
  public_subnets  = module.base-network.public_subnets_ids
  log_bucket_id   = aws_s3_bucket.bucket.id
}
