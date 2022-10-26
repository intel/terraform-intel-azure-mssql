### INTEL LICENSE STARTS BELOW
# INTEL CONFIDENTIAL
# Copyright (C) 2021-2022 Intel Corporation
# This software and the related documents are Intel copyrighted materials, and your use of them is governed by the express license under which they were provided to you ("License"). Unless the License provides otherwise, you may not use, modify, copy, publish, distribute, disclose or transmit this software or the related documents without Intel's prior written permission.
# This software and the related documents are provided as is, with no express or implied warranties, other than those that are expressly stated in the License.
### INTEL LICENSE END
variable "module_cloud_env" {
  description = "Takes Cloud-env object."
}

variable "availability_zone" {
  type        = string
  description = "Availability zone to use. Should be set to VMs AZ."
}

variable "device_path" {
  type        = string
  description = "Device name to mount at. Refer to AWS \"Device names on Windows instances\" and \"Device names on Linux instances\" guides to understand allowed device names."
}

variable "storagetype" {
  type        = string
  description = "Type of storage to use."
}

variable "size" {
  type        = number
  description = "Size of created disk."
}

variable "iops" {
  default     = null
  type        = number
  description = "IOPS parameter of created disk (only supported on some disk types). If omitted, uses default."
}

variable "throughput" {
  default     = null
  type        = number
  description = "Throughput parameter of created disk (only supported on some disk types). If omitted, uses default."
}

variable "tags" {
  description = "Tags which to attach to disk."
}

variable "vm_id" {
  description = "ID of VM object to which disks should be attached."
}

variable "vm_name" {
  type        = string
  description = "Name of VM object to which disks should be attached."
}
