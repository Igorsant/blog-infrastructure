terraform {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-lambda.git"
}

include "root" {
  path = find_in_parent_folders()
}

inputs = {
  publish       = true
  function_name = "my-test-lambda"
  handler       = "index.lambda_handler"
  runtime       = "nodejs20.x"
  filename      = "placeholder.zip"
  create_package         = false
  local_existing_package = "placeholder.zip"
}
