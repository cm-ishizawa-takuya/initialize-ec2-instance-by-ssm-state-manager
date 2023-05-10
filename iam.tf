resource "aws_iam_instance_profile" "web_server" {
  name = "web_server_role"
  role = aws_iam_role.web_server.name
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "read_bucket" {
  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
    ]
    resources = [
      "${module.ansible_bucket.arn}/*",
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:PutObjectAcl",
    ]
    resources = [
      "${module.ssm_log_bucket.arn}/*",
    ]
  }
}

resource "aws_iam_policy" "read_bucket" {
  name   = "read_bucket_policy"
  policy = data.aws_iam_policy_document.read_bucket.json
}

resource "aws_iam_role" "web_server" {
  name               = "web_server_role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
  managed_policy_arns = [
    aws_iam_policy.read_bucket.arn,
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
  ]
}