provider "aws" {
    region = var.region
  
}

module "custom-vpc" {
source = "./webserver"
  
}