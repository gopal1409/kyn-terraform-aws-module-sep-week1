variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "vpc_cidr_block" {
  description = "CIDR block for VPC"
  type        = string
}

variable "subnets" {
  description = "Subnet configuration"

  type = map(object({
    cidr_block        = string
    availability_zone = string
  }))
}

variable "common_tags" {
  description = "Common resource tags"
  type        = map(string)
  default     = {}
}