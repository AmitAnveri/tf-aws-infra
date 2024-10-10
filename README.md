
# AWS VPC Terraform Setup

This Terraform configuration creates an AWS VPC with public and private subnets across multiple availability zones, along with associated route tables and an internet gateway.

## Prerequisites

Before running the Terraform code, ensure the following are installed and configured on your system:

- [Terraform](https://www.terraform.io/downloads.html) (v1.0.0 or higher recommended)
- [AWS CLI](https://aws.amazon.com/cli/) installed and configured
- AWS IAM user with sufficient permissions to create VPCs, subnets, route tables, and internet gateways
- An AWS account
- Setup an IAM user with admin access on the CLI with access key and secret key credentials

## Variables

Ensure that the following variables are configured correctly either in the `terraform.tfvars` file or when running Terraform commands. These variables are defined in the `variables.tf` file:

- `aws_profile`: AWS CLI profile to use
- `aws_region`: AWS region to deploy resources (default: `us-east-1`)
- `vpc_name`: Name tag for the VPC and resources
- `vpc_cidr`: CIDR block for the VPC (default: `10.0.0.0/16`)
- `public_subnet_cidrs`: CIDR blocks for public subnets
- `private_subnet_cidrs`: CIDR blocks for private subnets
- `availability_zones`: Availability zones for the subnets (default: `["us-east-1a", "us-east-1b", "us-east-1c"]`)

You can set these in the `terraform.tfvars` file like this:

```hcl
aws_profile = "your-aws-profile"
aws_region = "us-east-1"
vpc_name   = "my-vpc"
vpc_cidr   = "10.0.0.0/16"
public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
private_subnet_cidrs = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
availability_zones   = ["us-east-1a", "us-east-1b", "us-east-1c"]
```

## Instructions

Follow these steps to run the Terraform configuration and set up your infrastructure:

### 1. Initialize Terraform

First, initialize the Terraform working directory. This step will download and set up the necessary providers:

```bash
terraform init
```

### 2. Plan the Infrastructure

Run the following command to review the changes Terraform will make to your AWS infrastructure:

```bash
terraform plan
```

This will display the resources that will be created, modified, or destroyed without actually making any changes.

### 3. Apply the Configuration

If everything looks good, apply the changes to create the infrastructure:

```bash
terraform apply
```

Terraform will prompt for confirmation. Type `yes` to proceed.

### 4. Destroy the Infrastructure

If you want to tear down the infrastructure later, use the following command:

```bash
terraform destroy
```

Terraform will prompt for confirmation. Type `yes` to destroy all the resources created by this configuration.

## Outputs

The following outputs are generated after applying the configuration:

- `vpc_id`: The ID of the created VPC
- `public_subnet_ids`: The IDs of the public subnets
- `private_subnet_ids`: The IDs of the private subnets
- `internet_gateway_id`: The ID of the internet gateway

These outputs can be used for reference in your AWS environment.
