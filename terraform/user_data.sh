#!/bin/bash
# -----------------------------------------------------------------------------
# Cloud-init script: install Docker, deploy HTML from Terraform, run Nginx.
# The HTML is passed as base64 (index_html_b64) so special chars don't break the script.
# -----------------------------------------------------------------------------
set -e
yum update -y
yum install -y docker
systemctl start docker
systemctl enable docker
mkdir -p /var/www/html
echo "${index_html_b64}" | base64 -d > /var/www/html/index.html
docker run -d -p 80:80 -v /var/www/html:/usr/share/nginx/html:ro --name nginx --restart unless-stopped nginx:alpine
