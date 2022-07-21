variable "access_key" {
  description = "Access key"
}

variable "secret_key" {
  description = "Secret Key"
}

variable "region" {
  description = "Region where we need to deploy the project"
  default     = "eu-west-1"
}

provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region     = var.region
}