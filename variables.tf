
variables "db_name" {
  type        = string
  default = "postgres"
}
variable "vpc_id" {}
variable "private_subnet_ids" {
  type = list(string)
}
variable "rds_sg_id" {
  type        = string
  default = "sg-062124e2fbb469f15"
}
variable "db_secret_arn" {
  description = "The ARN of the DB secret"
  type        = string
  default     = "arn:aws:secretsmanager:us-east-1:590184143815:secret:peformance-instance-password-6slJSy"
}
