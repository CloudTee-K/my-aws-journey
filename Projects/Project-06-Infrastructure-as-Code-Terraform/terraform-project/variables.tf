variable "project_name" {
  description = "Name used to identify Project 06 resources"
  type        = string
  default     = "project-06"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for the public subnets"
  type        = list(string)

  default = [
    "10.0.1.0/24",
    "10.0.2.0/24"
  ]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for the private subnets"
  type        = list(string)

  default = [
    "10.0.11.0/24",
    "10.0.12.0/24"
  ]
}

variable "availability_zones" {
  description = "Availability Zones used by the subnets"
  type        = list(string)

  default = [
    "us-east-1a",
    "us-east-1b"
  ]
}