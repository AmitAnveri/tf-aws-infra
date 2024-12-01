# AWS VPC Terraform Setup

This Terraform configuration creates an AWS VPC with public and private subnets across multiple availability zones,
along with associated route tables and an internet gateway.

## Prerequisites

Before running the Terraform code, ensure the following are installed and configured on your system:

- [Terraform](https://www.terraform.io/downloads.html) (v1.0.0 or higher recommended)
- [AWS CLI](https://aws.amazon.com/cli/) installed and configured
- AWS IAM user with sufficient permissions to create VPCs, subnets, route tables, and internet gateways
- An AWS account
- Setup an IAM user with admin access on the CLI with access key and secret key credentials

---

## SSL Certificate Import to AWS ACM

If you have obtained an SSL certificate from a third-party provider (e.g., Namecheap), follow these steps to import the
certificate into AWS ACM and configure it for application load balancer:

### Prerequisites for Certificate Import

Before importing, ensure the following:

- **Certificate file**: A file ending with `.crt` or similar.
- **Private key file**: A file ending with `.key`.
- **Certificate chain file (optional)**: A `.ca-bundle` file if your provider has provided intermediate certificates.

### Steps to Import Certificate

1. **Navigate to the Directory with Your Files**
   Ensure the certificate, private key, and optional certificate chain files are in the same directory on your local
   machine.

2. **Run the AWS CLI Command**
   Use the following command to import the certificate into AWS ACM:

   ```bash
   aws acm import-certificate \
     --certificate fileb://<certificate_file_path> \
     --private-key fileb://<private_key_file_path> \
     --certificate-chain fileb://<certificate_chain_file_path> \
     --region <aws_region>
   ```

   Replace the placeholders:
    - `<certificate_file_path>`: Path to certificate file (e.g., `demo_amitanveri_me.crt`).
    - `<private_key_file_path>`: Path to private key file (e.g., `demo.amitanveri.me.key`).
    - `<certificate_chain_file_path>`: Path to CA bundle file (e.g., `demo_amitanveri_me.ca-bundle`).
    - `<aws_region>`: Desired AWS region (e.g., `us-east-1`).


3. **Verify the Import**
   After importing the certificate, verify it using the following command:

   ```bash
   aws acm list-certificates --region <aws_region>
   ```

   Look for your certificate's **ARN** in the output.

4. **Configure the Certificate with the Load Balancer**
   Update your load balancer listener in Terraform to use the imported certificate's ARN:

   ```hcl
   resource "aws_lb_listener" "https_listener" {
     load_balancer_arn = aws_lb.web_app_lb.arn
     port              = 443
     protocol          = "HTTPS"
     ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01" # Choose a valid SSL policy

     certificate_arn = "<certificate_arn>" # Replace with your certificate's ARN

     default_action {
       type             = "forward"
       target_group_arn = aws_lb_target_group.web_app_tg.arn
     }
   }
   ```

   Replace `<certificate_arn>` with the ARN of your imported certificate.

## Variables

Ensure that the following variables are configured correctly either in the `terraform.tfvars` file or when running
Terraform commands. These variables are defined in the `variables.tf` file:

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
aws_region  = "us-east-1"
vpc_name    = "my-vpc"
vpc_cidr    = "10.0.0.0/16"
public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
private_subnet_cidrs = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]
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

---

## Outputs

The following outputs are generated after applying the configuration:

- `vpc_id`: The ID of the created VPC
- `public_subnet_ids`: The IDs of the public subnets
- `private_subnet_ids`: The IDs of the private subnets
- `internet_gateway_id`: The ID of the internet gateway

These outputs can be used for reference in your AWS environment.
