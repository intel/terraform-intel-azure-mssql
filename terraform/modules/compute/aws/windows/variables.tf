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
  description = "Name of OS that will be used. Currently can be \"WindowsServer2019\" or \"SQLServer2019\"."
  validation {
    condition     = contains(["WindowsServer2019", "SQLServer2019"], var.os_name)
    error_message = "Os_name variable is set to unsupported value. Currently supports \"WindowsServer2019\" and \"SQLServer2019\"."
  }
}

variable "instancetype" {
  type        = string
  description = "AWS VM instance type."
}

variable "admin_username" {
  type        = string
  default     = "adminuser"
  description = "Username which will be used for administrator account. Defaults to \"adminuser\"."
}

variable "admin_password" {
  type        = string
  description = "Passwords which will be used for administrator account. Does not have a default value and has to be set."
}

variable "os_disksize" {
  type        = number
  default     = null
  description = "(Optional) Size of OS disk. If left unset, defaults to OS image size."
}

variable "os_storagetype" {
  type        = string
  default     = "standard"
  description = "(Optional) Type of OS disk. If left unset, defaults 'standard' disk type."
}

variable "user_data" {
  type        = list(string)
  default     = null
  description = "List of templatefile outputs passed to user-data parameter, used to launch short EC2Launch scripts. This can run Powershell and other scripts."
}

variable "tags" {
  description = "Tags which will be applied to VM-related resources."
}

variable "windows-powershell-template_file" {
  type        = string
  default     = "../templates/aws-userdata.tmpl"
  description = "Path to AWS Powershell user_data template"
}

variable "windows-user-config_file" {
  type        = string
  default     = "../templates/modify-admin-account.ps1"
  description = "Path to Windows Administrator user modification script"
}

