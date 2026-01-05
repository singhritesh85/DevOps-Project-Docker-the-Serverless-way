module "jenkins" {
  source = "../module"

######################################################### To create VPC ###############################################################

  vpc_cidr = var.vpc_cidr
  private_subnet_cidr = var.private_subnet_cidr
  public_subnet_cidr = var.public_subnet_cidr
  igw_name = var.igw_name
  natgateway_name = var.natgateway_name
  vpc_name = var.vpc_name
  env = var.env[0]
  cidr_blocks = var.cidr_blocks
  kms_key_id = var.kms_key_id

###########################To create Jenkins ALB###################################

  application_loadbalancer_name = var.application_loadbalancer_name
  internal = var.internal
  load_balancer_type = var.load_balancer_type
#  subnets = var.subnets
#  security_groups = var.security_groups  ## Security groups are not supported for network load balancer
  enable_deletion_protection = var.enable_deletion_protection
  s3_bucket_exists = var.s3_bucket_exists
  access_log_bucket_alb = var.access_log_bucket_alb  ### S3 Bucket into which the Access Log will be captured
  prefix_s3 = var.prefix_s3
  idle_timeout = var.idle_timeout
  enabled = var.enabled
  target_group_name = var.target_group_name
  instance_port = var.instance_port
  instance_protocol = var.instance_protocol          #####Don't use protocol when target type is lambda
  target_type_jenkins = var.target_type_jenkins[0]
  healthcheck_path = var.healthcheck_path
#  vpc_id = var.vpc_id
#  ec2_instance_id = var.ec2_instance_id
  load_balancing_algorithm_type = var.load_balancing_algorithm_type[0]
  healthy_threshold = var.healthy_threshold
  unhealthy_threshold = var.unhealthy_threshold
  timeout = var.timeout
  interval = var.interval
  ssl_policy = var.ssl_policy[0]
  certificate_arn = var.certificate_arn
  type = var.type

###########################To Launch Jenkins EC2###################################

  instance_count = var.instance_count
  provide_ami = var.provide_ami["us-east-2"]
#  vpc_security_group_ids = var.vpc_security_group_ids
#  cidr_blocks = var.cidr_blocks
#  subnet_id = var.subnet_id
#  kms_key_id = var.kms_key_id
  instance_type = var.instance_type
  name = var.name

}
