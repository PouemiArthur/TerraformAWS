
variable "vpc_cidr" {
  description = "vpc cidr for infra"
  type = string
  default = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "subnet cidr for infra"
  type = string
  default = "10.0.1.0/24"
}

variable "availability_zone" {
  description = "availability zone of infra"
  type = string
  default = "us-east-1a"
}

