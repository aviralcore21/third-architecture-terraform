# Azure IaaS with Terraform

Production-oriented Terraform configuration for deploying and managing Azure Infrastructure as a Service (IaaS) resources. The approach is designed to provide repeatable, reviewable, and secure infrastructure deployments across development, staging, and production environments.

## What This Project Covers

- Azure resource groups and regional deployment boundaries
- Azure Virtual Networks, subnets, routing, and network security groups
- Linux or Windows Virtual Machines and Virtual Machine Scale Sets
- Managed disks, storage, backup, and disaster recovery foundations
- Load balancing and private connectivity patterns
- Microsoft Entra ID, managed identities, and Azure role-based access control
- Monitoring, diagnostics, policy, tagging, and cost-management foundations

## Architecture

A typical deployment uses:

1. A hub-and-spoke network topology for centralized connectivity and security.
2. Dedicated application, data, management, and private-endpoint subnets.
3. Azure Load Balancer or Application Gateway for controlled inbound traffic.
4. Private access to platform services wherever supported.
5. Network Security Groups and Azure Firewall for layered traffic control.
6. Log Analytics, Azure Monitor, and diagnostic settings for observability.
7. Azure Backup and Site Recovery based on the workload's RTO and RPO requirements.

## Repository Structure

The following structure is recommended for this Terraform project:

```text
.
├── main.tf                 # Root module composition
├── variables.tf            # Input variable declarations
├── outputs.tf              # Values exposed after deployment
├── providers.tf             # Terraform and AzureRM provider configuration
├── versions.tf              # Terraform and provider version constraints
├── locals.tf                # Shared naming and tagging values
├── backend.tf               # Remote state backend configuration
├── terraform.tfvars.example # Example environment inputs
├── modules/
│   ├── networking/
│   ├── compute/
│   ├── storage/
│   └── monitoring/
└── environments/
		├── dev/
		├── staging/
		└── prod/
```

Adapt this structure to the repository as it grows. Keep reusable modules focused and keep environment-specific values outside shared modules.

## Prerequisites

- An Azure subscription and permission to create the required resources
- [Terraform](https://developer.hashicorp.com/terraform/install) `>= 1.6.0`
- [Azure CLI](https://learn.microsoft.com/cli/azure/install-azure-cli)
- An authenticated Azure identity suitable for local development or CI/CD
- A remote state store, preferably Azure Storage with state locking enabled

Authenticate locally with Azure CLI:

```bash
az login
az account set --subscription "<subscription-id>"
```

For CI/CD, prefer workload identity federation or a managed identity over long-lived client secrets.

## Configuration

1. Copy the example variables file for the target environment.

	 ```bash
	 cp terraform.tfvars.example terraform.tfvars
	 ```

2. Set the subscription ID, location, naming prefix, workload sizing, network ranges, and required tags.
3. Configure the remote backend before using Terraform in a shared environment.
4. Store sensitive values in a secure secret store or CI/CD variable group. Do not commit secrets or state files.

Example provider configuration:

```hcl
terraform {
	required_version = ">= 1.6.0"

	required_providers {
		azurerm = {
			source  = "hashicorp/azurerm"
			version = "~> 4.0"
		}
	}
}

provider "azurerm" {
	features {}
}
```

## Deployment Workflow

Run the following commands from the appropriate environment directory or Terraform root module:

```bash
terraform init
terraform fmt -check -recursive
terraform validate
terraform plan -out=tfplan
terraform apply tfplan
```

Review the plan carefully before applying changes. Use an approved CI/CD pipeline for shared and production environments.

To remove an environment, use this only after confirming the impact:

```bash
terraform destroy
```

## Remote State

Terraform state should be stored remotely in an Azure Storage account with:

- Blob versioning and soft delete enabled
- Restricted network access and private endpoints where practical
- Encryption enabled, with customer-managed keys when required
- Separate state containers or keys for each environment
- Access controlled through Microsoft Entra ID and Azure RBAC
- State access limited to the deployment identity and approved operators

Never commit `.tfstate` files, plan files, credentials, or generated secrets to source control.

## Security and Governance

- Apply least privilege with Azure RBAC and managed identities.
- Keep management endpoints private and use Azure Bastion for administration where appropriate.
- Store secrets, certificates, and keys in Azure Key Vault.
- Use Network Security Groups, route tables, and Azure Firewall to control traffic.
- Enable Microsoft Defender for Cloud, Azure Policy, and diagnostic logging.
- Encrypt managed disks and storage accounts according to organizational requirements.
- Apply consistent `environment`, `owner`, `cost_center`, and `managed_by` tags.
- Pin Terraform and provider versions and review provider changes before upgrades.

## CI/CD Recommendations

A deployment pipeline should:

1. Run formatting and validation checks on every pull request.
2. Run security and policy scans, such as Checkov or tfsec, where approved.
3. Generate and publish a Terraform plan for review.
4. Require approval before applying changes to shared or production environments.
5. Authenticate with workload identity federation or a managed identity.
6. Archive deployment logs and retain an auditable change history.

## Testing and Validation

Before merging a change, confirm that:

```bash
terraform fmt -check -recursive
terraform validate
terraform plan
```

Also verify network reachability, identity permissions, backup configuration, monitoring alerts, and the resulting Azure Policy compliance in a non-production environment.

## Cost Management

- Right-size virtual machines using measured utilization.
- Use reservations or savings plans for predictable workloads.
- Use Spot Virtual Machines only for workloads that tolerate interruption.
- Stop or deallocate non-production virtual machines outside working hours.
- Remove unattached disks, public IP addresses, snapshots, and unused resources.
- Configure budgets and cost alerts for every subscription or environment.

## Troubleshooting

Useful commands include:

```bash
terraform state list
terraform show
az account show
az resource list --resource-group "<resource-group-name>" --output table
```

Use `terraform import` only when bringing an existing Azure resource under Terraform management. After importing, update the configuration so it accurately represents the resource and verify the result with `terraform plan`.

## Documentation

- [Terraform AzureRM provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Azure Terraform documentation](https://learn.microsoft.com/azure/developer/terraform/)
- [Azure Well-Architected Framework](https://learn.microsoft.com/azure/well-architected/)
- [Azure Cloud Adoption Framework](https://learn.microsoft.com/azure/cloud-adoption-framework/)
- [Terraform best practices](https://developer.hashicorp.com/terraform/language/style)

## License

Add the license applicable to this repository before distributing or reusing the code.
