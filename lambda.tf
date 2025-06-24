resource "aws_security_group" "lambda_sg" {
  name   = "lambda-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    security_groups = [var.rds_sg_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

locals {
  stored_procedures = [
    "svc_registration_migration.p_s3translation_all(1, 'motus-dev-data-translation', 2)",
    "svc_registration_migration.p_s3translation_all(2, 'motus-dev-data-translation', 2)",
    "svc_registration_migration.p_s3translation_all(3, 'motus-dev-data-translation', 2)",
    "svc_registration_migration.p_s3translation_all(4, 'motus-dev-data-translation', 2)",
    "svc_registration_migration.p_s3translation_all(5, 'motus-dev-data-translation', 2)",
    "svc_registration_migration.p_s3translation_all(6, 'motus-dev-data-translation', 2)",
    "svc_registration_migration.p_s3translation_all(7, 'motus-dev-data-translation', 2)"
  ]
}

resource "aws_lambda_function" "lambda_jobs" {
  count         = 7
  function_name = "stored-proc-job-${count.index + 1}"
  handler       = "lambda.lambda_handler"
  runtime       = "python3.12"
  role          = aws_iam_role.lambda_exec.arn
  filename      = "lambda.zip"
  timeout       = 60
  source_code_hash = filebase64sha256("lambda.zip")

  environment {
    variables = {
      DB_SECRET_ARN = var.db_secret_arn
      AWS_REGION    = "us-east-1"
      DB_NAME = var.db_name
      STORED_PROCEDURE = local.stored_procedures[count.index]
    }
  }


  vpc_config {
    subnet_ids         = var.private_subnet_ids
    security_group_ids = [aws_security_group.lambda_sg.id]
  }

  timeout = 10
}
