# AWS IAM Security Automation with Terraform

This project secures a fresh AWS account in under 5 minutes: **strong password policy, MFA-enforced role-based groups, and CloudTrail logging to a private S3 bucket**, all defined in Terraform.

[Architecture Diagram](docs/architecture.mmd)

## ✨ Key Features
- **Least-privilege IAM groups** (`Developers`, `Operations`, `Finance`, `SecurityAuditors`)
- **MFA-gatekeeper policy** — denies *all* console/API calls unless MFA is present
- **Account-wide password policy** — 12 chars, complexity, 90-day rotation
- **Multi-region CloudTrail** — logs to S3 bucket with BucketOwnerEnforced ownership
- **100% Infrastructure-as-Code**

## 🖥️ Prerequisites
| Tool | Tested version |
|------|----------------|
| Terraform | 1.12.2 |
| AWS CLI | 2.27.42 |
| Windows 10/11 PowerShell | built-in |

## 🚀 Quick Start
```powershell
git clone https://github.com/kacperkolasa/aws-iam-secure.git
cd aws-iam-secure
terraform init
terraform apply
```