##################### Parameter for Passphrase ####################

encryption_passphrase = "XXXXXXXXXXXXXXXXXXXXXXXXXXXX"

#################Provide Parameters for VPC########################

region = "us-east-2"

vpc_cidr = "172.16.0.0/16"
private_subnet_cidr = ["172.16.1.0/24", "172.16.2.0/24", "172.16.3.0/24"]
public_subnet_cidr = ["172.16.4.0/24", "172.16.5.0/24", "172.16.6.0/24"]
igw_name = "test-IGW"
natgateway_name = "ECS-NatGateway"
vpc_name = "test-vpc"

kms_key_id = "arn:aws:kms:us-east-2:02XXXXXXXXX6:key/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"   ### Provide the ARN of KMS Key.

env = [ "dev", "stage", "prod" ]
cidr_blocks = ["0.0.0.0/0"]

################################Parameters to create ALB############################

application_loadbalancer_name = "jenkins-ms-alb"
internal = false
load_balancer_type = "application"
#subnets = ["subnet-XXXXXXXXXXXXXXXXX", "subnet-XXXXXXXXXXXXXXXXX", "subnet-XXXXXXXXXXXXXXXXX"]
#security_groups = ["sg-05XXXXXXXXXXXXXXc"]  ## Security groups are not supported for network load balancer
enable_deletion_protection = false
s3_bucket_exists = false   ### Select between true and false. It true is selected then it will not create the s3 bucket. 
access_log_bucket_alb = "s3bucketcapturealblogjenkins" ### S3 Bucket into which the Access Log will be captured
prefix_s3 = "application_loadbalancer_log_folder"
idle_timeout = 60
enabled = true
target_group_name = "jenkins-ms-tg"
instance_port = 8080
instance_protocol = "HTTP"          #####Don't use protocol when target type is lambda
target_type_jenkins = ["instance", "ip", "lambda"]
#vpc_id = "vpc-XXXXXXXXXXXXXXXXX"
#ec2_instance_id = ""
load_balancing_algorithm_type = ["round_robin", "least_outstanding_requests"]
healthy_threshold = 2
unhealthy_threshold = 2
timeout = 3
interval = 30
healthcheck_path = "/login"
ssl_policy = ["ELBSecurityPolicy-2016-08", "ELBSecurityPolicy-TLS-1-2-2017-01", "ELBSecurityPolicy-TLS-1-1-2017-01", "ELBSecurityPolicy-TLS-1-2-Ext-2018-06", "ELBSecurityPolicy-FS-2018-06", "ELBSecurityPolicy-2015-05"]
certificate_arn = "arn:aws:acm:us-east-2:02XXXXXXXXX6:certificate/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
type = ["forward", "redirect", "fixed-response"]

########################################## Parameters to Launch EC2 ######################################################

instance_count = 2
instance_type = ["t3.micro", "t3.small", "t3.medium", "t3.large"]
provide_ami = {
  "us-east-1" = "ami-0a1179631ec8933d7"
  "us-east-2" = "ami-00e428798e77d38d9"
  "us-west-1" = "ami-0e0ece251c1638797"
  "us-west-2" = "ami-086f060214da77a16"
}
#subnet_id = "subnet-XXXXXXXXXXXXXXXXX"
#vpc_security_group_ids = ["sg-00cXXXXXXXXXXXXX9"]
#cidr_blocks = ["0.0.0.0/0"]
name = "Jenkins"
