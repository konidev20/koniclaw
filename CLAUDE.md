# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Azure infrastructure managed via Terraform. Deploys a Linux VM (Ubuntu 24.04, spot instance) with networking, storage, and Key Vault into a configurable Azure region.

## Commands

```bash
# Initialize providers (required after clone)
cd terraform && terraform init

# Validate syntax and configuration
terraform validate

# Preview changes
terraform plan

# Apply infrastructure
terraform apply

# Retrieve SSH key after apply
terraform output -raw ssh_private_key > konidev.pem && chmod 600 konidev.pem

# Format all .tf files
terraform fmt -recursive
```

## Architecture

All Terraform code lives in `terraform/`. There is no module abstraction — resources are organized by concern into flat files:

- **main.tf** — Provider configuration (azurerm ~>4.0, tls ~>4.0). Local state only, no remote backend.
- **variables.tf** — Three inputs: `app_abbreviation`, `location`, `environment`. All have validation rules.
- **locals.tf** — Central naming convention engine. Every resource name is derived from `{type_prefix}-{app_abbreviation}-{region_short}-{environment}` using a region shorthand map. Storage accounts and container registries use hyphen-stripped variants due to Azure naming restrictions.
- **data.tf** — `azurerm_client_config` lookup for tenant-aware resources (Key Vault).
- **resource_group.tf**, **networking.tf**, **storage.tf**, **key_vault.tf**, **compute.tf** — One file per resource domain.
- **outputs.tf** — Exposes resource names, IPs, vault URI, and the SSH private key (marked sensitive).

### Naming Convention

All resource names flow through `locals.tf`. To add a new resource, add its name pattern there first, then reference `local.name_*` in the resource file. Never hardcode resource names.

### Key Design Decisions

- **Spot VM** with `Deallocate` eviction policy and max bid price of -1 (pay up to on-demand rate).
- **SSH keypair** generated via `tls_private_key` — private key exists only in Terraform state, never on disk unless explicitly exported.
- **NSG** allows SSH (port 22) from `*` — this is intentional for dev; restrict `source_address_prefix` for production.

## Security

- `terraform.tfstate` contains plaintext secrets (RSA private key, resource IDs). It is gitignored and must never be committed.
- `terraform.tfvars` is gitignored. Use `terraform.tfvars.example` for documenting expected variables.
- No hardcoded credentials — tenant ID is resolved at runtime via `data.azurerm_client_config`.
