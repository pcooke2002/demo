resource "aws_dynamodb_table" "my_items" {
  name         = "my_items"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "N"
  }

  tags = {
    Name = "my_items"
  }

  server_side_encryption {
    enabled = true
  }

  point_in_time_recovery {
    enabled = false
  }

  stream_enabled = false
}
