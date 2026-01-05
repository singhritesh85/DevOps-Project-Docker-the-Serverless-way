output "ecs_cluster_name" {
  description = "The name of the created ECS cluster."
  value       = aws_ecs_cluster.ecs_cluster.name
}

output "task_definition_arn_bankapp" {
  description = "Full ARN of the Task Definition (including both family and revision)."
  value       = aws_ecs_task_definition.ecs_task_definition.arn
}

output "task_definition_family_bankapp" {
  description = "The family of the Task Definition."
  value       = aws_ecs_task_definition.ecs_task_definition.family
}

output "task_definition_revision_bankapp" {
  description = "The revision of the task in a particular family."
  value       = aws_ecs_task_definition.ecs_task_definition.revision
}

output "ecs_service_arn_bankapp" {
  description = "The ARN of the ECS service."
  value       = aws_ecs_service.ecs_service.arn
}

output "rds_endpoint" {
  description = "The connection endpoint for the created RDS instance"
  value       = aws_db_instance.dbinstance2.endpoint
}
