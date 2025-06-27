# AWS IAM Security Automation with Terraform

This project secures a fresh AWS account in under 5 minutes: **strong password policy, MFA-enforced role-based groups, and CloudTrail logging to a private S3 bucket**, all defined in Terraform.

![Architecture Diagram](/docs/diagram.png)

## Key Features
- **Least-privilege IAM groups** (`Developers`, `Operations`, `Finance`, `SecurityAuditors`)
- **MFA-gatekeeper policy** — denies *all* console/API calls unless MFA is present
- **Account-wide password policy** — 12 chars, complexity, 90-day rotation
- **Multi-region CloudTrail** — logs to S3 bucket with BucketOwnerEnforced ownership
- **100% Infrastructure-as-Code**

## Prerequisites
| Tool | Tested version |
|------|----------------|
| Terraform | 1.12.2 |
| AWS CLI | 2.27.42 |
| Windows 10/11 PowerShell | built-in |

## Quick Start
```powershell
git clone https://github.com/KacperKolasa/iam-secure-aws.git
cd aws-iam-secure
terraform init
terraform apply
```

# How to Test the IAM-Secure-AWS Stack

> **Total time:** ~ 10 minutes  
> **Profiles used:**  
> • `admin-terraform` – full admin for setup/inspection  
> • `alice` – Developer group user (starts with *no* MFA)

---

## 1  Verify the Password-Policy Baseline
```bash
aws iam get-account-password-policy --profile admin-terraform
```
Expect output containing:
```"MinimumPasswordLength": 12,
        "RequireSymbols": true,
        "RequireNumbers": true,
        "RequireUppercaseCharacters": true,
        "RequireLowercaseCharacters": true,
        "AllowUsersToChangePassword": true,
        "ExpirePasswords": true,
        "MaxPasswordAge": 90,
        "PasswordReusePrevention": 5
```

---

## 2  Confirm the MFA Gate Is Attached
```bash
aws iam list-groups-for-user --user-name alice --profile admin-terraform

aws iam list-attached-group-policies --group-name Developers --profile admin-terraform
```
The output from the second command must contain **EnforceMFA**.

---

## 3  Attempt S3 _before_ Enrolling MFA
Using the AWS console, sign in as **alice** (skip MFA setup) and attempt to view all available S3 buckets.
It should notify you that access is denied.

---

## 4  Enable a Virtual MFA Device  
Console path: **IAM ▸ Users ▸ alice ▸ Security credentials ▸ Assign MFA device ▸ Virtual MFA** 
Then, scan the QR-code with Google Authenticator (or similar) and enter the two codes to setup MFA.

---

## 5  Re-try the Blocked Action
Now, once you have enabled MFA for that user, attempt to list all S3 buckets once again.
Now, it should correctly display all available buckets.

---

## 6  Check Least-Privilege Scope
```bash
aws organizations list-accounts --profile alice   # Should show AccessDenied
aws ec2 describe-instances --profile alice   # Should be allowed
```
Shows that PowerUser actions work, wider admin calls do not.
``Note: in order to use --profile alice, that profile has to first be configured in the CLI``

---

## 7  Verify CloudTrail Logging
1. Console -> **CloudTrail ▸ Event history** -> filter by user **alice**.  
   You should see (chronological):  
   * `ConsoleLogin` (MFA = “No”)  
   * `ListAllMyBuckets` – **Denied**  
   * `EnableMFADevice` 
   * `ListAllMyBuckets` – **Success**

2. Check the S3 log bucket from  
   ``bash
   terraform output cloudtrail_bucket
   ``
   Within a few minutes new files appear under  
   `AWSLogs/<account-id>/CloudTrail/...`

---