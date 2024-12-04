resource "aws_s3_bucket" "frontend_bucket" {
  bucket        = var.bucket_name
  acl           = "private"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  lifecycle_rule {
    id      = "move-old-versions"
    enabled = true

    noncurrent_version_transition {
      storage_class = "GLACIER"
      days          = 30
    }
  }
}

resource "aws_s3_bucket_policy" "frontend_policy" {
  bucket = aws_s3_bucket.frontend_bucket.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "s3:GetObject"
        Effect   = "Allow"
        Resource = "${aws_s3_bucket.frontend_bucket.arn}/*"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
      }
    ]
  })
}

# resource "aws_s3_object" "lambda_function" {
#   bucket = "job-portal-frontend-bucket"  # Replace with your bucket name
#   key    = "lambda_function.zip"        # File path in the bucket
#   source = "lambda_function.zip" # Local file path to your zip file
#   acl    = "private"                    # Set access control
# }

