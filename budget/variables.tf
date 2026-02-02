# -----------------------------------------------------------------------------
# Input variables for AWS Budget
# -----------------------------------------------------------------------------

variable "aws_region" {
  description = "AWS region for Budgets API (us-east-1 typical for billing)."
  type        = string
  default     = "ap-southeast-1"
}

variable "budget_name" {
  description = "Name of the cost budget."
  type        = string
  default     = "monthly-cost-budget"
}

variable "budget_amount" {
  description = "Monthly budget limit in USD."
  type        = string
  default     = "10"
}

variable "alert_email" {
  description = "Email to receive budget alerts (Actual and Forecasted)."
  type        = string
  default     = "buihongkong2503@gmail.com"
}
