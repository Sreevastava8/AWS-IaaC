data "aws_iam_policy_document" "shopsphere_secrets" {
  statement {
    effect = "Allow"

    actions = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret"
    ]

    resources = [
      var.rds_master_user_secret_arn,
      var.jwt_secret_arn
    ]
  }
}

resource "aws_iam_policy" "shopsphere_secrets" {
  name        = "${var.environment}-shopsphere-secrets"
  description = "Allow ShopSphere application pods to read required Secrets Manager secrets"

  policy = data.aws_iam_policy_document.shopsphere_secrets.json

  tags = var.common_tags
}

data "aws_iam_policy_document" "shopsphere_pod_assume_role" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.eks.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringLike"
      variable = "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:shopsphere:shopsphere-app"]
    }
  }
}

resource "aws_iam_role" "shopsphere_pod" {
  name               = "${var.environment}-shopsphere-pod"
  assume_role_policy = data.aws_iam_policy_document.shopsphere_pod_assume_role.json

  tags = var.common_tags
}

resource "aws_iam_role_policy_attachment" "shopsphere_secrets" {
  role       = aws_iam_role.shopsphere_pod.name
  policy_arn = aws_iam_policy.shopsphere_secrets.arn
}