#============================================================
# 4. CodeBuild
#============================================================

resource "aws_codebuild_project" "terraform_codebuild_project" {

  name           = "${var.system_name}-plan"
  service_role   = aws_iam_role.codepipeline_role.arn
  encryption_key = aws_kms_key.encryption_key.arn
  artifacts {
    type = var.build_project_source
  }
  environment {
    compute_type                = var.builder_compute_type
    image                       = var.builder_image
    type                        = var.builder_type
    privileged_mode             = true
    image_pull_credentials_type = var.builder_image_pull_credentials_type
  }
  logs_config {
    cloudwatch_logs {
      status = "ENABLED"
    }
  }
  source {
    type      = var.build_project_source
    buildspec = "./ci/terraform/buildspec_plan.yml"
  }
}

resource "aws_iam_policy" "codepipeline_codebuild_policy" {
  name        = "${var.system_name}-codepipeline-codebuild-policy"
  description = "Policy to allow codepipeline to execute"
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "codebuild:BatchGetBuilds",
        "codebuild:StartBuild",
        "codebuild:BatchGetProjects"
      ],
      "Resource": "arn:aws:codebuild:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:project/${var.system_name}*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "codebuild:CreateReportGroup",
        "codebuild:CreateReport",
        "codebuild:UpdateReport",
        "codebuild:BatchPutTestCases"
      ],
      "Resource": "arn:aws:codebuild:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:report-group/${var.system_name}*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "codepipeline_role_codebuild_attach" {
  role       = aws_iam_role.codepipeline_role.name
  policy_arn = aws_iam_policy.codepipeline_codebuild_policy.arn
}
