# Specify the AWS provider and region
provider "aws" {
  region = "us-west-2" # Change this to your desired AWS region
}

# Frontend module (S3 + CloudFront)
module "frontend" {
  source      = "./modules/frontend"
  bucket_name = "job-portal-frontend-bucket"
}

# Backend module (API Gateway + Lambda)
module "backend" {
  source              = "./modules/backend"
  lambda_code_bucket  = "lambda-code-bucket"
  lambda_code_key     = "job-portal-backend.zip"
  db_host             = module.database.rds_endpoint
}



# Authentication module (Cognito)
module "authentication" {
  source = "./modules/authentication"
}

# Database module (RDS + DynamoDB)
module "database" {
  source      = "./modules/database"
  db_name     = var.db_name
  db_user     = var.db_user
  db_password = var.db_password
  subnet_1_id = aws_subnet.subnet_1.id
  subnet_2_id = aws_subnet.subnet_2.id
}


# Monitoring module (CloudWatch)
module "monitoring" {
  source = "./modules/monitoring"
}

# Backup module (AWS Backup for RDS and DynamoDB)
module "backup" {
  source = "./modules/backup"
}

