resource "aws_iam_role" "iam_for_sfn" {
  name = "iam_for_sfn"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "states.amazonaws.com"
      },
      "Effect": "Allow"
    }
    
  ]
}
EOF
}

resource "aws_iam_policy" "policy_for_dynamodb" {

 name = "Policy-for-dynamodb"
 policy = file("Modules/step-function/policy-dynamodb.json")

}


resource "aws_iam_policy_attachment" "attach-policy-sfn" {
  name       = "attach-policy-to-role-sfn"
  roles      = [aws_iam_role.iam_for_sfn.name]
  policy_arn = aws_iam_policy.policy_for_dynamodb.arn
}

resource "aws_iam_policy_attachment" "attach-policy-cloudwatch-sfn" {
  name       = "attach-cloudwatchpolicy-to-role"
  roles      = [aws_iam_role.iam_for_sfn.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_sfn_state_machine" "sfn_state_machine" {
  name     = "my-state-machine"
  role_arn = aws_iam_role.iam_for_sfn.arn

  definition = <<EOF
{
    "Comment": "A description of my state machine",
    "StartAt": "CreateUserOnDynamoDB",
    "States": {
      "CreateUserOnDynamoDB": {
        "Type": "Task",
        "Resource": "arn:aws:states:::dynamodb:putItem",
        "Parameters": {
          "TableName": "Files",
          "Item": {
            "FileName": {
              "S.$": "$.file_name"
            }
          }
        },
        "ResultPath": "$.dynamodbPut",
        "End": true
      }
    }
  }
EOF
}

output "sfn_state_machine_arn" {
  
  value = aws_sfn_state_machine.sfn_state_machine.arn
}