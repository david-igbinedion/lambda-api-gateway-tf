# Output value definitions

output "lambda_bucket_name" {
  description = "Name of the S3 bucket used to store function code."

  value = aws_s3_bucket.builds.id
}

output "function_name" {
  description = "Name of the Lambda function."

  value = module.lambda_function_existing_package_s3.lambda_function_name
}

output "function_name2" {
  description = "Name of the Lambda function."

  value = module.lambda_function_existing_package_s3_2.lambda_function_name
}

output "base_url" {
  description = "Base URL for API Gateway stage."

  value = module.api_gateway. default_apigatewayv2_stage_invoke_url
}
