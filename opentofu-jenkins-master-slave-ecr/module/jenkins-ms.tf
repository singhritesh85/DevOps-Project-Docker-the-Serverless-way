# Security Group for ALB
resource "aws_security_group" "jenkins_master_alb" {
  name        = "Jenkins_master-ALB"
  description = "Security Group for Jenkins Master ALB"
  vpc_id      = aws_vpc.test_vpc.id

  ingress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = var.cidr_blocks
  }

  ingress {
    protocol   = "tcp"
    cidr_blocks = var.cidr_blocks
    from_port  = 80
    to_port    = 80
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Jenkins-Master-ALB-sg"
  }
}

#S3 Bucket to capture ALB access logs
resource "aws_s3_bucket" "s3_bucket_alb" {
  count = var.s3_bucket_exists == false ? 1 : 0
  bucket = var.access_log_bucket_alb

  force_destroy = true

  tags = {
    Environment = var.env
  }
}

#S3 Bucket Server Side Encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "s3bucket_encryption_alb" {
  count = var.s3_bucket_exists == false ? 1 : 0
  bucket = aws_s3_bucket.s3_bucket_alb[0].id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "AES256"
    }
  }
}

#Apply Bucket Policy to S3 Bucket
resource "aws_s3_bucket_policy" "s3bucket_policy_alb" {
  count = var.s3_bucket_exists == false ? 1 : 0
  bucket = aws_s3_bucket.s3_bucket_alb[0].id
  policy = <<EOT
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Effect": "Allow",
          "Principal": {
            "AWS": "arn:aws:iam::033677994240:root"
          },
          "Action": "s3:PutObject",
          "Resource": "arn:aws:s3:::s3bucketcapturealblogjenkins/application_loadbalancer_log_folder/AWSLogs/${data.aws_caller_identity.G_Duty.account_id}/*"
        }
      ]
    }
  EOT

  depends_on = [aws_s3_bucket_server_side_encryption_configuration.s3bucket_encryption_alb]
}

#Application Loadbalancer
resource "aws_lb" "test-application-loadbalancer_alb" {
  name               = var.application_loadbalancer_name
  internal           = var.internal
  load_balancer_type = var.load_balancer_type
  security_groups    = [aws_security_group.jenkins_master_alb.id]           ###var.security_groups
  subnets            = aws_subnet.public_subnet.*.id

  enable_deletion_protection = var.enable_deletion_protection
  idle_timeout = var.idle_timeout
  access_logs {
    bucket  = var.access_log_bucket_alb
    prefix  = var.prefix_s3
    enabled = var.enabled
  }

  tags = {
    Environment = var.env
  }

  depends_on = [aws_s3_bucket_policy.s3bucket_policy_alb]
}

#Target Group of Application Loadbalancer
resource "aws_lb_target_group" "target_group_alb" {
  name     = var.target_group_name
  port     = var.instance_port      ##### Don't use protocol when target type is lambda
  protocol = var.instance_protocol  ##### Don't use protocol when target type is lambda
  vpc_id   = aws_vpc.test_vpc.id
  target_type = var.target_type_jenkins
  load_balancing_algorithm_type = var.load_balancing_algorithm_type
  health_check {
    enabled = true ## Indicates whether health checks are enabled. Defaults to true.
    path = var.healthcheck_path     ###"/index.html"
    port = "traffic-port"
    protocol = "HTTP"
    healthy_threshold   = var.healthy_threshold
    unhealthy_threshold = var.unhealthy_threshold
    timeout             = var.timeout
    interval            = var.interval
  }
}

##Application Loadbalancer listener for HTTP
resource "aws_lb_listener" "alb_listener_front_end_HTTP_jenkins" {
  load_balancer_arn = aws_lb.test-application-loadbalancer_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = var.type[1]
    target_group_arn = aws_lb_target_group.target_group_alb.arn
     redirect {    ### Redirect HTTP to HTTPS
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

##Application Loadbalancer listener for HTTPS
resource "aws_lb_listener" "alb_listener_front_end_HTTPS_jenkins" {
  load_balancer_arn = aws_lb.test-application-loadbalancer_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = var.ssl_policy
  certificate_arn   = var.certificate_arn

  default_action {
    type             = var.type[0]
    target_group_arn = aws_lb_target_group.target_group_alb.arn
  }
}

## EC2 Instance1 attachment to Target Group
resource "aws_lb_target_group_attachment" "ec2_instance1_attachment_to_tg_jenkins" {
  target_group_arn = aws_lb_target_group.target_group_alb.arn
  target_id        = aws_instance.jenkins[0].id               #var.ec2_instance_id[0]
  port             = var.instance_port
}

## EC2 Instance2 attachment to Target Group
#resource "aws_lb_target_group_attachment" "ec2_instance2_attachment_to_tg" {
#  target_group_arn = aws_lb_target_group.target_group.arn
#  target_id        = var.ec2_instance_id[1]
#  port             = var.instance_port
#}

############################################################### Jenkins-Master-Slave #####################################################################
# Security Group for Jenkins-Master
resource "aws_security_group" "jenkins_master" {
  name        = "Jenkins-master"
  description = "Security Group for Jenkins Master ALB"
  vpc_id      = aws_vpc.test_vpc.id

  ingress {
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    security_groups  = [aws_security_group.jenkins_master_alb.id]
  }

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = var.cidr_blocks
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "jenkins-master-sg"
  }
}

# Security Group for Jenkins Slave
resource "aws_security_group" "jenkins_slave" {
  name        = "Jenkins-slave"
  description = "Security Group for Jenkins Slave ALB"
  vpc_id      = aws_vpc.test_vpc.id

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = var.cidr_blocks
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "jenkins-slave-sg"
  }
}

resource "aws_instance" "jenkins" {
  count         = var.instance_count
  ami           = var.provide_ami
  instance_type = var.instance_type[2]
  monitoring = true
  vpc_security_group_ids = count.index == 0 ? [aws_security_group.jenkins_master.id] : [aws_security_group.jenkins_slave.id]
  subnet_id = aws_subnet.public_subnet[0].id
  root_block_device{
    volume_type="gp3"
    volume_size="20"
    encrypted=true
    kms_key_id = var.kms_key_id
    delete_on_termination=true
  }
  user_data = count.index == 0 ? file("user_data_jenkins_master.sh") : file("user_data_jenkins_slave.sh")
  iam_instance_profile = count.index == 0 ? "" : "Administrator_Access"  # IAM Role to be attached to EC2
  
  lifecycle{
    prevent_destroy=false
    ignore_changes=[ ami ]
  }

  private_dns_name_options {
    enable_resource_name_dns_a_record    = true
    enable_resource_name_dns_aaaa_record = false
    hostname_type                        = "ip-name"
  }

  metadata_options { #Enabling IMDSv2
    http_endpoint = "enabled"
    http_tokens   = "required"
    http_put_response_hop_limit = 2
  }

  tags={
    Name = count.index == 0 ? "${var.name}-Master" : "${var.name}-Slave"
    Environment = var.env
    EBS-backed-AMI = "true"
  }
}

resource "aws_eip" "eip_associate_jenkins" {
  count = var.instance_count
  domain = "vpc"     ###vpc = true
}
resource "aws_eip_association" "eip_association_jenkins" {  ### I will use this EC2 behind the ALB.
  count         = var.instance_count
  instance_id   = aws_instance.jenkins[count.index].id
  allocation_id = aws_eip.eip_associate_jenkins[count.index].id
}

