# ShopSphere AWS Infrastructure

## Project Overview

ShopSphere is a production-style AWS infrastructure project built with **Terraform** and designed to support a containerized e-commerce application running on **Amazon EKS**.

The goal of this repository is to demonstrate how I design, provision, secure, and operate cloud infrastructure using Infrastructure as Code.

---

## Architecture Overview

```text
                         GitHub
                            |
                            v
                     Jenkins Pipeline
                            |
                    Terraform Plan/Apply
                            |
        +-------------------+-------------------+
        |                   |                   |
       DEV                 QA                  PROD
    develop branch       qa branch          main branch
        |                   |                   |
        +-------------------+-------------------+
                            |
                            v
                     Amazon Web Services
                            |
        +-------------------+-------------------+
        |                   |                   |
       VPC                 IAM              Secrets
        |                   |              Manager
        |                   |
   +----+-------------------+----+
   |         |          |       |
Public     Private    Database  Management
Subnets   Subnets     Subnets   Subnet
   |         |          |       |
 NAT/ALB   EKS Nodes   RDS     SSM Bastion
             |
             |
          Amazon EKS
             |
       Kubernetes workloads
             |
          AWS ALB
```

---

## AWS Services Used

| Area | AWS Service | Purpose |
|---|---|---|
| Networking | Amazon VPC | Isolated AWS network |
| Networking | Public/Private/DB subnets | Network segmentation |
| Networking | NAT Gateway | Outbound access from private subnets |
| Compute | Amazon EKS | Kubernetes platform |
| Compute | EKS Managed Node Groups | Kubernetes worker nodes |
| Database | Amazon RDS PostgreSQL | Application database |
| Registry | Amazon ECR | Docker image storage |
| Storage | Amazon S3 | Application/infrastructure storage |
| State | Amazon S3 | Terraform remote state |
| Access | AWS Systems Manager | Bastion access without SSH |
| Security | IAM | Roles and least-privilege access |
| Secrets | AWS Secrets Manager | Application and database secrets |
| Load Balancing | AWS Load Balancer Controller | Creates AWS ALB for Kubernetes Ingress |
| Monitoring | Amazon CloudWatch | Monitoring/logging integration |
| Logging | AWS logging services | Centralized operational visibility |

---

# Terraform Architecture

## Repository Structure

```text
shopsphere-infra/
│
├── backend.tf
├── provider.tf
├── versions.tf
├── variables.tf
├── locals.tf
├── main.tf
├── outputs.tf
├── .gitignore
│
├── environments/
│   ├── dev/
│   │   ├── terraform.tfvars
│   │   └── backend.hcl
│   │
│   ├── qa/
│   │   ├── terraform.tfvars
│   │   └── backend.hcl
│   │
│   └── prod/
│       ├── terraform.tfvars
│       └── backend.hcl
│
└── modules/
    ├── network/
    ├── eks/
    ├── rds/
    ├── ecr/
    ├── s3/
    ├── bastion/
    ├── loadbalancer/
    ├── secrets-manager/
    ├── monitoring/
    └── logging/
```

---

# Terraform Modules

## 1. Network Module

The network module creates the AWS network foundation.

It includes:

- VPC
- Public subnets
- Private application subnets
- Database subnets
- Management subnet
- Internet Gateway
- NAT Gateway
- Elastic IP
- Route tables
- Route table associations
- Network segmentation

The EKS worker nodes and bastion are placed in private subnets.

Database subnets are isolated from direct internet access.

---

## 2. EKS Module

The EKS module creates the Kubernetes platform.

It includes:

- EKS cluster
- Private EKS API endpoint
- Managed node groups
- Application node group
- System node group
- EKS node security group
- OIDC provider
- IAM integration
- Launch templates
- Kubernetes access configuration

The EKS API is configured for private access and the worker nodes run in private subnets.

---

## 3. RDS Module

The RDS module provisions PostgreSQL for the application.

Environment-specific controls include:

```text
DEV
Multi-AZ: false
Deletion protection: false
Skip final snapshot: true

QA
Multi-AZ: true
Deletion protection: false
Skip final snapshot: true

PROD
Multi-AZ: true
Deletion protection: true
Skip final snapshot: false
```

The production environment therefore has stronger database protection than development.

---

## 4. ECR Module

Amazon ECR stores application container images.

The configuration uses:

- Image scanning on push
- Immutable image tags
- Environment-specific repositories
- IAM-controlled access

Example:

```text
dev-shopsphere
qa-shopsphere
prod-shopsphere
```

Images are tagged using the Git commit:

```text
product-service-<git-commit>
user-service-<git-commit>
order-service-<git-commit>
payment-service-<git-commit>
frontend-<git-commit>
```

---

## 5. S3 Module

S3 is used for application/infrastructure storage with security controls including:

- Public access block
- Bucket owner enforced object ownership
- Encryption
- Versioning
- Lifecycle configuration where applicable

---

# Terraform Remote State

Terraform state is stored remotely in Amazon S3.

A single state bucket is used with environment-specific prefixes:

```text
shopsphere-terraform-state-91827/
│
├── dev/terraform.tfstate
├── qa/terraform.tfstate
└── prod/terraform.tfstate
```

Each Jenkins environment selects its own backend configuration:

```bash
terraform init \
  -reconfigure \
  -backend-config=environments/${DEPLOY_ENV}/backend.hcl
```

This prevents DEV, QA, and PROD state from being mixed.

The project intentionally starts with fresh state rather than migrating the previous GCP state.

---

# Environment Strategy

The project uses Git branches to map application/infrastructure changes to environments.

| Git Branch | Environment | AWS Resources |
|---|---|---|
| `develop` | DEV | `shopsphere-dev-*` |
| `qa` | QA | `shopsphere-qa-*` |
| `main` | PROD | `shopsphere-prod-*` |

