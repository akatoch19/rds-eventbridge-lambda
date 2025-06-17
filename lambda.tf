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

  timeout = 10
}
