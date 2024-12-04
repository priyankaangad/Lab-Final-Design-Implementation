resource "aws_lambda_function" "get_users_function" {
  function_name = "GetUsersFunction"
  runtime       = "python3.9"
  role          = aws_iam_role.lambda_exec.arn
  handler       = "lambda_function.lambda_handler"

  # Reference your bucket in us-west-2
  s3_bucket = "job-portal-frontend-bucket"
  s3_key    = "lambda_function.zip"

  environment {
    variables = {
      DB_HOST = var.db_host
    }
  }
}


resource "aws_iam_role" "lambda_exec" {
  name               = "lambda_execution_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action    = "sts:AssumeRole",
        Effect    = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "lambda_policy" {
  name        = "lambda_execution_policy"
  description = "IAM policy for Lambda function to access required services"
  policy      = jsonencode({
    Version = "2012-10-17",
    Statement = [
      # CloudWatch Logs Permissions
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Effect   = "Allow",
        Resource = "arn:aws:logs:*:*:*"
      },

      # RDS Permissions
      {
        Action = [
          "rds:DescribeDBInstances",
          "rds:Connect"
        ],
        Effect   = "Allow",
        Resource = "*"
      },

      # S3 Permissions
      {
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ],
        Effect   = "Allow",
        Resource = [
          "arn:aws:s3:::job-portal-frontend-bucket",
          "arn:aws:s3:::job-portal-frontend-bucket/*"
        ]
      },

      # Lambda Invocation Permissions
      {
        Action = "lambda:InvokeFunction",
        Effect = "Allow",
        Resource = "arn:aws:lambda:*:*:function:*"
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}


resource "aws_lambda_permission" "api_gateway_invoke" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.get_users_function.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:us-west-2:183631347930:f3cgb09lb8/*/GET/users"
}

