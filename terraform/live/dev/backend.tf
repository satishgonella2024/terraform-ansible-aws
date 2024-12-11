terraform {
  backend "s3" {
    bucket         = "terraform-ansible-aws11122024"
    key            = "terraform/live/dev/terraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "terraform-lock-table"
  }
}
