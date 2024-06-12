output "repository_url" {
  value = aws_ecr_repository.my_app_repo.repository_url
}
# output "service_public_ip" {
#   value = aws_ecs_task_definition.task_definition.network_mode == "awsvpc" ? "http://${aws_ecs_task_definition.task_definition.network_configuration[0].aws_vpc_configuration[0].public_ip}" : null
# }
# Output the ALB DNS name
output "alb_dns_name" {
  value = aws_lb.my_alb.dns_name
}

# Output ECS service details
output "ecs_service_details" {
  value = aws_ecs_service.my_alb_service
}