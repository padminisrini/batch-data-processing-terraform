# AWS batch  role
data "aws_iam_policy_document" "batch_assume_role_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["batch.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "batch_role_inline_policy" {
  statement {
    actions   = ["logs:DescribeLogGroups"]
    resources = ["*"]
  }
}

resource "aws_iam_role" "aws_batch_service_role" {
  name               = local.aws_batch_service_role_name
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": [
          "batch.amazonaws.com",
          "lambda.amazonaws.com",
          "ec2.amazonaws.com",
          "ecs-tasks.amazonaws.com"
        ]
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "aws_batch_service_role_policy" {
  depends_on = [
    aws_iam_role.aws_batch_service_role
  ]
  count      = length(var.aws_batch_service_role_policies)
  role       = aws_iam_role.aws_batch_service_role.name
  policy_arn = var.aws_batch_service_role_policies[count.index]
}

resource "aws_iam_role_policy_attachment" "aws_batch_service_role_policy_1" {
  role       = aws_iam_role.aws_batch_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBatchServiceRole"
}

resource "aws_iam_role_policy_attachment" "aws_batch_service_role_policy_2" {
  role       = aws_iam_role.aws_batch_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "aws_batch_service_role_policy_3" {
  role       = aws_iam_role.aws_batch_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSLambdaExecute"
}
resource "aws_iam_role_policy_attachment" "aws_batch_service_role_policy_4" {
  role       = aws_iam_role.aws_batch_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMFullAccess"
}
resource "aws_iam_role_policy_attachment" "aws_batch_service_role_policy_5" {
  role       = aws_iam_role.aws_batch_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSBatchFullAccess"
}
resource "aws_iam_role_policy_attachment" "aws_batch_service_role_policy_6" {
  role       = aws_iam_role.aws_batch_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}
resource "aws_iam_role_policy_attachment" "aws_batch_service_role_policy_7" {
  role       = aws_iam_role.aws_batch_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}
resource "aws_iam_role_policy_attachment" "aws_batch_service_role_policy_8" {
  role       = aws_iam_role.aws_batch_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}
resource "aws_iam_role_policy_attachment" "aws_batch_service_role_policy_9" {
  role       = aws_iam_role.aws_batch_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
}


# ECS task role
data "aws_iam_policy_document" "task_assume_role_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "task_role_inline_policy" {
  statement {
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:*",
      "dynamodb:*",
    "s3:*"]
    resources = ["*"]
  }
}

resource "aws_iam_role" "task_execution_service_role" {
  depends_on = [
    data.aws_iam_policy_document.task_assume_role_role_policy
  ]
  name               = local.task_execution_service_role_name
  assume_role_policy = data.aws_iam_policy_document.task_assume_role_role_policy.json
  inline_policy {
    name   = local.task_execution_service_role_name
    policy = data.aws_iam_policy_document.task_role_inline_policy.json
  }
}


resource "aws_iam_role_policy_attachment" "task_execution_service_role_policy" {
  depends_on = [
    aws_iam_role.task_execution_service_role
  ]
  count      = length(var.task_execution_service_role_policies)
  role       = aws_iam_role.task_execution_service_role.name
  policy_arn = var.task_execution_service_role_policies[count.index]
}


############################
# IAM role for Batch Trigger
############################


resource "aws_iam_role" "batch_lambda" {
  count = local.create_role ? 1 : 0

  name                  = "${local.role_name}-batch"
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
resource "aws_iam_policy" "batch_lambda_policy" {
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
  role       = aws_iam_role.batch_lambda[0].name
  policy_arn = aws_iam_policy.batch_lambda_policy.arn
}
