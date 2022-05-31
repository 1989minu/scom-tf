resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow"
    }
    
  ]
}
EOF
}

resource "aws_iam_policy" "policy_for_sfn" {

 name = "Policy-for-sfn"
 policy = file("Modules/lambda/policy-sfn.json")

}

resource "aws_iam_policy_attachment" "attach-policy" {
  name       = "attach-policy-to-role"
  roles      = [aws_iam_role.iam_for_lambda.name]
  policy_arn = aws_iam_policy.policy_for_sfn.arn
}

resource "aws_iam_policy_attachment" "attach-policy-cloudwatch1" {
  name       = "attach-cloudwatchpolicy-to-role"
  roles      = [aws_iam_role.iam_for_lambda.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}


data "archive_file" "test" {
  type        = "zip"
  source_file = "Modules/lambda/lambda-sf.py"
  output_path = "../output/lambda-sf_2.zip"
}

resource "aws_lambda_function" "func" {
  filename      = "../output/lambda-sf_2.zip"
  function_name = "sfn_invoke"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "lambda-sf.upload"
  runtime       = "python3.9"

  environment {
    variables = {
      sfn_arn = var.sfn_state_machine_arn
    }
  }

}

output "lambda_func_arn" {

    value =  aws_lambda_function.func.arn
  
}