variables "db_host" {}
variables "db_name" {}
variables "db_port" {}
variable "vpc_id" {}
variable "private_subnet_ids" {
  type = list(string)
}
variable "rds_sg_id" {}
