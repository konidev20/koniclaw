variable "app_abbreviation" {
  description = "Short application identifier used as the base for all resource names (e.g. \"klaw\")."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]{2,8}$", var.app_abbreviation))
    error_message = "app_abbreviation must be 2–8 lowercase alphanumeric characters with no hyphens or underscores."
  }
}

variable "location" {
  description = "Azure region for all resources (e.g. \"eastus\", \"centralindia\"). Must match a key in the region_shorthand map in locals.tf."
  type        = string
}

variable "environment" {
  description = "Deployment environment abbreviation appended to all resource names."
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "stg", "prd", "sbx"], var.environment)
    error_message = "environment must be one of: dev, stg, prd, sbx."
  }
}
