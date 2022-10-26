### INTEL LICENSE STARTS BELOW
# INTEL CONFIDENTIAL
# Copyright (C) 2021-2022 Intel Corporation
# This software and the related documents are Intel copyrighted materials, and your use of them is governed by the express license under which they were provided to you ("License"). Unless the License provides otherwise, you may not use, modify, copy, publish, distribute, disclose or transmit this software or the related documents without Intel's prior written permission.
# This software and the related documents are provided as is, with no express or implied warranties, other than those that are expressly stated in the License.
### INTEL LICENSE END
locals {

  cache_type_from_size = var.disk_size_gb > 2048 ? "None" : "ReadOnly"
  caching              = var.caching == "auto" ? local.cache_type_from_size : var.caching

  disk_prefix_fstring = "${var.vm_name}-lun-%d"

}

resource "azurerm_managed_disk" "disk" {
  location            = var.cloud_env_params.resources_location
  resource_group_name = var.cloud_env_params.resource_group_name

  create_option = "Empty"
  tags          = var.tags

  name                 = format(local.disk_prefix_fstring, var.lun_number)
  disk_size_gb         = var.disk_size_gb
  storage_account_type = var.managed_disk_type
}

resource "azurerm_virtual_machine_data_disk_attachment" "disks_attachments" {
  managed_disk_id    = azurerm_managed_disk.disk.id
  caching            = local.caching
  virtual_machine_id = var.vm_id
  lun                = var.lun_number
}
