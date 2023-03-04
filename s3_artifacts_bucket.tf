#============================================================
# 3. S3 Bucket for storing pipeline Artifacts
#============================================================
# Artifacts Bucket
resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket_prefix = regex("[a-z0-9.-]+", lower(var.system_name))
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "codepipeline_bucket" {
  bucket                  = aws_s3_bucket.codepipeline_bucket.id
  ignore_public_acls      = true
  restrict_public_buckets = true
  block_public_acls       = true
  block_public_policy     = true
}

resource "aws_s3_bucket_policy" "codepipeline_bucket" {
  bucket = aws_s3_bucket.codepipeline_bucket.id
  policy = data.aws_iam_policy_document.bucket_policy_doc_codepipeline_bucket.json
}

data "aws_iam_policy_document" "bucket_policy_doc_codepipeline_bucket" {
  statement {
    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.codepipeline_role.arn]
    }

    actions = [
      "s3:Get*",
      "s3:List*",
      "s3:ReplicateObject",
      "s3:PutObject",
      "s3:RestoreObject",
      "s3:PutObjectVersionTagging",
      "s3:PutObjectTagging",
      "s3:PutObjectAcl"
    ]

    resources = [
      aws_s3_bucket.codepipeline_bucket.arn,
      "${aws_s3_bucket.codepipeline_bucket.arn}/*",
    ]
  }
}

resource "aws_s3_bucket_acl" "codepipeline_bucket" {
  bucket = aws_s3_bucket.codepipeline_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "codepipeline_bucket" {
  bucket = aws_s3_bucket.codepipeline_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "codepipeline_bucket" {
  bucket = aws_s3_bucket.codepipeline_bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.encryption_key.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_logging" "codepipeline_bucket" {
  bucket        = aws_s3_bucket.codepipeline_bucket.id
  target_bucket = aws_s3_bucket.codepipeline_bucket.id
  target_prefix = "log/"
}

resource "aws_iam_policy" "codepipeline_s3_policy" {
  name        = "${var.system_name}-codepipeline-s3-policy"
  description = "Policy to allow codepipeline to execute"
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect":"Allow",
      "Action": [
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:PutObjectAcl",
        "s3:PutObject"
      ],
      "Resource": "${aws_s3_bucket.codepipeline_bucket.arn}/*"
    },
    {
      "Effect":"Allow",
      "Action": [
        "s3:GetBucketVersioning"
      ],
      "Resource": "${aws_s3_bucket.codepipeline_bucket.arn}"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "codepipeline_role_s3_attach" {
  role       = aws_iam_role.codepipeline_role.name
  policy_arn = aws_iam_policy.codepipeline_s3_policy.arn
}
