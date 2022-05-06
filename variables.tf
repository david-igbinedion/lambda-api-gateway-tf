# Input variable definitions

variable "aws_region" {
  description = "AWS region for all resources."

  type    = string
  default = "us-east-1"
}


variable "bucketname" {
  type = string
  default = "home-test-tf-bucket-igb"
}

variable "functionname1" {
  type = string
  default = "hello-world"
}

variable "functionname2" {
  type = string
  default = "learn-world"
}

variable "gatewayname" {
  type = string
  default = "ulesson"
}




