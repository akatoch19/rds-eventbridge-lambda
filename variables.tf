
variables "db_name" {}
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
}
