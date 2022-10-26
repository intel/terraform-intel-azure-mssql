#../common/azure-outputs.tf

### INTEL LICENSE STARTS BELOW
# INTEL CONFIDENTIAL
# Copyright (C) 2021-2022 Intel Corporation
# This software and the related documents are Intel copyrighted materials, and your use of them is governed by the express license under which they were provided to you ("License"). Unless the License provides otherwise, you may not use, modify, copy, publish, distribute, disclose or transmit this software or the related documents without Intel's prior written permission.
# This software and the related documents are provided as is, with no express or implied warranties, other than those that are expressly stated in the License.
### INTEL LICENSE END
#locals {
#  keyvault_name = var.make_key_vault ? module.benchmark.cloud-environment.azure_keyvault_name : ""
#}

#output "x_1_key_vault_name" {
#  description = "Key Vault name to use for sharing the keys"
#  value       = var.make_key_vault ? local.keyvault_name : null
#}

output "x_2_key_vault_private_key" {
  description = "Name of the private key in Key Vault - used for sharing access to VMs"
  value       = var.make_key_vault ? "ssh-key-azure-vm" : null
}
