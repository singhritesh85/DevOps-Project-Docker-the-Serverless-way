module "ecs" {
  source = "../module"

########################################### To provide prefix name for AWS Resources ##################################################

  prefix = var.prefix

######################################################### To create VPC ###############################################################

  vpc_cidr = var.vpc_cidr
  private_subnet_cidr = var.private_subnet_cidr
  public_subnet_cidr = var.public_subnet_cidr
  igw_name = var.igw_name
  natgateway_name = var.natgateway_name
  vpc_name = var.vpc_name
  env = var.env[0]
  cidr_blocks = var.cidr_blocks

###########################To create ALB###################################

  application_loadbalancer_name = var.application_loadbalancer_name
  internal = var.internal
  load_balancer_type = var.load_balancer_type
#  subnets = var.subnets
#  security_groups = var.security_groups  ## Security groups are not supported for network load balancer
  enable_deletion_protection = var.enable_deletion_protection
  s3_bucket_exists = var.s3_bucket_exists
  access_log_bucket = var.access_log_bucket  ### S3 Bucket into which the Access Log will be captured
  prefix_s3 = var.prefix_s3
  idle_timeout = var.idle_timeout
  enabled = var.enabled
  target_group_name = var.target_group_name
  container_port = var.container_port
  instance_protocol = var.instance_protocol          #####Don't use protocol when target type is lambda
  target_type_alb = var.target_type_alb[1]
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

####################To assign TAG_NUMBER for Docker Image###################  
  
  REPO_NAME = var.REPO_NAME
  TAG_NUMBER = var.TAG_NUMBER

############################################### For RDS ##############################################################

#  count = var.db_instance_count
  identifier = var.identifier
  db_subnet_group_name = var.db_subnet_group_name
#  rds_subnet_group = var.rds_subnet_group
#  read_replica_identifier = var.read_replica_identifier  ###  read_replica_identifier = "${var.read_replica_identifier}-${count.index + 1}"
  allocated_storage = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
#  read_replica_max_allocated_storage = var.read_replica_max_allocated_storage
  storage_type = var.storage_type[0]
#  read_replica_storage_type = var.read_replica_storage_type
  engine = var.engine[0]          
  engine_version = var.engine_version[1]
  instance_class = var.instance_class[0]
#  read_replica_instance_class = var.read_replica_instance_class
  rds_db_name = var.rds_db_name
  username = var.username
  password = var.password
  parameter_group_name = var.parameter_group_name[1]
  multi_az = var.multi_az[0]
#  read_replica_multi_az = var.read_replica_multi_az
#  final_snapshot_identifier = var.final_snapshot_identifier
  skip_final_snapshot = var.skip_final_snapshot[0]
#  copy_tags_to_snapshot = var.copy_tags_to_snapshot
  availability_zone = var.availability_zone[0]  ### It should not be enabled for Multi-AZ option, If it is not enabled for Single DB Instance then it's value will be taken randomly.
  publicly_accessible = var.publicly_accessible[1]
#  read_replica_vpc_security_group_ids = var.read_replica_vpc_security_group_ids
#  backup_retention_period = var.backup_retention_period
  kms_key_id_rds = var.kms_key_id_rds
#  read_replica_kms_key_id = var.read_replica_kms_key_id
  monitoring_role_arn = var.monitoring_role_arn
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports

}
