variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}
variable "AWS_REGION" {
  default = "eu-west-3"
}

variable "AMIS" {
  type = map(any)
  default = {
    us-east-1 = ""
    eu-west-1 = ""
    eu-west-3 = "ami-0ea4a063871686f37"
  }
}