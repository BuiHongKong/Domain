# EC2 + Docker + Nginx (Terraform)

Minimal Terraform stack: one EC2 instance with Docker and Nginx serving a simple HTML page.

## Prerequisites

- [Terraform](https://www.terraform.io/downloads) >= 1.0
- AWS CLI configured (`aws configure`) or env vars: `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_REGION`

## Workflow

**Phase 1 — Run Nginx with the HTML file (do this first)**  
Deploy the instance, get the public IP, and open the page in your browser. No domain needed.

1. Apply Terraform (see Usage below).
2. Wait 1–2 minutes for Docker and Nginx to start.
3. Get the URL: `terraform output url` (or `terraform output public_ip` and open `http://<ip>`).
4. Open that URL in your browser and confirm the landing page loads.

**Phase 2 — Add your own domain (when ready)**  
Once the page works at the IP, point your domain to the same instance. See [Adding your own DNS](#adding-your-own-dns).

## Usage

Navigate to the `terraform/` directory and run:

```bash
cd terraform
terraform init
terraform plan
terraform apply
```

After apply, wait 1–2 minutes for user_data to finish (Docker install + Nginx start). Then open the URL from the output:

```bash
terraform output url
```

## Adding your own DNS

1. Get the instance public IP: `terraform output public_ip`
2. In your DNS provider, create an **A record** pointing your domain (e.g. `www.example.com`) to that IP.
3. Optional: add Route53 + ACM + ALB in Terraform for HTTPS later.

## The HTML file

- **`html/index.html`** — The page Nginx serves. Edit this file and re-apply Terraform (with `user_data_replace_on_change = true` the instance is replaced so the new HTML is deployed).

## How to run Docker on it

**On the EC2 instance** (already done by Terraform user_data):

1. SSH in: `ssh ec2-user@<public_ip>` (use the key for the key pair you attached, if any; otherwise use Session Manager or add a key pair to the Terraform).
2. HTML is in `/var/www/html/index.html`. To change it: edit the file, then restart the container:
   ```bash
   sudo docker restart nginx
   ```
3. Useful Docker commands on the box:
   ```bash
   sudo docker ps              # see running containers (nginx)
   sudo docker logs nginx      # Nginx logs
   sudo docker restart nginx   # after editing /var/www/html
   ```

**Locally** (same HTML, no EC2):

From the repo root (where `html/` lives):

```bash
docker run -d -p 8080:80 -v "$(pwd)/html":/usr/share/nginx/html:ro --name nginx-local nginx:alpine
```

Open http://localhost:8080 . Stop with: `docker stop nginx-local && docker rm nginx-local`.

- `-p 8080:80` — host port 8080 → container port 80.
- `-v "$(pwd)/html":/usr/share/nginx/html:ro` — mount your `html/` folder as Nginx’s web root (read-only).
- So any change to `html/index.html` is reflected after refresh (no image rebuild).

## Project structure

```
.
├── terraform/          # All Terraform infrastructure code
│   ├── provider.tf     # AWS provider configuration
│   ├── variables.tf    # Input variables (region, instance type)
│   ├── main.tf         # EC2, security group, user_data
│   ├── outputs.tf      # Public IP, DNS, URL outputs
│   └── user_data.sh     # Cloud-init script template
└── html/               # Web content
    └── index.html      # Landing page (edit this!)
```

## Cleanup

From the `terraform/` directory:

```bash
terraform destroy
```
