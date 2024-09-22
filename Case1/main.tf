#Provider 
provider "aws" {
    region = var.region
  
}

#module for the webserver 
module "custom-vpc" {
source = "./webserver"
ENVIRONMENT = var.ENVIRONMENT
  
}