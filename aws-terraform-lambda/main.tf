data "aws_partition" "current" {}

locals {
  create = var.create
}

data "archive_file" "init" {
  type        = "zip"
  source_file = "${path.module}/emr-trigger/trigger.py"
  output_path = "emr_trigger.zip"
}

data "archive_file" "batch-init" {
  type        = "zip"
  source_file = "${path.module}/batch-trigger/batch-trigger.py"
  output_path = "batch_trigger.zip"
}

resource "aws_lambda_function" "emr-trigger" {
  count = local.create  ? 1 : 0
  function_name                  = var.function_name
  description                    = var.description
  role                           = aws_iam_role.lambda[0].arn
  handler                        = var.handler
  memory_size                    = var.memory_size
  runtime                        =  var.runtime
  timeout                        =  var.timeout
  source_code_hash = data.archive_file.init.output_base64sha256
  filename         = data.archive_file.init.output_path
 
  environment {
		variables = {
			STAGE        	= "test"
		}
	}

  tags = var.tags

  depends_on = [aws_iam_role.lambda]
}


resource "aws_lambda_function" "batch-trigger" {
  count = local.create  ? 1 : 0
  function_name                  = "${var.function_name}-batch"
  description                    = var.description
  role                           = aws_iam_role.lambda[0].arn
  handler                        = var.handler
  memory_size                    = var.memory_size
  runtime                        =  var.runtime
  timeout                        =  var.timeout
  source_code_hash = data.archive_file.batch-init.output_base64sha256
  filename         = data.archive_file.batch-init.output_path
 
  environment {
		variables = {
			inputFileName        	= var.inputFileName,
      bucketName = var.bucketName ,
      dynamodb_table_name = var.dynamodb_table_name
      bucket_key = var.bucket_key
      batch_queue_name = local.job_queue 
      region =var.region
      batch_job_definition_name = local.job_queue
		}
	}

  tags = var.tags

  depends_on = [aws_iam_role.lambda]
}
