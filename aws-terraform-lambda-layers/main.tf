data "archive_file" "python_lib" {
  type        = "zip"
  output_path = "${path.module}/source/python.zip"
  source_dir  = pathexpand("${path.module}/source/")
}

resource "aws_lambda_layer_version" "lambda_layer" {
  filename   = "${path.module}/source/python.zip"
  layer_name = "lambda-layer-V1"

  compatible_runtimes = ["python3.9"]
}