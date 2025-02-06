# Terraform AWS Infrastructure

This repository contains Terraform configuration files to provision a secure and scalable AWS infrastructure. The setup includes a Virtual Private Cloud (VPC), public and private subnets, route tables, security groups, and EC2 instances for a bastion host and an application server.

## Table of Contents

1. [Overview](#overview)
2. [Prerequisites](#prerequisites)
3. [Configuration](#configuration)
4. [Usage](#usage)


---

## Overview

This Terraform configuration provisions the following AWS resources:

- **VPC**: A Virtual Private Cloud with a defined CIDR block.
- **Subnets**: Public and private subnets within the VPC.
- **Internet Gateway**: Allows communication between the VPC and the internet.
- **Route Tables**: Public and private route tables for subnet routing.
- **Security Groups**: Security groups for the bastion host and application server.
- **EC2 Instances**: A bastion host in the public subnet and an application server in the private subnet.

---

## Prerequisites

Before using this Terraform configuration, ensure you have the following:

1. **Terraform**: Install Terraform from [here](https://www.terraform.io/downloads.html).
2. **AWS CLI**: Install and configure the AWS CLI with your credentials. Follow the [AWS CLI setup guide](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html).
3. **Git**: Install Git from [here](https://git-scm.com/downloads).

---

## Configuration

### Files

- **`main.tf`**: The main Terraform configuration file defining the AWS resources.
- **`terraform.tfvars`**: Contains variable values for the Terraform configuration.
- **`variables.tf`**: Defines input variables for the Terraform configuration.

### Variables

The following variables are defined in `variables.tf` and can be customized in `terraform.tfvars`:

| Variable Name          | Description                          | Default Value       |
|------------------------|--------------------------------------|---------------------|
| `aws_region`           | The AWS region to create resources in | `us-east-1`         |
| `vpc_cidr`             | CIDR block for the VPC               | `10.0.0.0/16`       |
| `public_subnet_cidr`   | CIDR block for the public subnet     | `10.0.1.0/24`       |
| `private_subnet_cidr`  | CIDR block for the private subnet    | `10.0.2.0/24`       |
| `availability_zone`    | Availability zone for the subnets    | `us-east-1a`        |
| `bastion_ami`          | AMI ID for the Bastion host          | `ami-0c55b159cbfafe1f0` |
| `app_ami`              | AMI ID for the Application server    | `ami-0c55b159cbfafe1f0` |
| `instance_type`        | Instance type for the EC2 instances  | `t2.micro`          |

---

## Usage

### 1. Clone the Repository

Clone this repository to your local machine:

### 2. Initialize Terraform
```bash
terraform init
terraform plan
terraform apply


