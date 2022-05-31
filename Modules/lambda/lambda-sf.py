import json
import boto3
import os

client = boto3.client('stepfunctions')

def upload(event, context):
    print(event)
    for record in event['Records']:
        file_name = record["s3"]["object"]["key"]
        input_string = {"file_name" : file_name}
        print(input_string)
        response = client.start_execution(
            stateMachineArn = os.getenv('sfn_arn'),       
            input = json.dumps(input_string)
        )
