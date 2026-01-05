output "ECR_URI_jenkins_master_and_slave_ec2_private_ip_and_alb_dns_name" {
  description = "Details of the ECR URI, Jenkins-Master, Jenkins-Slave Private IP and Jenkins ALB DNS Name"
  value       = "${module.jenkins}"
}
