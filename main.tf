terraform {
  required_providers {

    random = {
      source  = "hashicorp/random"
      version = "~> 3.1.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.2.0"
    }
  }

  required_version = "~> 1.0"
}

provider "aws" {
  region = var.aws_region
}

//To Zip the folder
data "archive_file" "lambda_hello_world" {
  type = "zip"

  source_dir  = "${path.module}/hello-world"
  output_path = "${path.module}/hello-world.zip"
}


locals {
  my_function_source = "./hello-world.zip"
}

//For S3
resource "aws_s3_bucket" "builds" {
  bucket = var.bucketname
  acl    = "private"
}

resource "aws_s3_bucket_object" "my_function" {
  bucket = aws_s3_bucket.builds.id
  key    = "${filemd5(local.my_function_source)}.zip"
  source = data.archive_file.lambda_hello_world.output_path
}

//For lambda 1
module "lambda_function_existing_package_s3" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = var.functionname1
  description   = "My Hello world lambda function"
  handler       = "hello.handler"
  runtime       = "nodejs12.x"

  publish = true

  create_package      = false
  s3_existing_package = {
    bucket = aws_s3_bucket.builds.id
    key    = aws_s3_bucket_object.my_function.id
  }

  allowed_triggers = {
    AllowExecutionFromAPIGateway = {
      service    = "apigateway"
      source_arn = "${module.api_gateway.apigatewayv2_api_execution_arn}/*/*"
    }
  }
}

//For lambda 2
module "lambda_function_existing_package_s3_2" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = var.functionname2
  description   = "My Learn world lambda function"
  handler       = "hello.handler2"
  runtime       = "nodejs12.x"

  publish = true

  create_package      = false
  s3_existing_package = {
    bucket = aws_s3_bucket.builds.id
    key    = aws_s3_bucket_object.my_function.id
  }

  allowed_triggers = {
    AllowExecutionFromAPIGateway = {
      service    = "apigateway"
      source_arn = "${module.api_gateway.apigatewayv2_api_execution_arn}/*/*"
    }
  }
}

// For API Gateway
module "api_gateway" {
  source = "terraform-aws-modules/apigateway-v2/aws"

  name          = var.gatewayname
  description   = "My HTTP API Gateway"
  protocol_type = "HTTP"

  cors_configuration = {
    allow_headers = ["content-type", "x-amz-date", "authorization", "x-api-key", "x-amz-security-token", "x-amz-user-agent"]
    allow_methods = ["*"]
    allow_origins = ["*"]
  }

  create_api_domain_name = false

  # Access logs
  default_stage_access_log_destination_arn = aws_cloudwatch_log_group.api_gw.arn
  default_stage_access_log_format          = "$context.identity.sourceIp - - [$context.requestTime] \"$context.httpMethod $context.routeKey $context.protocol\" $context.status $context.responseLength $context.requestId $context.integrationErrorMessage"

//OPENAPI v3 definition documents
  body = jsonencode({
    openapi = "3.0.1"
    info = {
      title   = "ulesson"
      version = "1.0"
    }
    paths = {
      "/hello" = {
        get = {
          x-amazon-apigateway-integration = {
            httpMethod           = "GET"
            payloadFormatVersion = "1.0"
            type                 = "AWS_PROXY"
            uri                  = module.lambda_function_existing_package_s3.lambda_function_arn
          }
        }
      }
      "/learn" = {
        get = {
          x-amazon-apigateway-integration = {
            httpMethod           = "GET"
            payloadFormatVersion = "1.0"
            type                 = "AWS_PROXY"
            uri                  = module.lambda_function_existing_package_s3_2.lambda_function_arn
          }
        }
      }

    }
  })
  tags = {
    Name = "http-apigateway"
  }
}

resource "aws_cloudwatch_log_group" "api_gw" {
  name = "/aws/lambda/${module.api_gateway.apigatewayv2_api_id}"

  retention_in_days = 30
}