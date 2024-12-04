# Variables for S3 Bucket and Lambda Deployment
variable "lambda_code_bucket" {
  description = "S3 bucket containing the Lambda deployment package"
  type        = string
}

variable "lambda_code_key" {
  description = "Path to the Lambda deployment package in the S3 bucket"
  type        = string
}

variable "db_host" {
  description = "Database host for the Lambda function"
  type        = string
}
