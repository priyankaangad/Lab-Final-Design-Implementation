# DB Subnet Group
resource "aws_db_subnet_group" "db_subnet_group" {
  name        = "db-subnet-group"
  description = "Subnet group for RDS instance"
  subnet_ids  = [var.subnet_1_id, var.subnet_2_id] # Subnet IDs passed as variables

  tags = {
    Name = "db-subnet-group"
  }
}

# RDS Instance
resource "aws_db_instance" "job_portal_db" {
  allocated_storage      = 20
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  db_name                = var.db_name
  username               = var.db_user
  password               = var.db_password
  publicly_accessible    = false
  multi_az               = true
  skip_final_snapshot    = true
  backup_retention_period = 7
  storage_encrypted       = true

  # Associate with DB Subnet Group
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name

  # Monitoring and Tags
  monitoring_interval    = 0
}

# Outputs
output "db_instance_endpoint" {
  description = "The connection endpoint of the RDS instance"
  value       = aws_db_instance.job_portal_db.endpoint
}

output "db_instance_arn" {
  description = "The ARN of the RDS instance"
  value       = aws_db_instance.job_portal_db.arn
}
# output "api_gateway_url" {
#   description = "The invoke URL for the API Gateway"
#   value       = aws_api_gateway_stage.stage.invoke_url
# }

resource "aws_api_gateway_rest_api" "api" {
  name = "job-portal-api"
}

resource "aws_api_gateway_resource" "resource" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "users"
}

resource "aws_api_gateway_method" "method" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.resource.id
  http_method   = "POST"
  authorization = "NONE"
}

# resource "aws_api_gateway_integration" "integration" {
#   rest_api_id = aws_api_gateway_rest_api.api.id
#   resource_id = aws_api_gateway_resource.resource.id
#   http_method = aws_api_gateway_method.method.http_method
#   type        = "AWS_PROXY"
#   integration_http_method = "POST"
#   uri = aws_lambda_function.get_users_function.invoke_arn
# }



