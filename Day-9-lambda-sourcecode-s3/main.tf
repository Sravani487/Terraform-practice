#etag works as sourcecodehash tag need to check that, still this code is in progress
# 1️⃣ Create an S3 bucket
resource "aws_s3_bucket" "lambda_bucket" {
  bucket = "my-lambda-function-buckett-1"
  force_destroy = true
}

resource "random_id" "suffix" {
  byte_length = 4
}

# 2️⃣ Zip and upload Lambda code to S3
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/lambda_function"
  output_path = "${path.module}/lambda_function.zip"
}

resource "aws_s3_object" "lambda_zip" {
  bucket = aws_s3_bucket.lambda_bucket.id
  key    = "lambda_function.zip"
  source = data.archive_file.lambda_zip.output_path
}

# 3️⃣ Create IAM Role for Lambda
resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_exec_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Effect = "Allow"
      }
    ]
  })
}

# Attach AWSLambdaBasicExecutionRole policy
resource "aws_iam_role_policy_attachment" "lambda_basic_exec" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# 4️⃣ Create the Lambda function
resource "aws_lambda_function" "s3_trigger_lambda" {
  function_name = "s3_trigger_lambda"
  role          = aws_iam_role.lambda_exec_role.arn
  s3_bucket     = aws_s3_bucket.lambda_bucket.id
  s3_key        = aws_s3_object.lambda_zip.key
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"
  timeout       = 10
}

# 5️⃣ Give S3 permission to invoke Lambda
resource "aws_lambda_permission" "allow_s3_invoke" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.s3_trigger_lambda.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.lambda_bucket.arn
}

# 6️⃣ Create S3 Bucket Notification to trigger Lambda
resource "aws_s3_bucket_notification" "lambda_trigger" {
  bucket = aws_s3_bucket.lambda_bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.s3_trigger_lambda.arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_lambda_permission.allow_s3_invoke]
}

output "bucket_name" {
  value = aws_s3_bucket.lambda_bucket.bucket
}

output "lambda_function_name" {
  value = aws_lambda_function.s3_trigger_lambda.function_name
}
