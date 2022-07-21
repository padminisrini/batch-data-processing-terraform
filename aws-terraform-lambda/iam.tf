locals {
  create_role = local.create
  role_name = local.create_role ? coalesce(var.role_name, var.function_name, "*") : null
}
###########
# IAM role
###########


resource "aws_iam_role" "lambda" {
  count = local.create_role ? 1 : 0

  name                  = local.role_name
  assume_role_policy    = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
  tags = var.tags
}

# Declaration for Creating IAM Policy
resource "aws_iam_policy" "lambda_policy" {
  name        = "lambda-policy"
  description = "Lambda execution policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
                "logs:*",
                "lambda:*",
                "batch:*"
            ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

# Declaration for Attaching Policy to IAM Role
resource "aws_iam_role_policy_attachment" "role_policy_attachment" {
  role       = aws_iam_role.lambda[0].name
  policy_arn = aws_iam_policy.lambda_policy.arn
}
