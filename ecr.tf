resource "aws_ecr_repository" "image" {
  name                 = var.name
  tags                 = local.tags
  image_tag_mutability = local.mutability
  image_scanning_configuration {
    scan_on_push = local.scan
  }
}

resource "aws_ecr_lifecycle_policy" "this" {
  repository = aws_ecr_repository.image.name
  policy     = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Expire images older than 7 days",
            "selection": {
                "tagStatus": "untagged",
                "countType": "sinceImagePushed",
                "countUnit": "days",
                "countNumber": 7
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}
