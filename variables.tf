
variables "db_name" {}
variable "vpc_id" {}
variable "private_subnet_ids" {
  type = list(string)
}
variable "rds_sg_id" {}
variable "db_secret_arn" {
  description = "The ARN of the DB secret"
  type        = string
}
