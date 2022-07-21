data "aws_caller_identity" "current" {}

locals {
  create_bucket = var.create_bucket 
}

resource "aws_s3_bucket" "source-bucket" {
  count = local.create_bucket ? 1 : 0

  bucket        = "${var.bucket}-source-data"
  tags                = var.tags

}

resource "aws_s3_bucket_acl" "s3_bucket_acl" {
  bucket = aws_s3_bucket.source-bucket[0].id
  acl    = "private"
  depends_on = [ aws_s3_bucket.source-bucket ]
}


resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = "${aws_s3_bucket.source-bucket[0].id}"
  depends_on = [ aws_s3_bucket.source-bucket ]
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      },
      "Action": [ "s3:GetObject",
      "s3:ListBucket" ],
      "Resource": [
        "${aws_s3_bucket.source-bucket[0].arn}",
        "${aws_s3_bucket.source-bucket[0].arn}/*"
      ]
    }
  ]
}
EOF
}

data "aws_iam_policy_document" "allow_access" {
  version    = "2012-10-17"
    statement {
     principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
    actions = [
      "s3:GetObject",
      "s3:ListBucket"
    ]
    resources = [
      "${aws_s3_bucket.source-bucket[0].arn}/*"
    ]
  }
  depends_on = [ aws_s3_bucket.source-bucket ]
}

## Destination bucket to store EMR queries

resource "aws_s3_bucket" "destination-bucket" {
  count = local.create_bucket ? 1 : 0

  bucket        = "${var.bucket}-destination-data"
  tags                = var.tags

}

resource "aws_s3_bucket_acl" "destination_s3_bucket_acl" {
  bucket = aws_s3_bucket.destination-bucket[0].id
  acl    = "private"
  depends_on = [ aws_s3_bucket.destination-bucket ]
}


resource "aws_s3_bucket_policy" "destination_bucket_policy" {
  bucket = "${aws_s3_bucket.destination-bucket[0].id}"
  depends_on = [ aws_s3_bucket.destination-bucket ]
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      },
      "Action": [ "s3:GetObject",
      "s3:ListBucket" ],
      "Resource": [
        "${aws_s3_bucket.destination-bucket[0].arn}",
        "${aws_s3_bucket.destination-bucket[0].arn}/*"
      ]
    }
  ]
}
EOF
}


# Adding bigdata csv to bucket . Commenting this since it will trigger lambda
/*
resource "aws_s3_bucket_object" "source-bucket-object-csv" {
  bucket = aws_s3_bucket.source-bucket[0].id
  key    = "csv/data.csv"
  acl    = "private"  # or can be "public-read"
  source = "S3/csv/food_establishment_data.csv"
}
*/