############################################################### Variable for prefix ################################################################

variable "prefix" {

}

###################################################### Variables for VPC ############################################################

variable "vpc_cidr"{

}

variable "private_subnet_cidr"{

}

variable "public_subnet_cidr"{

}

data "aws_partition" "amazonwebservices" {
}

data "aws_region" "reg" {
}

data "aws_availability_zones" "azs" {
}

data "aws_caller_identity" "G_Duty" {
}

variable "igw_name" {

}

variable "natgateway_name" {

}

variable "vpc_name" {

}

variable "env" {

}

variable "cidr_blocks" {

}

############################################# Variables to create ALB ############################################################

variable "application_loadbalancer_name" {

}
variable "internal" {

}
variable "load_balancer_type" {

}
#variable "subnets" {

#}
#variable "security_groups" {     ## Security groups are not supported for network load balancers

#}
variable "enable_deletion_protection" {

}
variable "s3_bucket_exists" {

}
variable "access_log_bucket" {

}
variable "prefix_s3" {

}
variable "idle_timeout" {

}
variable "enabled" {

}
variable "target_group_name" {

}
variable "container_port" {    #### Don't apply when target_type is lambda

}
variable "instance_protocol" {          #####Don't use protocol when target type is lambda

}
variable "target_type_alb" {

}
#variable "vpc_id" {

#}
variable "load_balancing_algorithm_type" {

}
variable "healthy_threshold" {

}
variable "unhealthy_threshold" {

}
variable "healthcheck_path" {

}
#variable "ec2_instance_id" {

#}
variable "timeout" {

}
variable "interval" {

}
variable "ssl_policy" {

}
variable "certificate_arn" {

}
variable "type" {

}

##################################################### Variable for TAG_NUMBER ########################################################

variable "REPO_NAME" {

}
variable "TAG_NUMBER" {

}

##################################### Variables for RDS ########################################################

variable "identifier" {

}
variable "db_subnet_group_name" {

}
#variable "rds_subnet_group" {

#}
#variable "read_replica_identifier" {

#}
variable "allocated_storage" {

}
variable "max_allocated_storage" {

}
#variable "read_replica_max_allocated_storage" {

#}
variable "storage_type" {

}
#variable "read_replica_storage_type" {

#}
variable "engine" {

}
variable "engine_version" {

}
variable "instance_class" {

}
#variable "read_replica_instance_class" {

#}
variable "rds_db_name" {

}
variable "username" {

}
variable "password" {

}
variable "parameter_group_name" {

}
variable "multi_az" {

}
#variable "read_replica_multi_az" {

#}
#variable "final_snapshot_identifier" {

#}
variable "skip_final_snapshot" {

}
#variable "copy_tags_to_snapshot" {

#}
variable "availability_zone" {

}
variable "publicly_accessible" {

}
#variable "read_replica_vpc_security_group_ids" {

#}
#variable "backup_retention_period" {

#}
variable "kms_key_id_rds" {

}
#variable "read_replica_kms_key_id" {

#}
variable "monitoring_role_arn" {

}
variable "enabled_cloudwatch_logs_exports" {

}
