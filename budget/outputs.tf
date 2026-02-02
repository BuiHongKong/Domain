# -----------------------------------------------------------------------------
# Budget outputs
# -----------------------------------------------------------------------------

output "budget_arn" {
  description = "ARN of the created budget."
  value       = aws_budgets_budget.cost.arn
}

output "budget_name" {
  description = "Name of the budget."
  value       = aws_budgets_budget.cost.name
}
