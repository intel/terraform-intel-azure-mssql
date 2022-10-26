### INTEL LICENSE STARTS BELOW
# INTEL CONFIDENTIAL
# Copyright (C) 2021-2022 Intel Corporation
# This software and the related documents are Intel copyrighted materials, and your use of them is governed by the express license under which they were provided to you ("License"). Unless the License provides otherwise, you may not use, modify, copy, publish, distribute, disclose or transmit this software or the related documents without Intel's prior written permission.
# This software and the related documents are provided as is, with no express or implied warranties, other than those that are expressly stated in the License.
### INTEL LICENSE END
variable "prefix" {
  type        = string
  default     = "iocs"
  description = "Prefix used for all resources in this module. Will be merged with random id from Terraform."
}

#variable "location" {
#  type        = string
#  default     = "West US"
#  description = "The Azure Region in which the resources in this example should exist."
#}

#variable "resourcegroup" {
#  type        = string
#  default     = "GoldenImageResourceGroup"
#  description = "The Azure resource group in which the resources should be created."
#}

variable "vms" {
  type        = set(string)
  description = "The list with vms names."
}

variable "make_ssh_keys" {
  type        = bool
  default     = true
  description = "Create a keypair."
}

variable "make_key_vault" {
  type        = bool
  default     = true
  description = "Create a key vault and upload SSH keys (public and private) into it."
}

variable "expose_rdp" {
  type        = bool
  default     = false
  description = "Should RDP firewall rule be created?"
}

variable "rdp_allowed_ips" {
  type    = list(string)
  default = null

  description = "Comma-separated IPs (in CIDR format) which are allowed through the RDP firewall rules."
  validation {
    condition     = var.rdp_allowed_ips == null ? true : (!contains([for item in var.rdp_allowed_ips : !contains(["0.0.0.0/0"], item)], false) && !contains([for item in var.rdp_allowed_ips : can(cidrnetmask(item))], false))
    error_message = "Using \"0.0.0.0/0\" is not allowed in rdp_allowed_ips. Consult main repository README.md to see how to pass addresses to launcher."
  }
}

variable "ssh_allowed_ips" {
  type    = list(string)
  default = ["127.0.0.0/8"]

  description = "Comma-separated IPs (in CIDR format) which are allowed through the SSH firewall rules."
  validation {
    condition     = var.ssh_allowed_ips != [""] && length(var.ssh_allowed_ips) > 0 && !contains([for item in var.ssh_allowed_ips : !contains(["0.0.0.0/0"], item)], false) && var.ssh_allowed_ips != ["''"] && !contains([for item in var.ssh_allowed_ips : can(cidrnetmask(item))], false)
    error_message = "Either no SSH allowed addresses were passed or \"0.0.0.0/0\" was passed. Using \"0.0.0.0/0\" is not allowed. Consult main repository README.md to see how to pass addresses to launcher."
  }
}

variable "global_tags" {
  default     = {}
  description = "Tags that will be applied to the infrastructure. Not all of the resources support adding tags and these will not be tagged."
}
