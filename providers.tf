provider "aws" {
    region = var.region
}

terraform {
  required_providers {
    confluent = {
      source  = "confluentinc/confluent"
      version = "1.28.0"
    }
  }
}

provider "confluent" {

}