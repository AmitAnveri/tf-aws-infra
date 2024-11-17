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
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  default = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

variable "availability_zones" {
  description = "Availability zones for the subnets"
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]
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

variable "volume_size" {
  description = "The size of the EBS volume (in GiB)"
  type        = number
  default     = 25
}

variable "volume_type" {
  description = "The type of EBS volume"
  type        = string
  default     = "gp2"
}

variable "family" {
  description = "The parameter group family for the RDS instance"
  type        = string
  default     = "postgres16"
}

variable "engine_version" {
  description = "The version of the database engine"
  type        = string
  default     = "16.3"
}

variable "instance_class" {
  description = "The instance class for the RDS instance"
  type        = string
  default     = "db.t3.micro"
}

variable "db_name" {
  description = "The name of the database to create"
  type        = string
  default     = "csye6225"
}

variable "db_username" {
  description = "The master username for the RDS instance"
  type        = string
  default     = "csye6225"
}

variable "db_password" {
  description = "The master password for the RDS instance"
  type        = string
}

variable "dbengine" {
  description = "The engine for the RDS instance"
  type        = string
  default     = "postgres"
}

variable "domain_name" {
  description = "The root domain name (e.g., example.com)"
  type        = string
}

variable "subdomain_prefix" {
  description = "The subdomain prefix (e.g., 'dev' or 'demo')"
  type        = string
}

variable "zone_id" {
  description = "Hosted zone id"
  type        = string
}

variable "launch_template_name" {
  description = "The name of the launch template"
  default     = "csye6225_asg"
}


# Variables
variable "desired_capacity" {
  default = 3
}

variable "max_size" {
  default = 5
}

variable "min_size" {
  default = 3
}

variable "cooldown_period" {
  default = 60
}

variable "health_check_type" {
  default = "EC2"
}

variable "health_check_grace_period" {
  default = 300
}

variable "cpu_high_threshold" {
  default = 10.0
}

variable "cpu_low_threshold" {
  default = 7.0
}

variable "evaluation_periods" {
  default = 2
}

variable "metric_period" {
  default = 60
}

variable "scaling_policy_name" {
  default = "scale_policy"
}

variable "mailgun_api_key" {
  type = string
}

variable "mailgun_domain" {
  type = string
}

variable "verification_expiry" {
  type = number
}

variable "lambda_jar_path" {
  type = string
}