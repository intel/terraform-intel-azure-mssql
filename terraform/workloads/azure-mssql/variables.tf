#../common/azure-variables.tf

### INTEL LICENSE STARTS BELOW
# INTEL CONFIDENTIAL
# Copyright (C) 2021-2022 Intel Corporation
# This software and the related documents are Intel copyrighted materials, and your use of them is governed by the express license under which they were provided to you ("License"). Unless the License provides otherwise, you may not use, modify, copy, publish, distribute, disclose or transmit this software or the related documents without Intel's prior written permission.
# This software and the related documents are provided as is, with no express or implied warranties, other than those that are expressly stated in the License.
### INTEL LICENSE END

# If used variable can have different validation dependent on the scenario,
# do not put it here, put it in benchmark-specific variables instead.

variable "scenario" {
  type        = string
  description = "Select scenario for benchmark."

  validation {
    condition     = contains(["mysql", "mssql", "oracle"], var.scenario)
    error_message = "Unsupported value, check documentation for supported value."
  }
}

variable "rdp_allowed_ips" {
  type        = list(string)
  default     = null
  description = "IPs to allow through RDP firewall. By default allows no addresses. This value is only used when expose_rdp is set to true simultaneously. Using literal ranges\"224.0.0.0/4\", \"255.255.255.255/32\", \"127.0.0.0/8\", \"169.254.0.0/16\", \"168.63.129.16/32\" and \"0.0.0.0/0\" is not allowed."
  validation {
    condition     = var.rdp_allowed_ips == null ? true : (!contains([for item in var.rdp_allowed_ips : !contains(["*", "Any", "224.0.0.0/4", "255.255.255.255/32", "127.0.0.0/8", "169.254.0.0/16", "168.63.129.16/32", "0.0.0.0/0"], item)], false))
    error_message = "Incorrect format of addresses or some disallowed RDP allowed addresses were passed to the variable. Using literal ranges \"224.0.0.0/4\", \"255.255.255.255/32\", \"127.0.0.0/8\", \"169.254.0.0/16\", \"168.63.129.16/32\" and \"0.0.0.0/0\" is not allowed. Consult the main repository README.md to see how to pass addresses to launcher."
  }
}

variable "ssh_allowed_ips" {
  type        = list(string)
  default = [ "192.55.55.56" ]
  description = "IPs to allow through SSH firewall. This field must be populated for any of benchmark automation to work! Using \"*\", \"Any\", an empty list and literal ranges \"224.0.0.0/4\", \"255.255.255.255/32\", \"127.0.0.0/8\", \"169.254.0.0/16\", \"168.63.129.16/32\" and \"0.0.0.0/0\" is not allowed."
  validation {
    condition     = var.ssh_allowed_ips != [""] && length(var.ssh_allowed_ips) > 0 && !contains([for item in var.ssh_allowed_ips : !contains(["*", "Any", "224.0.0.0/4", "255.255.255.255/32", "127.0.0.0/8", "169.254.0.0/16", "168.63.129.16/32", "0.0.0.0/0"], item)], false) && var.ssh_allowed_ips != ["''"]
    error_message = "Incorrect format of addresses or some disallowed SSH allowed addresses were passed to the variable. Using \"*\", \"Any\", an empty list and literal ranges \"224.0.0.0/4\", \"255.255.255.255/32\", \"127.0.0.0/8\", \"169.254.0.0/16\", \"168.63.129.16/32\" and \"0.0.0.0/0\" is not allowed. Consult the main repository README.md to see how to pass addresses to launcher."
  }
}

variable "subscription_id" {
  type        = string
  description = "Azure Subscription ID to use."
  default     = null
  sensitive   = true
}

variable "client_id" {
  type        = string
  description = "Azure Client ID to use."
  default     = null
  sensitive   = true
}

variable "client_secret" {
  type        = string
  description = "Azure Service Principal secret to use."
  default     = null
  sensitive   = true
}

variable "tenant_id" {
  type        = string
  description = "Azure Tenant ID to use."
  default     = null
  sensitive   = true
}

variable "server_instancetype" {
  type        = string
  default     = "Standard_E64ds_v4"
  description = "Which instance type to use."
  validation {
    condition     = can(regex("^Standard_[A-Z][1-9][0-9]{0,2}(d|s|(as)|(ds)){0,1}_v[0-9]$", var.server_instancetype))
    error_message = "Wrong database instance type has been provided. Make sure it was entered correctly."
  }
}

variable "server_hammerdb_instancetype" {
  type        = string
  default     = "Standard_E32_v4"
  description = "Which instance type to use for HammerDB."
  validation {
    condition     = can(regex("^Standard_[A-Z][1-9][0-9]{0,2}(d|s|(as)|(ds)){0,1}_v[0-9]$", var.server_hammerdb_instancetype))
    error_message = "Wrong HammerDB instance type bas been been provided. Make sure it was entered correctly."
  }
}

variable "server_storagetype" {
  type        = string
  default     = "Premium"
  description = "Type of disks to use. Currently supports Standard and Premium."
  validation {
    condition     = contains(["Premium", "Standard"], var.server_storagetype)
    error_message = "Valid values for server_storagetype are: 'Premium', 'Standard'."
  }
}

variable "server_os_storagetype" {
  type        = string
  default     = "Standard"
  description = "Type of disks to use for Operating System. Currently supports Standard and Premium."
  validation {
    condition     = contains(["Premium", "Standard"], var.server_os_storagetype)
    error_message = "Valid values for server_os_storagetype are: 'Premium', 'Standard'."
  }
}

variable "resourcegroup" {
  type        = string
  default     = "IntelOptimizedCloudStack"
  description = "What resource group should be used to spawn the resources."
  validation {
    condition = (
      length(var.resourcegroup) < 64 &&
      can(regex("^[\\w+-|_]+$", var.resourcegroup))
    )
    error_message = "Value can't be longer than 64 characters, and can't include special characters, besides '-' or '_'."
  }
}

variable "location" {
  type        = string
  default     = "West US"
  description = "What Azure region should be used for the resources."
  validation {
    condition     = contains(["West US", "Central US", "East US", "East US 2", "US Gov Iowa", "US Gov Virginia", "North Central US", "South Central US", "North Europe", "West Europe", "East Asia", "Southeast Asia", "Japan East", "Japan West", "Brazil South", "Australia East", "Australia Southeast", "Central India", "South India", "West India"], var.location)
    error_message = "Valid values for location are: 'West US', 'Central US', 'East US', 'East US 2', 'US Gov Iowa', 'US Gov Virginia', 'North Central US', 'South Central US', 'North Europe', 'West Europe', 'East Asia', 'Southeast Asia', 'Japan East', 'Japan West', 'Brazil South', 'Australia East', 'Australia Southeast', 'Central India', 'South India', 'West India'."
  }
}

variable "make_key_vault" {
  description = "If true, key vault will be created and keys uploaded into it."
  type        = bool
  default     = true
  validation {
    condition     = can(regex("true|false", var.make_key_vault))
    error_message = "Value needs to be 'true' or 'false'."
  }
}
