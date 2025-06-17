resource "aws_cloudwatch_event_rule" "scheduled_trigger" {
  name                = "rds-scheduled-job"
  schedule_expression = "rate(1 day)" # or cron expression
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.scheduled_trigger.name
  target_id = "LambdaRDSJob"
  arn       = aws_lambda_function.rds_trigger_lambda.arn
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.rds_trigger_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.scheduled_trigger.arn
}
