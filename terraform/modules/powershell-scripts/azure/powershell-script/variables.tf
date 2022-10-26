### INTEL LICENSE STARTS BELOW
# INTEL CONFIDENTIAL
# Copyright (C) 2021-2022 Intel Corporation
# This software and the related documents are Intel copyrighted materials, and your use of them is governed by the express license under which they were provided to you ("License"). Unless the License provides otherwise, you may not use, modify, copy, publish, distribute, disclose or transmit this software or the related documents without Intel's prior written permission.
# This software and the related documents are provided as is, with no express or implied warranties, other than those that are expressly stated in the License.
### INTEL LICENSE END
variable "cloud_env_params" {
  description = "Plugin for cloud-env outputs."
}

variable "command_to_execute" {
  type        = string
  description = "Command that will be executed by extension."
}

variable "filepath" {
  type        = string
  description = "Script filepath."
  default     = null
}

variable "storage_account" {
  description = "Storage account to use for upload."
}

variable "storage_container" {
  description = "Storage container to use for upload."
}

variable "tags" {
  description = "Tags to use for resources. Can be null."
  default     = null
}

variable "template_parameters" {
  description = "Variables to use inside templates."
}

variable "vm_id" {
  description = "ID of VM object to which disks should be attached."
}

variable "vm_name" {
  type        = string
  description = "VM name to which disks should be attached."
}
