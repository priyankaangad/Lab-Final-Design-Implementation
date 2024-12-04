# Define the API Gateway REST API
resource "aws_api_gateway_rest_api" "job_portal_api" {
  name        = "JobPortalAPI"
  description = "API Gateway for Job Portal"
}

# Define a resource for the 'users' path
resource "aws_api_gateway_resource" "users" {
  rest_api_id = aws_api_gateway_rest_api.job_portal_api.id
  parent_id   = aws_api_gateway_rest_api.job_portal_api.root_resource_id
  path_part   = "users"
}

# Define the GET method for the 'users' resource
resource "aws_api_gateway_method" "get_users" {
  rest_api_id   = aws_api_gateway_rest_api.job_portal_api.id
  resource_id   = aws_api_gateway_resource.users.id
  http_method   = "GET"
  authorization = "NONE"
}

# Define an integration for the GET method (Lambda integration)
resource "aws_api_gateway_integration" "get_users_integration" {
  rest_api_id             = aws_api_gateway_rest_api.job_portal_api.id
  resource_id             = aws_api_gateway_resource.users.id
  http_method             = aws_api_gateway_method.get_users.http_method
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = aws_lambda_function.get_users_function.invoke_arn
}


# Define the API Gateway deployment
resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = aws_api_gateway_rest_api.job_portal_api.id
  description = "Deployment for Job Portal API"

  # Force redeployment when resources change
  triggers = {
    redeployment = sha256(jsonencode({
      resource_id = aws_api_gateway_resource.users.id
      method      = aws_api_gateway_method.get_users.http_method
    }))
  }
}

# Define the API Gateway stage
resource "aws_api_gateway_stage" "stage" {
  rest_api_id   = aws_api_gateway_rest_api.job_portal_api.id
  deployment_id = aws_api_gateway_deployment.deployment.id
  stage_name    = "prod" # Can also be "dev" or other stage names
}

# Output the Invoke URL for the API Gateway
output "api_gateway_url" {
  description = "The invoke URL for the API Gateway"
  value       = aws_api_gateway_stage.stage.invoke_url
}
