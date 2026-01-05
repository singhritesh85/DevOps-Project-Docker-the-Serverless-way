output "jenkins_master_and_slave_private_ip" {
  description = "The private IP address of the Jenkins Master and Slave EC2 instance"
  value       = aws_instance.jenkins.*.private_ip
}

output "jenkins_alb_dns_name" {
  description = "The DNS name of the Jenkins application load balancer"
  value       = aws_lb.test-application-loadbalancer_alb.dns_name
}

output "ecr_repository_uri" {
  description = "The URI of the ECR repository"
  value       = aws_ecr_repository.ecr.repository_url
}
