# Lambda Function
output "emr_lambda_function_arn" {
  description = "The ARN of the Lambda Function"
  value       = try(aws_lambda_function.emr-trigger[0].arn, "")
}

output "emr_lambda_function_name" {
  description = "The name of the Lambda Function"
  value       = try(aws_lambda_function.emr-trigger[0].function_name, "")
}

# Lambda Function
output "batch_lambda_function_arn" {
  description = "The ARN of the Lambda Function"
  value       = try(aws_lambda_function.batch-trigger[0].arn, "")
}

output "batch_lambda_function_name" {
  description = "The name of the Lambda Function"
  value       = try(aws_lambda_function.batch-trigger[0].function_name, "")
}