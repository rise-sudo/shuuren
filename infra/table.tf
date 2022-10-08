resource "aws_dynamodb_table" "character" {
  name           = "character"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "user"

  attribute {
    name = "user"
    type = "S"
  }
}