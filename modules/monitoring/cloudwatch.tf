resource "aws_cloudwatch_log_group" "lambda_logs" {
  name              = "/aws/lambda/job-portal"
  retention_in_days = 30
}
