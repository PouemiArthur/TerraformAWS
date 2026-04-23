data "archive_file" "lambda_zip" {
  type = "zip"
  source_file = "pjrhello.py"
  output_path = "hello_function.zip"
}

resource "aws_iam_role" "PJriamlamda" {
  name = "my_lambda_function"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid = ""
        Principal = {
          Service = "lambda.amazonaws.com"
          }
       },
     ]
  })
}

resource "aws_lambda_function" "pjr_function" {
  filename = "hello_function.zip"
  function_name = "pjrfunctionone"
  role = aws_iam_role.PJriamlamda.arn
  handler = "pjrhello.lambda_handler"

  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  runtime = "python3.12"
}
