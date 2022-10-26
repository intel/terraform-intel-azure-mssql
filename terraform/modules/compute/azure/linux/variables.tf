### INTEL LICENSE STARTS BELOW
# INTEL CONFIDENTIAL
# Copyright (C) 2021-2022 Intel Corporation
# This software and the related documents are Intel copyrighted materials, and your use of them is governed by the express license under which they were provided to you ("License"). Unless the License provides otherwise, you may not use, modify, copy, publish, distribute, disclose or transmit this software or the related documents without Intel's prior written permission.
# This software and the related documents are provided as is, with no express or implied warranties, other than those that are expressly stated in the License.
### INTEL LICENSE END

variable "name" {
  type        = string
  description = "VM name."
}

variable "module_cloud_env" {
  description = "Plugin for cloud-env module outputs."
}

variable "nic_name" {
  description = "Network Interface to attach."
}

variable "os_name" {
  description = "Name of OS that will be used. For now \"CentOS8.1\" and \"RHEL8.1\" and \"Ubuntu20.04\" are supported."
  validation {
    condition     = contains(["CentOS8.1", "RHEL8.1", "Ubuntu20.04", "OracleDB19"], var.os_name)
    error_message = "Os_name variable is set to unsupported value. Currently supports \"CentOS8.1\", \"RHEL8.1\", \"Ubuntu20.04\" and \"OracleDB19\"."
  }
}

variable "custom_data" {
  default     = null
  description = "Cloud-config data encoded as base64."
}

variable "instancetype" {
  type        = string
  description = "VM instance size."
}

variable "admin_username" {
  type        = string
  default     = "adminuser"
  description = "Username which will be used for administrator account. Defaults to \"adminuser\"."
}

variable "os_disksize" {
  type        = number
  default     = null
  description = "(Optional) Size of OS disk. If left unset, defaults to OS image size."
}

variable "os_storagetype" {
  type        = string
  default     = "Standard"
  description = "(Optional) Type of OS disk. If left unset, defaults 'Standard' disk type."
}

variable "tags" {
  description = "Tags which will be applied to VM-related resources."
}
