resource "aws_dynamodb_table" "Files_table" {
  name           = var.Table_name
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = var.key_name
 

  attribute {
    name = var.key_name
    type = "S"
  }

}
