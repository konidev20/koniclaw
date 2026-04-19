# koniclaw

Terraform configuration for a lightweight Azure development environment. Deploys an Ubuntu 24.04 spot VM with networking, storage, Key Vault, and backup into a configurable Azure region.

## What gets deployed

- **Resource group** — scoped to the app/environment
- **Virtual network + subnet + NSG** — SSH (port 22) open for dev use
- **Linux VM** — Ubuntu 24.04, spot instance with `Deallocate` eviction policy
- **Storage account** — general-purpose V2, LRS
- **Key Vault** — stores the generated SSH private key
- **Recovery Services Vault** — VM backup with LRS storage

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.5.0
- Azure CLI authenticated (`az login`)

## Usage

```bash
cd terraform
terraform init
cp terraform.tfvars.example terraform.tfvars   # fill in your values
terraform plan
terraform apply
```

After apply, retrieve the SSH key:

```bash
terraform output -raw ssh_private_key > konidev.pem && chmod 600 konidev.pem
ssh -i konidev.pem konidev@<vm_public_ip>
```

## Variables

| Name | Description | Default |
|------|-------------|---------|
| `app_abbreviation` | Short identifier used in all resource names (2–8 lowercase alphanumeric chars) | — |
| `location` | Azure region (e.g. `eastus`, `centralindia`) | — |
| `environment` | One of `dev`, `stg`, `prd`, `sbx` | `dev` |
| `vm_admin_username` | Linux admin username | `konidev` |

## Security notes

- `terraform.tfstate` contains the SSH private key in plaintext — keep it local and never commit it.
- `terraform.tfvars` is gitignored. Use `terraform.tfvars.example` as a template.
- The NSG allows SSH from any source (`*`) — restrict `source_address_prefix` before using in production.
