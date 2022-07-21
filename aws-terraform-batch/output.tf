output "compute_environment_arn" {
  value       = aws_batch_compute_environment.compute_environment.arn
  description = "The arn for your compute environment"
}

output "compute_environment_name" {
  value       = aws_batch_compute_environment.compute_environment.compute_environment_name
  description = "The name for your compute environment"
}


output "compute_environment_state" {
  value       = aws_batch_compute_environment.compute_environment.state
  description = "The state of the compute environment. If the state is ENABLED, then the compute environment accepts jobs from a queue and can scale out automatically based on queues. Valid items are ENABLED or DISABLED. Defaults to ENABLED."
}



output "container_properties" {
  value       = data.template_file.container_properties[*].rendered
  description = "Fargate Container properties"
}

output "batch_lambda_function_arn" {
  description = "The ARN of the Lambda Function"
  value       = try(aws_lambda_function.batch-trigger[0].arn, "")
}