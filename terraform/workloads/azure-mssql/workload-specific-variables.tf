### INTEL LICENSE STARTS BELOW
# INTEL CONFIDENTIAL
# Copyright (C) 2021-2022 Intel Corporation
# This software and the related documents are Intel copyrighted materials, and your use of them is governed by the express license under which they were provided to you ("License"). Unless the License provides otherwise, you may not use, modify, copy, publish, distribute, disclose or transmit this software or the related documents without Intel's prior written permission.
# This software and the related documents are provided as is, with no express or implied warranties, other than those that are expressly stated in the License.
### INTEL LICENSE END
variable "server_os_name" {
  default     = "SQLServer2019"
  type        = string
  description = "Sets which operating will be used for the database virtual machine."

  validation {
    condition     = contains(["SQLServer2019"], var.server_os_name)
    error_message = "Server_os_name variable is set to unsupported value. This benchmark supports \"SQLServer2019\"."
  }
}

variable "server_disks_data_disks" {
  type        = number
  default     = 2
  description = "Used only in MSSQL benchmark. How many data disks to use. Value can't be bigger than 16 disks and must be compliant to selected VM."
  validation {
    condition = (
      var.server_disks_data_disks > 0 &&
      var.server_disks_data_disks <= 16
    )
    error_message = "Value can't be bigger than 16 disks."
  }
}

variable "server_disks_wal_size" {
  type        = number
  default     = 128
  description = "Used only in MSSQL benchmark. Specify the disk size used for SQL Server write-ahead log."
  validation {
    # Max data disk size is 32767 GB
    condition = (
      var.server_disks_wal_size > 1 &&
      var.server_disks_wal_size <= 32767
    )
    error_message = "Value can't be bigger than 32767 GB."
  }
}

variable "database_password" {
  type        = string
  description = "Password for MS SQL database. If not set password will be randomly generated"
  default     = null
  sensitive   = true
  validation {
    condition = (
      !can(regex("^(.{0,8}|[^0-9]*|[^A-Z]*|[^a-z]*|[a-zA-Z0-9]*)$", var.database_password)) ||
      var.database_password == null
    )
    error_message = "Value must be minimum 8 characters long with at least one uppercase letter, one lowercase letter, one number and one special character."
  }
}
