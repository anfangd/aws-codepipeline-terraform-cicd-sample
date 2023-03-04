variable "system_name" {
  description = "Unique name for this product"
  type        = string
}

variable "github_source_repo" {
  description = "Sourse repo name of the GitHub repository"
  type        = string
}

variable "github_source_repo_branch" {
  description = "Default branch in the Source repo for which CodePipeline needs to be configured"
  type        = string
  default     = "main"
}

variable "environment" {
  description = "Environment in which the script is run. Eg: dev, stg, prd, etc"
  type        = string
}

variable "builder_compute_type" {
  description = "Relative path to the Apply and Destroy"
  type        = string
  default     = "BUILD_GENERAL1_SMALL"
}

variable "builder_image" {
  description = "Docker Image to be used by codebuild"
  type        = string
  default     = "687705090937.dkr.ecr.ap-northeast-1.amazonaws.com/terraform:latest"
}

variable "builder_type" {
  description = "Image pull credentials type used by codebuild project"
  type        = string
  default     = "ARM_CONTAINER"
}

variable "builder_image_pull_credentials_type" {
  description = "Image pull credentials type used by codebuild project"
  type        = string
  default     = "CODEBUILD"
}

variable "build_project_source" {
  description = "aws/codebuild/standard:4.0"
  type        = string
  default     = "CODEPIPELINE"

}
