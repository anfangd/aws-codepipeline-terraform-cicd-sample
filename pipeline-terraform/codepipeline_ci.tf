#============================================================
# 5. CodePipeline - CI
#============================================================
resource "aws_codepipeline" "terraform_ci" {

  name     = "${var.system_name}-terraform-ci"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.codepipeline_bucket.bucket
    type     = "S3"
    encryption_key {
      id   = aws_kms_key.encryption_key.arn
      type = "KMS"
    }
  }

  stage {
    # [aws_codepipeline | Resources | hashicorp/aws | Terraform Registry](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codepipeline)
    name = "Source"

    action {
      name             = "DownloadSource"
      category         = "Source"
      owner            = "AWS"
      version          = "1"
      provider         = "CodeStarSourceConnection"
      namespace        = "SourceVariables"
      output_artifacts = ["SourceOutput"]
      run_order        = 1

      configuration = {
        ConnectionArn    = "arn:aws:codestar-connections:ap-northeast-1:687705090937:connection/ed0adb1b-4068-4f14-8b10-5a930b2268d0"
        FullRepositoryId = var.github_source_repo
        BranchName       = var.github_source_repo_branch
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "StaticAnalysis"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["SourceOutput"]
      output_artifacts = ["BuildOutput"]
      version          = "1"
      run_order        = "2"

      configuration = {
        ProjectName = aws_codebuild_project.terraform_codebuild_project.name
      }
    }
  }
}
