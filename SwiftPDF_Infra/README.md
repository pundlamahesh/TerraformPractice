# SwiftPDF Infra

Production-ready Terraform project for AWS infrastructure supporting SwiftPDF.

## Structure

* `versions.tf` - Terraform version and provider requirements
* `provider.tf` - AWS provider configuration
* `variables.tf` - Root-level input variables
* `main.tf` - Root module wiring and module calls
* `outputs.tf` - Exported infrastructure values
* `modules/networking/main.tf` - VPC, subnet, internet gateway, route table, security group
* `modules/ec2/main.tf` - EC2 instance, IAM role/profile, Elastic IP
* `modules/s3/main.tf` - S3 bucket with encryption, versioning, and public access blocking
* `env/sandbox.tfvars` - Sandbox environment inputs
* `env/prod.tfvars` - Production environment inputs

## Requirements

* Terraform version specified in `versions.tf`
* AWS provider version specified in `versions.tf`
* AWS CLI installed
* Valid AWS credentials configured

## Prerequisites

### 1. Create an EC2 Key Pair

Create an EC2 Key Pair from the AWS Console.

```text
AWS Console → EC2 → Key Pairs → Create Key Pair
```

Recommended settings:

* Name: `swiftpdf-prod-key`
* Key pair type: RSA
* Private key format: `.pem`

After downloading:

```bash
chmod 400 swiftpdf-prod-key.pem
```

Update the appropriate environment file:

```hcl
key_name = "swiftpdf-prod-key"
```

### 2. Configure SSH Access

Find your public IP:

```bash
curl https://checkip.amazonaws.com
```

Update:

```hcl
ssh_allowed_cidr = "YOUR_PUBLIC_IP/32"
```

Example:

```hcl
ssh_allowed_cidr = "49.205.xxx.xxx/32"
```

Do not use:

```hcl
ssh_allowed_cidr = "0.0.0.0/0"
```

in production environments.

### 3. Configure AWS Credentials

Configure AWS credentials:

```bash
aws configure
```

Provide:

```text
AWS Access Key ID
AWS Secret Access Key
Default region: ap-south-1
Default output format: json
```

Verify access:

```bash
aws sts get-caller-identity
```

Successful output should display your AWS account information.

### 4. Verify S3 Bucket Name

S3 bucket names are globally unique.

Update the environment file with a unique bucket name if required:

```hcl
bucket_name = "swiftpdf-prod-storage-12345"
```

## Validation

Format Terraform files:

```powershell
terraform fmt -recursive
```

Validate configuration:

```powershell
terraform validate
```

## Deployment

### Sandbox

```powershell
terraform init
terraform plan -var-file=env/sandbox.tfvars
terraform apply -var-file=env/sandbox.tfvars
```

### Production

```powershell
terraform init
terraform plan -var-file=env/prod.tfvars
terraform apply -var-file=env/prod.tfvars
```

## Outputs

View generated outputs:

```powershell
terraform output
```

Common outputs include:

* VPC ID
* Subnet ID
* Security Group ID
* EC2 Instance ID
* Elastic IP
* Public DNS
* S3 Bucket Name
* S3 Bucket ARN

## Accessing the EC2 Instance

Connect using the downloaded key pair:

```bash
ssh -i swiftpdf-prod-key.pem ubuntu@<elastic-ip>
```

Example:

```bash
ssh -i swiftpdf-prod-key.pem ubuntu@13.234.xxx.xxx
```

## Resources Created

Terraform automatically provisions:

### Networking

* VPC
* Public Subnet
* Internet Gateway
* Route Table
* Route Table Association
* Security Group

### Compute

* IAM Role
* IAM Instance Profile
* EC2 Instance
* Elastic IP

### Storage

* S3 Bucket
* S3 Bucket Versioning
* S3 Server-Side Encryption
* S3 Public Access Block
* S3 Ownership Controls

## IAM Permissions

The EC2 instance receives the following permissions:

### AmazonSSMManagedInstanceCore

Allows:

* AWS Systems Manager connectivity
* Session Manager access
* Remote command execution through SSM

### Custom S3 Access Policy

Allows access only to the SwiftPDF S3 bucket.

Permissions:

* s3:ListBucket
* s3:GetObject
* s3:PutObject
* s3:DeleteObject

Typical use cases:

* Upload SQLite database backups
* Upload application logs
* Download backups during recovery
* Remove old backup files

The EC2 instance does not receive administrator permissions and cannot access other S3 buckets.

## Terraform Workspaces

Terraform workspaces are used to maintain separate state files for each environment (Sandbox and Production).

### Initialize Terraform

```bash
terraform init
```

### Create Workspaces

Create the sandbox workspace:

```bash
terraform workspace new sandbox
```

Create the production workspace:

```bash
terraform workspace new prod
```

### List Workspaces

```bash
terraform workspace list
```

Example output:

```text
* default
  sandbox
  prod
```

### Show Current Workspace

```bash
terraform workspace show
```

### Switch to Sandbox

```bash
terraform workspace select sandbox
```

Deploy sandbox infrastructure:

```bash
terraform plan -var-file=env/sandbox.tfvars
terraform apply -var-file=env/sandbox.tfvars
```

Destroy sandbox infrastructure:

```bash
terraform destroy -var-file=env/sandbox.tfvars
```

### Switch to Production

```bash
terraform workspace select prod
```

Deploy production infrastructure:

```bash
terraform plan -var-file=env/prod.tfvars
terraform apply -var-file=env/prod.tfvars
```

Destroy production infrastructure:

```bash
terraform destroy -var-file=env/prod.tfvars
```

### View Resources in Current Workspace

```bash
terraform state list
```

### Important Notes

* Each workspace maintains its own Terraform state.
* Always verify the active workspace before running `apply` or `destroy`.

Check the current workspace:

```bash
terraform workspace show
```

* Use `sandbox` workspace with `env/sandbox.tfvars`.
* Use `prod` workspace with `env/prod.tfvars`.
* Switching workspaces does not require running `terraform init` again.
* Resources created in one workspace are not automatically managed by another workspace.


## Notes

* Replace `CHANGE_ME` in `key_name` with your actual EC2 key pair name.
* Replace `YOUR_PUBLIC_IP/32` in `ssh_allowed_cidr` with your source IP address.
* Ensure the S3 bucket name is globally unique.
* Store the `.pem` key securely and never commit it to GitHub.
* The Elastic IP remains fixed even if the EC2 instance is stopped and started.
