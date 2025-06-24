# Create 7 EventBridge rules and targets
resource "aws_cloudwatch_event_rule" "lambda_schedule_rules" {
  count               = 7
  name                = "lambda-schedule-rule-${count.index + 1}"
  schedule_expression = "rate(1 day)" # or cron expression
}

resource "aws_cloudwatch_event_target" "lambda_targets" {
  count     = 7
  rule      = aws_cloudwatch_event_rule.lambda_schedule_rules[count.index].name
  target_id = "lambda-target-${count.index + 1}"
  arn       = aws_lambda_function.lambda_jobs[count.index].arn
}

resource "aws_lambda_permission" "allow_eventbridge" {
  count         = 7
  statement_id  = "AllowExecutionFromEventBridge${count.index + 1}"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_jobs[count.index].function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.lambda_schedule_rules[count.index].arn
}
