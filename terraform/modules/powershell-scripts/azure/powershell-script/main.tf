### INTEL LICENSE STARTS BELOW
# INTEL CONFIDENTIAL
# Copyright (C) 2021-2022 Intel Corporation
# This software and the related documents are Intel copyrighted materials, and your use of them is governed by the express license under which they were provided to you ("License"). Unless the License provides otherwise, you may not use, modify, copy, publish, distribute, disclose or transmit this software or the related documents without Intel's prior written permission.
# This software and the related documents are provided as is, with no express or implied warranties, other than those that are expressly stated in the License.
### INTEL LICENSE END

resource "random_id" "storage_account_name" {
  byte_length = "8"
}

resource "azurerm_storage_blob" "script" {

  name                   = "${var.vm_name}-${basename(var.filepath)}"
  storage_account_name   = var.storage_account.name
  storage_container_name = var.storage_container.name
  type                   = "Block"
  source_content         = templatefile(var.filepath, var.template_parameters)
}

resource "azurerm_virtual_machine_extension" "powershellextension" {

  depends_on = [azurerm_storage_blob.script]

  name                       = "${var.vm_name}-${basename(var.filepath)}"
  virtual_machine_id         = var.vm_id
  publisher                  = "Microsoft.Compute"
  type                       = "CustomScriptExtension"
  type_handler_version       = "1.10"
  auto_upgrade_minor_version = "true"

  tags = var.tags

  settings = jsonencode(
    {
      "fileUris" : ["${azurerm_storage_blob.script.url}"],
      "timestamp" : 123456789
  })

  protected_settings = jsonencode(
    {
      "commandToExecute" : "${var.command_to_execute}",
      "storageAccountKey" : "${var.storage_account.primary_access_key}",
      "storageAccountName" : "${var.storage_account.name}"
  })
}
