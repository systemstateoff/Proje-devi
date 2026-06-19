terraform {
  backend "s3" {
    bucket         = "skrybucket1907"
    key            = "prod/terraform.tfstate"
    region         = "eu-north-1"
    dynamodb_table = "de-souza"  
    encrypt        = true
  }
}
