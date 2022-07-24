variable "region1" {
  description = "region for environment"
  type        = string
  default     = "us-west-1"
}

#VPC variables

variable "vpc_name" {
  description = "name of vpc"
  type        = string
  default     = "two-tier-vpc"
}

variable "vpc_cidr" {
  description = "vpc-cidr"
  type        = string
  default     = "10.0.0.0/16"
}

# Public subnet variables
variable "public_subnet1" {
  description = "public subnet 1 cider block"
  type        = string
  default     = "10.0.1.0/24"
}

variable "public_subnet2" {
  description = "public subnet 2 cidr block"
  type        = string
  default     = "10.0.2.0/24"
}

# Private subnets variables
variable "private_subnet1" {
  description = "private subnet1 cidr block"
  type        = string
  default     = "10.0.3.0/24"
}

variable "private_subnet2" {
  description = "private subnet2 cidr block"
  type        = string
  default     = "10.0.4.0/24"
}

#Database variables
variable "db_username" {
  description = "Database admin username"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Database admin password"
  type        = string
  sensitive   = true
}

variable "instance_count" {
  description = "Number of instances to provision."
  type        = number
  default     = 2
}


