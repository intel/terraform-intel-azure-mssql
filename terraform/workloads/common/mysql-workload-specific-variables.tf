### INTEL LICENSE STARTS BELOW
# INTEL CONFIDENTIAL
# Copyright (C) 2021-2022 Intel Corporation
# This software and the related documents are Intel copyrighted materials, and your use of them is governed by the express license under which they were provided to you ("License"). Unless the License provides otherwise, you may not use, modify, copy, publish, distribute, disclose or transmit this software or the related documents without Intel's prior written permission.
# This software and the related documents are provided as is, with no express or implied warranties, other than those that are expressly stated in the License.
### INTEL LICENSE END
variable "server_os_name" {
  default     = "CentOS8.1"
  type        = string
  description = "Sets which operating will be used for the database virtual machine."

  validation {
    condition     = contains(["CentOS8.1", "RHEL8.1", "Ubuntu20.04"], var.server_os_name)
    error_message = "Server_os_name variable is set to unsupported value. This benchmark supports \"CentOS8.1\", \"RHEL8.1\" and \"Ubuntu20.04\"."
  }
}

variable "spawn_disks" {
  type        = bool
  default     = false
  description = "(MySQL) If set to false, creates DB on os disk. If set to true, spawns %server_disks_data_size% GB sized disk for database. It does not install the database on it unless respective paramter in ansible is set."
  validation {
    condition     = can(regex("true|false", var.spawn_disks))
    error_message = "Value needs to be 'true' or 'false'."
  }
}

variable "auto_update" {
  type        = bool
  description = "(MySQL) If true, update all packages (including kernel and os package). Currently update to the newest Centos 8 (f.e 8.5)"
  default     = false
  validation {
    condition     = can(regex("true|false", var.auto_update))
    error_message = "Value needs to be 'true' or 'false'."
  }
}
