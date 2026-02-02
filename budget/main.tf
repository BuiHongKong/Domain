# -----------------------------------------------------------------------------
# AWS Cost Budget
# -----------------------------------------------------------------------------
# Monitors AWS spend and alerts when Actual or Forecasted costs exceed threshold.
# -----------------------------------------------------------------------------

resource "aws_budgets_budget" "cost" {
  name         = var.budget_name
  budget_type  = "COST"
  limit_amount     = var.budget_amount
  limit_unit       = "USD"
  time_unit        = "MONTHLY"
  time_period_end  = "2087-06-15_00:00"

  # Alert when actual spend exceeds 80%
  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 80
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = [var.alert_email]
  }

  # Alert when forecasted spend exceeds 100%
  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 100
    threshold_type             = "PERCENTAGE"
    notification_type          = "FORECASTED"
    subscriber_email_addresses = [var.alert_email]
  }
}
