variable "db_name" {
  description = "The name of the database"
  type        = string
}

variable "db_user" {
  description = "The username for the database"
  type        = string
}

variable "db_password" {
  description = "The password for the database"
  type        = string
  sensitive   = true
}

variable "subnet_1_id" {
  description = "ID of the first subnet for the RDS instance"
  type        = string
}

variable "subnet_2_id" {
  description = "ID of the second subnet for the RDS instance"
  type        = string
}
