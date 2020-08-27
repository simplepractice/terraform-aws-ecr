data "aws_iam_policy_document" "allow_manage_docker_repo" {
  statement {
    sid = "AllowManage${local.title}DockerRepo"
    resources = [
      aws_ecr_repository.image.arn,
    ]
    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
    ]
  }
  statement {
    sid = "AllowGetAuthorizationToken"
    actions = [
      "ecr:GetAuthorizationToken",
    ]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "allow_fetch_images_from_repo" {
  statement {
    sid = "AllowFetchImages${local.title}DockerRepo"
    resources = [
      aws_ecr_repository.image.arn,
    ]
    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
    ]
  }
  statement {
    sid = "AllowGetAuthorizationToken"
    actions = [
      "ecr:GetAuthorizationToken",
    ]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "cross_account" {
  statement {
    sid = "CrossAccountPull"
    principals {
      identifiers = local.accounts
      type        = "AWS"
    }
    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
    ]
  }
}

resource "aws_ecr_repository_policy" "cross_account_pull" {
  count      = var.share_with_accounts == [] ? 0 : 1
  policy     = data.aws_iam_policy_document.cross_account.json
  repository = aws_ecr_repository.image.name
}
