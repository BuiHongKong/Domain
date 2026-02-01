# -----------------------------------------------------------------------------
# Outputs
# -----------------------------------------------------------------------------
# Values printed after apply. Use these to get the instance URL and, later,
# to point your DNS A record (e.g. www.example.com -> public_ip).
# -----------------------------------------------------------------------------

output "public_ip" {
  description = "Public IP of the EC2 instance. Use this in your browser (http://<this_ip>) or as the target for your DNS A record."
  value       = aws_instance.web.public_ip
}

output "public_dns" {
  description = "Public DNS name assigned by AWS (e.g. ec2-x-x-x-x.compute.amazonaws.com). You can use this or your own domain later."
  value       = aws_instance.web.public_dns
}

output "url" {
  description = "Direct URL to the simple HTML page (once the instance has finished user_data, ~1–2 minutes)."
  value       = "http://${aws_instance.web.public_ip}"
}

# -----------------------------------------------------------------------------
# Adding your own DNS later
# -----------------------------------------------------------------------------
# 1. In your DNS provider (Route53, Cloudflare, etc.), create an A record:
#    Name: www (or @ for apex)   Type: A   Value: <public_ip from above>
# 2. Optional: add HTTPS with a certificate (e.g. ACM + ALB, or certbot on EC2).
# 3. Optional: use Terraform aws_route53_zone + aws_route53_record to manage
#    the record; then you'd reference aws_instance.web.public_ip as the value.
# -----------------------------------------------------------------------------
