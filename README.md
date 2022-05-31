This project allows the automated entry of the file names newly added in an S3 bucket in to a dynamodb table.

## Terrform project structure

This project follows a modularized approach. Each resourse has been designed to be in seperate modules  with data being passed on between them via terraform variables.


![architecture](images/assignment.drawio.png)


## How it works

S3

I utilized the S3 event notification to invoke a  lambda function When a new object is uploaded to the S3 bucket

lambda

The lambda function when invoked,iterates through the record list in the event recieved and filters out the file name and invokes the Step Function. This file name passed as an input to the step function.

Step Function

The Step function utilizes dynamodb integration to insert the record to dynamodb

## Possible enhancements

1) The lambda invocation can be decoupled using SQS
2) The Step Function can be removed from the architecture as lambda can be utilized to directly insert the data into Dynamodb, saving some cost



