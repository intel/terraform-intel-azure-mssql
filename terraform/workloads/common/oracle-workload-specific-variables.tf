### INTEL LICENSE STARTS BELOW
# INTEL CONFIDENTIAL
# Copyright (C) 2021-2022 Intel Corporation
# This software and the related documents are Intel copyrighted materials, and your use of them is governed by the express license under which they were provided to you ("License"). Unless the License provides otherwise, you may not use, modify, copy, publish, distribute, disclose or transmit this software or the related documents without Intel's prior written permission.
# This software and the related documents are provided as is, with no express or implied warranties, other than those that are expressly stated in the License.
### INTEL LICENSE END
variable "server_os_name" {
  default     = "OracleDB19"
  type        = string
  description = "Sets which operating will be used for the database virtual machine."

  validation {
    condition     = contains(["OracleDB19"], var.server_os_name)
    error_message = "Server_os_name variable is set to unsupported value. This benchmark supports \"OracleDB19\"."
  }
}

variable "spawn_disks" {
  type        = bool
  default     = false
  description = "Used in Oracle and MySQL benchmark. If set to false, creates DB on os disk. If set to true, spawns %server_disks_data_size% GB sized disk for database. It does not install the database on it unless respective paramter in ansible is set."
  validation {
    condition     = can(regex("true|false", var.spawn_disks))
    error_message = "Value needs to be 'true' or 'false'."
  }
}

variable "server_disks_wal_size" {
  type        = number
  default     = 512
  description = "Used in Oracle and MS SQL benchmark. Specify the disk size used for Oracle redo logs."
  validation {
    # Max data disk size is 32767 GB
    condition = (
      var.server_disks_wal_size > 1 &&
      var.server_disks_wal_size <= 32767
    )
    error_message = "Value can't be bigger than 32767 GB."
  }
}
