variable "aws_profile" {
  description = "AWS CLI profile to use (dev/demo)"
}

variable "aws_region" {
  description = "AWS region to deploy resources"
  default     = "us-east-1"
}

variable "vpc_name" {
  description = "Name tag for the VPC and resources"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  default     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

variable "availability_zones" {
  description = "Availability zones for the subnets"
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "internet_gateway_cidr" {
  description = "CIDR block for internet gateway routes"
  default     = "0.0.0.0/0"
}

variable "ami_id" {
  description = "The ID of the AMI to use for the EC2 instance"
}

variable "instance_type" {
  description = "The EC2 instance type"
  default     = "t2.micro"
}

variable "key_name" {
  description = "The name of the SSH key pair to use"
}

variable "application_port" {
  description = "Port on which the application runs"
  type        = number
  default     = 8080
}