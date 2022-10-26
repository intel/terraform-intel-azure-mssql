### INTEL LICENSE STARTS BELOW
# INTEL CONFIDENTIAL
# Copyright (C) 2021-2022 Intel Corporation
# This software and the related documents are Intel copyrighted materials, and your use of them is governed by the express license under which they were provided to you ("License"). Unless the License provides otherwise, you may not use, modify, copy, publish, distribute, disclose or transmit this software or the related documents without Intel's prior written permission.
# This software and the related documents are provided as is, with no express or implied warranties, other than those that are expressly stated in the License.
### INTEL LICENSE END
module "scripts" {
  source = "./powershell-script"

  for_each = var.script_definitions

  cloud_env_params  = var.cloud_env_params
  storage_account   = azurerm_storage_account.script_storage_acc
  storage_container = azurerm_storage_container.script_storage_cont

  command_to_execute = each.value.command_to_execute

  filepath            = each.value.filepath
  template_parameters = each.value.template_parameters

  vm_id   = each.value.vm.id
  vm_name = each.value.vm.name

  tags = var.tags
}
