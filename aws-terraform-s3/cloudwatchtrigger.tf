resource "aws_s3_bucket_notification" "source_bucket_notification" {
  bucket = aws_s3_bucket.source-bucket[0].id

  lambda_function {
    lambda_function_arn = var.batch_lambda_arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "csv/"
    filter_suffix       = ".csv"
  }


  depends_on = [aws_lambda_permission.allow_bucket_source , aws_s3_bucket.source-bucket ]
}

resource "aws_lambda_permission" "allow_bucket_source" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = var.batch_lambda_arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.source-bucket[0].arn
  depends_on = [ aws_s3_bucket.source-bucket ]
}