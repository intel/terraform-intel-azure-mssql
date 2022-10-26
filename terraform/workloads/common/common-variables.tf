### INTEL LICENSE STARTS BELOW
# INTEL CONFIDENTIAL
# Copyright (C) 2021-2022 Intel Corporation
# This software and the related documents are Intel copyrighted materials, and your use of them is governed by the express license under which they were provided to you ("License"). Unless the License provides otherwise, you may not use, modify, copy, publish, distribute, disclose or transmit this software or the related documents without Intel's prior written permission.
# This software and the related documents are provided as is, with no express or implied warranties, other than those that are expressly stated in the License.
### INTEL LICENSE END
variable "server_disks_data_size" {
  type        = number
  default     = 512
  description = "How big should each data disk be in GB? Minimally 1. Used in MSSQL, MySQL and Oracle (together with \"spawn_disks\"=true and mysql_mount_dir set to \"/mnt/mysqldata\" and oracle_mount_dir set to \"/mnt/oracledata\")."
  validation {
    # Max data disk size is 32767 GB
    condition = (
      var.server_disks_data_size > 1 &&
      var.server_disks_data_size <= 32767
    )
    error_message = "Value can't be bigger than 32767 GB."
  }
}

variable "custom_profile" {
  type        = string
  default     = ""
  description = "Select preprepared custom scenario for benchmark test."
  validation {
    condition = (
      contains(["azure_mysql_SmallDB", "azure_mysql_MediumDB", "azure_mysql_LargeDB", "azure_mssql_SmallDB", "azure_mssql_MediumDB", "azure_mssql_LargeDB", "azure_oracle_SmallDB", "azure_oracle_MediumDB", "aws_mssql_SmallDB", "aws_mssql_MediumDB"], var.custom_profile) ||
      var.custom_profile == ""
    )
    error_message = "Valid values for custom_profile are: 'azure_mysql_SmallDB', 'azure_mysql_MediumDB', 'azure_mysql_LargeDB', 'azure_mssql_SmallDB', 'azure_mssql_MediumDB', 'azure_mssql_LargeDB', 'azure_oracle_SmallDB', 'azure_oracle_MediumDB', 'aws_mssql_SmallDB', 'aws_mssql_MediumDB'."
  }
}

variable "dbOnly" {
  type        = bool
  default     = false
  description = "If set to \"true\", only the database VM is deployed."
  validation {
    condition     = can(regex("true|false", var.dbOnly))
    error_message = "Value needs to be 'true' or 'false'."
  }
}

variable "linux" {
  type        = bool
  default     = true
  description = "Run benchmark on Linux."
  validation {
    condition     = can(regex("true|false", var.linux))
    error_message = "Value needs to be 'true' or 'false'."
  }
}

variable "windows" {
  type        = bool
  default     = false
  description = "Run benchmark on Windows."
  validation {
    condition     = can(regex("true|false", var.windows))
    error_message = "Value needs to be 'true' or 'false'."
  }
}

variable "server_os_disksize" {
  type        = number
  default     = 1024
  description = "Size of database OS disk. Might need to be customized when not using spawn_disks set to \"true\" with large warehouses."
  validation {
    # Max OS disk size is 2048 GB
    condition = (
      var.server_os_disksize > 1 &&
      var.server_os_disksize <= 2048
    )
    error_message = "Value can't be bigger than 2048 GB."
  }
}

variable "expose_rdp" {
  type        = bool
  default     = false
  description = "Should RDP be exposed to the Internet?"
}

variable "global_tags" {
  default     = {}
  type        = map(string)
  description = "Dictionary of tags that will be applied to deployment."
}

variable "vm_tags" {
  default     = {}
  type        = map(string)
  description = "Dictionary of additional tags that will be applied to VMs only."
}
