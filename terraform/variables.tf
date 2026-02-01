# -----------------------------------------------------------------------------
# Input variables
# -----------------------------------------------------------------------------
# Variables let you change behaviour without editing .tf files. Override via
# -var "name=value", TF_VAR_name env vars, or a .tfvars file.
# -----------------------------------------------------------------------------

variable "aws_region" {
  description = "AWS region where resources will be created (e.g. us-east-1)."
  type        = string
  default     = "ap-southeast-1"
}

variable "instance_type" {
  description = "EC2 instance type. t3.micro is free-tier eligible in many regions."
  type        = string
  default     = "t3.micro"
}

# -----------------------------------------------------------------------------
# DNS (for later)
# -----------------------------------------------------------------------------
# When you add your own domain, you can create a variable here and use it
# in a route53_zone / route53_record resource, or simply point your domain's
# A record to the EC2 public_ip output.
# Example:
#   variable "domain" { type = string }
#   # Then create aws_route53_record pointing to aws_instance.web.private_ip
#   # or use the public IP and create an A record in your DNS provider.
# -----------------------------------------------------------------------------
