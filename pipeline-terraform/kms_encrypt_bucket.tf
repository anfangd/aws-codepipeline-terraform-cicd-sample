#============================================================
# 2. CodePipeline - KMS
#============================================================
resource "aws_kms_key" "encryption_key" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
  policy                  = data.aws_iam_policy_document.kms_key_policy_doc.json
  enable_key_rotation     = true
}

data "aws_iam_policy_document" "kms_key_policy_doc" {
  depends_on = [
    aws_iam_role.codepipeline_role
  ]
  statement {
    sid     = "Enable IAM User Permissions"
    effect  = "Allow"
    actions = ["kms:*"]
    #checkov:skip=CKV_AWS_111:Without this statement, KMS key cannot be managed by root
    #checkov:skip=CKV_AWS_109:Without this statement, KMS key cannot be managed by root
    resources = ["*"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${local.account_id}:root"]
    }
  }

  statement {
    sid       = "Allow access for Key Administrators"
    effect    = "Allow"
    actions   = ["kms:*"]
    resources = ["*"]

    principals {
      type = "AWS"
      identifiers = [
        aws_iam_role.codepipeline_role.arn
      ]
    }
  }

  statement {
    sid    = "Allow use of the key"
    effect = "Allow"
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
    resources = ["*"]

    principals {
      type = "AWS"
      identifiers = [
        aws_iam_role.codepipeline_role.arn
      ]
    }
  }

  statement {
    sid    = "Allow attachment of persistent resources"
    effect = "Allow"
    actions = [
      "kms:CreateGrant",
      "kms:ListGrants",
      "kms:RevokeGrant"
    ]
    resources = ["*"]

    principals {
      type = "AWS"
      identifiers = [
        aws_iam_role.codepipeline_role.arn
      ]
    }

    condition {
      test     = "Bool"
      variable = "kms:GrantIsForAWSResource"
      values   = ["true"]
    }
  }
}

resource "aws_iam_policy" "codepipeline_kms_policy" {
  name        = "${var.system_name}-codepipeline-kms-policy"
  description = "Policy to allow codepipeline to execute"
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
         "kms:DescribeKey",
         "kms:GenerateDataKey*",
         "kms:Encrypt",
         "kms:ReEncrypt*",
         "kms:Decrypt"
      ],
      "Resource": "${aws_kms_key.encryption_key.arn}"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "codepipeline_role_kms_attach" {
  role       = aws_iam_role.codepipeline_role.name
  policy_arn = aws_iam_policy.codepipeline_kms_policy.arn
}
