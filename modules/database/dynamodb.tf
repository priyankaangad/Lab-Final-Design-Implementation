resource "aws_dynamodb_table" "job_table" {
  name         = "JobTable"
  hash_key     = "job_id"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "job_id"
    type = "S"
  }
}
