### INTEL LICENSE STARTS BELOW
# INTEL CONFIDENTIAL
# Copyright (C) 2021-2022 Intel Corporation
# This software and the related documents are Intel copyrighted materials, and your use of them is governed by the express license under which they were provided to you ("License"). Unless the License provides otherwise, you may not use, modify, copy, publish, distribute, disclose or transmit this software or the related documents without Intel's prior written permission.
# This software and the related documents are provided as is, with no express or implied warranties, other than those that are expressly stated in the License.
### INTEL LICENSE END
variable "prefix" {
  type        = string
  default     = "mssql"
  description = "The Prefix used for all resources in module"
}

variable "windows-config_file" {
  type        = string
  default     = "../templates/common.ps1"
  description = "Path to Windows SSH Configuration script"
}

variable "server_storagetype" {
  type        = string
  description = "Data disk type."
  default     = "standard"

  validation {
    condition     = contains(["io1", "io2", "gp2", "gp3"], var.server_storagetype)
    error_message = "Valid values for server_storagetype are 'io1', 'io2', 'gp2' and 'gp3'."
  }
}

# I think this is not necessary for OS disks
variable "server_disks_data_iops" {
  type        = number
  description = "IOPS for supported AWS disks (io1, io2, gp3). Ignored on other storage types."
  default     = null # keep AWS defaults if not set
}

# I think this is not necessary for OS disks
variable "server_disks_data_throughput" {
  type        = number
  description = "IOPS for AWS GP3 disks. Ignored on other storage types."
  default     = null # keep AWS defaults if not set  
}

variable "server_disks_wal_iops" {
  type        = number
  description = "IOPS for supported AWS disks (io1, io2, gp3). Ignored on other storage types."
  default     = null # keep AWS defaults if not set
}

variable "server_disks_wal_throughput" {
  type        = number
  description = "IOPS for AWS GP3 disks. Ignored on other storage types."
  default     = null # keep AWS defaults if not set  
}

variable "server_os_storagetype" {
  type        = string
  description = "OS disk type"
  default     = "standard"

  validation {
    condition     = contains(["io1", "io2", "gp2", "gp3", "standard"], var.server_os_storagetype)
    error_message = "Valid values for server_os_storagetype are 'io1', 'io2', 'gp2', 'gp3' and 'standard'."
  }
}

variable "server_disks_data_disks" {
  type        = number
  description = "How many data disks should be created for database?"
  validation {
    condition = (
      var.server_disks_data_disks > 0 &&
      var.server_disks_data_disks <= 16
    )
    error_message = "It is currently supported to create up to 16 data disks."
  }
  default = 1
}

variable "server_disks_data_size" {
  type        = number
  description = "Disk size (GiB) for SQL servers data disks"
  validation {
    condition     = var.server_disks_data_size > 0
    error_message = "Data disks must be at least 1GiB in size."
  }
  default = "100"
}

variable "server_disks_wal_size" {
  type        = number
  description = "Disk size (GiB) for SQL servers WAL disk"
  validation {
    condition     = var.server_disks_wal_size > 0
    error_message = "Log disk must be at least 1GiB in size."
  }
  default = "100"
}

variable "server_instancetype" {
  type        = string
  description = "SQL instance type name - must be a full name (e.g. m5.2xlarge)"
  default     = "m5.2xlarge" # only some instances are supported w/ SQL Server 2019 AMI
}

variable "server_hammerdb_instancetype" {
  type        = string
  description = "Instance type name - must be a full name (e.g. m5.4xlarge)"
  default     = "m5.4xlarge"
}

variable "server_os_name" {
  description = "Sets which Windows OS will be used for the database VM. For now \"SQLServer2019\" is supported."
  validation {
    condition     = contains(["SQLServer2019"], var.server_os_name)
    error_message = "Server_os_name variable is set to unsupported value. This benchmark supports \"SQLServer2019\"."
  }
}

variable "resourcegroup" {
  type        = string
  default     = "OCS"
  description = "The Azure resource group in which the resources should be created"
}

variable "linux" {
  default = false
  validation {
    condition     = var.linux == false
    error_message = "MSSQL on Linux is currently unsupported."
  }
  description = "Should we run linux-based benchmark? Currently unsupported here"
}

variable "windows" {
  type        = bool
  default     = true
  description = "Should we run windows-based benchmark?"
}

variable "dbOnly" {
  type        = bool
  default     = false
  description = "Create the database VM only (without HammerDB)."
}

variable "database_password" {
  type        = string
  default     = null
  description = "Password for MS SQL database"
}

variable "database_startup_flags" {
  default     = []
  description = "Which parameter flags use for MS SQL server startup."
}

variable "location" {
  type        = string
  default     = "West US"
  description = "Region to create Azure resources in"
}

variable "dbname" {
  type        = string
  default     = "tpcc_200WH"
  description = "DB name to created"
}

variable "expose_rdp" {
  type        = bool
  description = "Should RDP firewall rule be created?"
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

# Custom validations - TODO: PORT TO AWS
# variable "server_instancetype_disknumber_validation" { }
