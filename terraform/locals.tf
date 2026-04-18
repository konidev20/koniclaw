locals {

  ##############################################################################
  # REGION SHORTHAND MAP
  # Key   = exact azurerm location string (lowercase, as Azure/Terraform expect)
  # Value = short abbreviation used in resource names
  # Add new regions here as the project expands.
  ##############################################################################
  region_shorthand = {
    # United States
    "eastus"         = "eus"
    "eastus2"        = "eus2"
    "westus"         = "wus"
    "westus2"        = "wus2"
    "westus3"        = "wus3"
    "centralus"      = "cus"
    "northcentralus" = "ncus"
    "southcentralus" = "scus"
    "westcentralus"  = "wcus"

    # Europe
    "northeurope"        = "neu"
    "westeurope"         = "weu"
    "uksouth"            = "uks"
    "ukwest"             = "ukw"
    "francecentral"      = "frc"
    "francesouth"        = "frs"
    "germanywestcentral" = "gwc"
    "germanynorth"       = "gno"
    "switzerlandnorth"   = "swn"
    "switzerlandwest"    = "sww"
    "norwayeast"         = "noe"
    "norwaywest"         = "now"
    "swedencentral"      = "swc"
    "polandcentral"      = "plc"
    "italynorth"         = "itn"
    "spaincentral"       = "spc"

    # Asia Pacific
    "eastasia"           = "ea"
    "southeastasia"      = "sea"
    "australiaeast"      = "aue"
    "australiasoutheast" = "ause"
    "australiacentral"   = "auc"
    "australiacentral2"  = "auc2"
    "japaneast"          = "jpe"
    "japanwest"          = "jpw"
    "koreacentral"       = "krc"
    "koreasouth"         = "krs"
    "southindia"         = "sin"
    "centralindia"       = "cind"
    "westindia"          = "wind"

    # Middle East & Africa
    "uaenorth"         = "uaen"
    "uaecentral"       = "uaec"
    "southafricanorth" = "san"
    "southafricawest"  = "saw"
    "israelcentral"    = "ilc"
    "qatarcentral"     = "qac"

    # Canada
    "canadacentral" = "cac"
    "canadaeast"    = "cae"

    # South America
    "brazilsouth"     = "brs"
    "brazilsoutheast" = "brse"

    # US Government
    "usgovarizona"  = "usga"
    "usgovvirginia" = "usgv"
    "usgovtexas"    = "usgt"
  }

  ##############################################################################
  # RESOLVED VALUES
  # region_short: fails loudly at plan time if var.location is not in the map.
  # name_base:    the repeating root token shared by all resource names.
  ##############################################################################
  region_short = local.region_shorthand[var.location]
  name_base    = "${var.app_abbreviation}-${local.region_short}-${var.environment}"

  ##############################################################################
  # RESOURCE NAMES
  # Pattern : {type_prefix}-{name_base}
  #         = {type_prefix}-{app_abbreviation}-{region_short}-{environment}
  #
  # Special cases (Azure forbids hyphens in the name):
  #   Storage Account  — prefix "st",  no hyphens, max 24 chars
  #   Container Reg.   — prefix "cr",  no hyphens, max 50 chars
  #
  # For multiple instances of one type, append a suffix at the resource level:
  #   name = "${local.name_subnet}-app"   →  snet-klaw-eus-dev-app
  ##############################################################################

  # Compute
  name_resource_group   = "rg-${local.name_base}"    # max 90 chars
  name_virtual_machine  = "vm-${local.name_base}"    # max 15 chars (Windows) / 64 chars (Linux)
  name_vm_scale_set     = "vmss-${local.name_base}"  # max 64 chars
  name_availability_set = "avail-${local.name_base}" # max 80 chars

  # Networking
  name_virtual_network   = "vnet-${local.name_base}" # max 64 chars
  name_subnet            = "snet-${local.name_base}" # max 80 chars
  name_network_interface = "nic-${local.name_base}"  # max 80 chars
  name_public_ip         = "pip-${local.name_base}"  # max 80 chars
  name_network_sg        = "nsg-${local.name_base}"  # max 80 chars
  name_load_balancer     = "lb-${local.name_base}"   # max 80 chars
  name_app_gateway       = "agw-${local.name_base}"  # max 80 chars
  name_bastion_host      = "bas-${local.name_base}"  # max 80 chars
  name_firewall          = "afw-${local.name_base}"  # max 80 chars
  name_vpn_gateway       = "vgw-${local.name_base}"  # max 80 chars
  name_local_network_gw  = "lgw-${local.name_base}"  # max 80 chars
  name_route_table       = "rt-${local.name_base}"   # max 80 chars
  name_private_endpoint  = "pe-${local.name_base}"   # max 80 chars
  name_private_dns_zone  = "pdns-${local.name_base}" # max 63 chars per label

  # Storage
  # Storage accounts: max 24 chars, lowercase alphanumeric ONLY — no hyphens.
  name_storage_account   = substr(replace("st${var.app_abbreviation}${local.region_short}${var.environment}", "-", ""), 0, 24)
  name_storage_container = "sc-${local.name_base}" # max 63 chars

  # Security & Identity
  name_key_vault         = "kv-${local.name_base}"          # max 24 chars
  name_managed_identity  = "id-${local.name_base}"          # max 128 chars
  name_kv_secret_ssh_key = "ssh-privkey-${local.name_base}" # max 127 chars

  # Databases
  name_sql_server        = "sql-${local.name_base}"    # max 63 chars
  name_sql_database      = "sqldb-${local.name_base}"  # max 128 chars
  name_cosmos_account    = "cosmos-${local.name_base}" # max 44 chars
  name_postgresql_server = "psql-${local.name_base}"   # max 63 chars
  name_mysql_server      = "mysql-${local.name_base}"  # max 63 chars
  name_redis_cache       = "redis-${local.name_base}"  # max 63 chars

  # App Services & Containers
  name_app_service_plan = "asp-${local.name_base}"  # max 40 chars
  name_app_service      = "app-${local.name_base}"  # max 60 chars
  name_function_app     = "func-${local.name_base}" # max 60 chars
  # Container registries: max 50 chars, alphanumeric ONLY — no hyphens.
  name_container_registry = substr(replace("cr${var.app_abbreviation}${local.region_short}${var.environment}", "-", ""), 0, 50)
  name_aks_cluster        = "aks-${local.name_base}" # max 63 chars

  # Monitoring
  name_log_analytics      = "log-${local.name_base}"  # max 63 chars
  name_app_insights       = "appi-${local.name_base}" # max 260 chars
  name_monitor_action_grp = "ag-${local.name_base}"   # max 260 chars
  name_recovery_vault     = "rsv-${local.name_base}"  # max 50 chars

  # Integration
  name_service_bus_ns = "sb-${local.name_base}"    # max 50 chars
  name_event_hub_ns   = "evhns-${local.name_base}" # max 50 chars
  name_event_hub      = "evh-${local.name_base}"   # max 256 chars
  name_api_management = "apim-${local.name_base}"  # max 50 chars

  # VM-specific
  name_ssh_key_pair = "kp-${local.name_base}"     # SSH key pair stored in Azure
  name_os_disk      = "osdisk-${local.name_base}" # VM OS disk
  name_data_disk    = "disk-${local.name_base}"   # VM data disk

  # AI Foundry (separate resource group)
  name_resource_group_ai  = "rg-ai-${local.name_base}"
  name_ai_foundry         = "aih-${local.name_base}"
  name_key_vault_ai       = "kv-ai-${local.name_base}"                                                                    # max 24 chars
  name_storage_account_ai = substr(replace("stai${var.app_abbreviation}${local.region_short}${var.environment}", "-", ""), 0, 24)

  ##############################################################################
  # COMMON TAGS
  # Applied to every resource. Extend here if additional global tags are needed.
  ##############################################################################
  common_tags = {
    environment      = var.environment
    app_abbreviation = var.app_abbreviation
    location         = var.location
  }

  ##############################################################################
  # NETWORKING ADDRESS SPACES
  ##############################################################################
  vnet_address_space    = "10.0.0.0/16"
  subnet_address_prefix = "10.0.1.0/24"

}
