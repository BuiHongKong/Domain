# AWS Budget (Terraform)

Cost budget để nhận alert khi chi phí vượt hoặc dự báo vượt ngưỡng.

## Cần có

- AWS credentials (`aws configure` hoặc env vars)
- Email để nhận alert

## Chạy

```bash
cd budget
terraform init
terraform plan -var="alert_email=your@email.com"
terraform apply -var="alert_email=your@email.com"
```

Hoặc dùng file `.tfvars`:

```hcl
# budget.auto.tfvars (không commit file này nếu chứa email thật)
alert_email   = "your@email.com"
budget_amount = "10"
budget_name   = "monthly-cost-budget"
```

```bash
terraform apply -auto-approve
```

## Biến

| Biến | Mô tả | Mặc định |
|------|-------|----------|
| `alert_email` | Email nhận alert | **(bắt buộc)** |
| `budget_amount` | Giới hạn budget/tháng (USD) | `10` |
| `budget_name` | Tên budget | `monthly-cost-budget` |
| `aws_region` | Region cho Budgets API | `us-east-1` |

## Alert

- **Actual** – gửi khi chi phí thực tế > 80% budget
- **Forecasted** – gửi khi dự báo chi phí > 100% budget
