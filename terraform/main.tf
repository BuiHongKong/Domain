# -----------------------------------------------------------------------------
# Data sources (read-only lookups)
# -----------------------------------------------------------------------------
# These fetch existing or latest data from AWS; they do not create resources.
# -----------------------------------------------------------------------------

# Latest Amazon Linux 2 AMI in the chosen region.
# Used so we don't hardcode an AMI id that becomes outdated.
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

# Default VPC in your account (e.g. vpc-xxxxx).
# Using default VPC keeps this example simple; you can switch to a custom VPC
# by replacing this with a data source or resource for your VPC/subnet.
data "aws_vpc" "default" {
  default = true
}

# First available subnet in the default VPC (so EC2 gets a subnet in that VPC).
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# -----------------------------------------------------------------------------
# Security group
# -----------------------------------------------------------------------------
# Acts as a virtual firewall: controls inbound/outbound traffic for the EC2.
# We allow HTTP (80) for the web page and SSH (22) for admin; outbound is
# unrestricted so the instance can install packages and pull Docker images.
# -----------------------------------------------------------------------------

resource "aws_security_group" "web" {
  name        = "ec2-nginx-docker-sg"
  description = "Allow HTTP and SSH to EC2 running Nginx in Docker"
  vpc_id      = data.aws_vpc.default.id

  # Allow HTTP from anywhere (so you can open the page in a browser).
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP"
  }

  # Allow SSH from anywhere (restrict cidr_blocks in production).
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH"
  }

  # Allow all outbound (needed for yum, Docker pull, etc.).
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "All outbound"
  }
}

# -----------------------------------------------------------------------------
# EC2 instance
# -----------------------------------------------------------------------------
# Single instance that runs Docker and Nginx via user_data (cloud-init).
# user_data runs once at first boot: installs Docker, creates a simple HTML
# file, and runs the official Nginx image with that HTML mounted.
# -----------------------------------------------------------------------------

resource "aws_instance" "web" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = var.instance_type
  vpc_security_group_ids  = [aws_security_group.web.id]
  subnet_id              = tolist(data.aws_subnets.default.ids)[0]
  associate_public_ip_address = true

  # Script run at first boot (Amazon Linux 2 uses cloud-init).
  # Content comes from ../html/index.html in this repo (base64-encoded to avoid escaping).
  # See user_data.sh and "How to run Docker on it" in README.
  user_data = templatefile("${path.module}/user_data.sh", {
    index_html_b64 = base64encode(file("${path.module}/../html/index.html"))
  })

  # Ensure instance gets a new user_data if this block changes.
  user_data_replace_on_change = true

  tags = {
    Name = "ec2-nginx-docker"
  }
}
