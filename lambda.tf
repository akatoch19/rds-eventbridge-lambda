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

resource "aws_lambda_function" "rds_trigger_lambda" {
  filename         = "lambda.zip"
  function_name    = "rds_trigger_lambda"
  role             = aws_iam_role.lambda_exec_role.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.9"
  source_code_hash = filebase64sha256("lambda.zip")

  environment {
    variables = {
      DB_SECRET_ARN = "arn:aws:secretsmanager:region:account-id:secret:your-secret"
      AWS_REGION    = "your-region"
      DB_HOST = var.db_host
      DB_NAME = var.db_name
      DB_PORT = var.db_port

    }
  }


  vpc_config {
    subnet_ids         = var.private_subnet_ids
    security_group_ids = [aws_security_group.lambda_sg.id]
  }

  timeout = 10
}
