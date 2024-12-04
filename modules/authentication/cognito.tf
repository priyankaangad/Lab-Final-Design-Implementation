resource "aws_cognito_user_pool" "job_portal_pool" {
  name = "JobPortalUserPool"

  password_policy {
    minimum_length    = 8
    require_lowercase = true
    require_numbers   = true
  }
}
