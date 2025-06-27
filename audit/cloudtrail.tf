############################################
# CloudTrail + secure log bucket (Terraform)
############################################

# Unique suffix for the bucket name
resource "random_id" "rand" {
  byte_length = 4
}

# 1. S3 bucket to receive CloudTrail logs
resource "aws_s3_bucket" "ct_logs" {
  bucket        = "my-cloudtrail-logs-${random_id.rand.hex}"
  force_destroy = true           # demo-friendly cleanup
  tags = {
    Name = "cloudtrail-logs"
  }
}

# 2. Block every form of public access
resource "aws_s3_bucket_public_access_block" "ct_logs" {
  bucket = aws_s3_bucket.ct_logs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# 3. Disable ACLs entirely (BucketOwnerEnforced)
resource "aws_s3_bucket_ownership_controls" "ct_logs" {
  bucket = aws_s3_bucket.ct_logs.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

# 4. Bucket policy that lets CloudTrail write logs
data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "ct_bucket_policy" {
  statement {
    sid       = "AWSCloudTrailAclCheck"
    effect    = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions   = ["s3:GetBucketAcl"]
    resources = [aws_s3_bucket.ct_logs.arn]
  }

  statement {
    sid       = "AWSCloudTrailWrite"
    effect    = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions   = ["s3:PutObject"]
    resources = [
      "${aws_s3_bucket.ct_logs.arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"
    ]
  }
}

resource "aws_s3_bucket_policy" "ct_logs" {
  bucket = aws_s3_bucket.ct_logs.id
  policy = data.aws_iam_policy_document.ct_bucket_policy.json
}

# 5. Multi-region CloudTrail trail (waits for bucket policy & ownership controls)
resource "aws_cloudtrail" "main" {
  name                          = "AccountTrail"
  s3_bucket_name                = aws_s3_bucket.ct_logs.id
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_logging                = true

  depends_on = [
    aws_s3_bucket_policy.ct_logs,
    aws_s3_bucket_ownership_controls.ct_logs
  ]
}