Each environment has its own:

- Terraform variables
- Terraform backend key
- VPC CIDR range
- EKS cluster
- RDS configuration
- ECR repository
- Secrets
- Application resources

Example VPC ranges:

```text
DEV  → 10.10.0.0/16
QA   → 10.20.0.0/16
PROD → 10.30.0.0/16
```

---

# Security Design

## Private Infrastructure

The EKS API endpoint is private.

Worker nodes run in private subnets.

The RDS database is placed in database subnets.

The bastion does not require a public IP.

---

## SSM Instead of SSH

The management/bastion host uses AWS Systems Manager.

The EC2 instance uses:

```text
AmazonSSMManagedInstanceCore
```

No public SSH access or port 22 is required.

The general access flow is:

```text
Developer
    |
    v
AWS Console / AWS CLI
    |
    v
AWS Systems Manager
    |
    v
Private Bastion
    |
    v
Private EKS / AWS resources
```

This removes the need for a traditional public bastion with SSH access.

---

# Secrets Management

Sensitive values are not intended to be stored as plain text in Git.

The project uses:

- AWS Secrets Manager
- RDS managed master password
- EKS workload IAM
- Secrets Store CSI Driver
- AWS Secrets Manager CSI provider

The application workload receives permission through a dedicated IAM role associated with the Kubernetes service account.

The trust relationship is restricted to the intended Kubernetes service account rather than granting broad cluster-wide permissions.

---

# EKS Workload IAM

The application service account uses an IAM role.

The trust relationship is restricted to:

```text
system:serviceaccount:shopsphere:shopsphere-app
```

The role is granted only the required Secrets Manager permissions.

This follows the least-privilege principle.

---

# AWS Load Balancer Controller

The AWS Load Balancer Controller runs inside EKS.

Kubernetes Ingress creates an AWS Application Load Balancer.

The flow is:

```text
Internet
   |
   v
AWS ALB
   |
   v
Kubernetes Ingress
   |
   v
Kubernetes Services
   |
   v
Application Pods
```

The ALB security group is environment-specific.

---

# Infrastructure CI/CD

Infrastructure is deployed through Jenkins.

### Create pipeline

```text
Git branch
    |
    v
Determine environment
    |
    v
AWS identity check
    |
    v
Terraform init
    |
    v
Terraform fmt
    |
    v
Terraform validate
    |
    v
Terraform plan
    |
    +---- DEV/QA ----> Automatic Apply
    |
    +---- PROD ------> Manual Approval
                         |
                         v
                       Apply
```

### Environment mapping

```text
develop → dev
qa      → qa
main    → prod
```

### Terraform commands used

```bash
terraform init
terraform fmt -check -recursive
terraform validate
terraform plan
terraform apply
```

---

# Infrastructure Destroy Pipeline

Infrastructure destruction is separated from normal creation.

The destroy pipeline:

```text
Checkout
   |
Determine Environment
   |
AWS Identity
   |
Terraform Init
   |
Terraform Validate
   |
Terraform Destroy Plan
   |
Manual Approval
   |
Terraform Apply Destroy Plan
```

Destroy always requires manual approval, including DEV and QA.

This prevents an ordinary branch change from automatically destroying infrastructure.

---

# Production Controls

Production has additional safeguards:

- Manual Terraform approval
- RDS deletion protection
- Multi-AZ RDS
- Final snapshot enabled
- Application deployment approval
- Separate Terraform state prefix
- Separate production configuration

---

# Deployment Workflow

The complete platform workflow is:

```text
Developer
    |
    v
GitHub
    |
    v
Jenkins
    |
    +----------------------+
    |                      |
    v                      v
Terraform Pipeline    Application Pipeline
    |                      |
    v                      v
AWS Infrastructure     Docker Build
                           |
                           v
                         ECR
                           |
                           v
                         EKS
                           |
                           v
                         ALB
                           |
                           v
                       End Users
```

---

# What This Project Demonstrates

This project demonstrates practical experience with:

- AWS cloud infrastructure
- Terraform Infrastructure as Code
- Reusable Terraform modules
- Multi-environment infrastructure
- Remote Terraform state
- Amazon EKS
- Kubernetes networking
- Private cloud architecture
- Amazon RDS
- Amazon ECR
- AWS IAM
- AWS Secrets Manager
- AWS Systems Manager
- AWS Load Balancer Controller
- Jenkins CI/CD
- Infrastructure deployment automation
- Production approval controls
- Least-privilege access
- Environment isolation
- Secure secret handling

---

# Important Repository Security Rules

The following must never be committed:

```text
*.tfstate
*.tfstate.*
.terraform/
*.tfplan
real passwords
real JWT secrets
AWS access keys
private credentials
local .env files
```

Environment `terraform.tfvars` files may contain non-secret environment configuration, but real credentials and secret values must not be committed.

---

# Deployment Prerequisites

Before using the infrastructure pipeline, Jenkins must have access to:

- AWS CLI
- Terraform
- Git
- Docker where required
- AWS IAM permissions required by Terraform
- Access to the Terraform state S3 bucket
- Permission to use the configured AWS services

The Jenkins job should run as a controlled IAM identity rather than using hardcoded AWS credentials in the repository.

---

# Recruiter Summary

**ShopSphere is a production-style AWS Platform/DevOps project that demonstrates end-to-end Infrastructure as Code and Kubernetes delivery. I designed the AWS foundation using modular Terraform, separated DEV/QA/PROD environments, stored Terraform state remotely in S3, deployed a private EKS platform, used RDS PostgreSQL and ECR, implemented SSM-based private administration, integrated Secrets Manager with EKS workload IAM, and automated infrastructure and application deployment through Jenkins with production approval controls.**
