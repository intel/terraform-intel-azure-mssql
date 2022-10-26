### INTEL LICENSE STARTS BELOW
# INTEL CONFIDENTIAL
# Copyright (C) 2021-2022 Intel Corporation
# This software and the related documents are Intel copyrighted materials, and your use of them is governed by the express license under which they were provided to you ("License"). Unless the License provides otherwise, you may not use, modify, copy, publish, distribute, disclose or transmit this software or the related documents without Intel's prior written permission.
# This software and the related documents are provided as is, with no express or implied warranties, other than those that are expressly stated in the License.
### INTEL LICENSE END
variable "prefix" {
  type        = string
  default     = "mysql"
  description = "The Prefix used for all resources in module."
}

variable "server_os_name" {
  default     = "CentOS8.1"
  description = "Sets which OS will be used for the virtual machines. For now \"CentOS8.1\" and \"RHEL8.1\" are supported."
  validation {
    condition     = contains(["CentOS8.1", "RHEL8.1", "Ubuntu20.04"], var.server_os_name)
    error_message = "Server_os_name variable is set to unsupported value. This benchmark supports \"CentOS8.1\" and \"RHEL8.1\"."
  }
}

# TODO: validate whether linux is true when windows is false or the other way around

variable "server_storagetype" {
  type        = string
  description = "Disk type standard/standardSSD/premium/ultraSSD."
  default     = "Standard"

  validation {
    condition     = var.server_storagetype == "Standard" || var.server_storagetype == "StandardSSD" || var.server_storagetype == "Premium"
    error_message = "Unsupported storagetype, must be \"Standard\", \"StandardSSD\", \"Premium\". \"UltraSSD\" may be added in the future."
  }
}

variable "server_os_storagetype" {
  type        = string
  description = "Disk type standard/standardSSD/premium/ultraSSD for Operating System"
  default     = "Standard"

  validation {
    condition     = var.server_os_storagetype == "Standard" || var.server_os_storagetype == "StandardSSD" || var.server_os_storagetype == "Premium"
    error_message = "Unsupported storagetype, must be \"Standard\", \"StandardSSD\", \"Premium\". \"UltraSSD\" may be added in the future."
  }
}

variable "server_disks_data_size" {
  type        = number
  description = "Disk size (GB) for SQL data disk in servers."
  default     = "512"
}

variable "server_instancetype" {
  type        = string
  description = "Instance type name - must be a full name (e.g. Standard_E4ds_v4)."
  default     = "Standard_E4ds_v4"
}

variable "server_hammerdb_instancetype" {
  type        = string
  description = "HammerDB Instance type name - must be a full name (e.g. Standard_E4ds_v4)"
  default     = "Standard_E32_v4"
}

variable "server_os_disksize" {
  type        = number
  default     = 1024
  description = "Size of MySQL OS disk in GB."
}

variable "resourcegroup" {
  type        = string
  default     = "GoldenImageResourceGroup"
  description = "The Azure resource group in which the resources should be created."
}

variable "linux" {
  type        = bool
  default     = true
  description = "If should run linux-based benchmark."
}

variable "windows" {
  type        = bool
  default     = false
  description = "If should run windows-based benchmark."
}

variable "dbOnly" {
  type        = bool
  default     = false
  description = "Create the database VM only (without HammerDB)."
}

variable "spawn_disks" {
  type        = bool
  default     = false
  description = "Should the data disks be spawned?"
}

variable "location" {
  type        = string
  default     = "West US"
  description = "Region to create Azure resources in."
}

variable "expose_rdp" {
  type        = bool
  description = "Should RDP rule be created?"
}

variable "rdp_allowed_ips" {
  description = "RDP allowed IPs"
}

variable "ssh_allowed_ips" {
  description = "SSH allowed IPs"
}

variable "global_tags" {
  default     = {}
  description = "Tags applied to whole deployment"
}

variable "vm_tags" {
  default     = {}
  description = "Tags applied to VMs"
}

variable "make_key_vault" {
  description = "If true, key vault will be created and SSH keys uploaded into it."
  type        = bool
  default     = true
}
