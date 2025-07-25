resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda-rds-exec-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Effect    = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_policy_attachment" "lambda_basic_exec" {
  name       = "attach-basic-exec"
  roles      = [aws_iam_role.lambda_exec_role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# (Optional) SecretManager access
resource "aws_iam_policy" "secret_access" {
  name        = "LambdaSecretAccess"
  description = "Allow access to DB secret"
  policy      = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect   = "Allow",
      Action   = ["secretsmanager:GetSecretValue"],
      Resource = "*" # Or limit to your secret
    }]
  })
}

resource "aws_iam_policy_attachment" "secret_attach" {
  name       = "attach-secret"
  roles      = [aws_iam_role.lambda_exec_role.name]
  policy_arn = aws_iam_policy.secret_access.arn
}
