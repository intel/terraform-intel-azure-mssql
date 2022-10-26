### INTEL LICENSE STARTS BELOW
# INTEL CONFIDENTIAL
# Copyright (C) 2021-2022 Intel Corporation
# This software and the related documents are Intel copyrighted materials, and your use of them is governed by the express license under which they were provided to you ("License"). Unless the License provides otherwise, you may not use, modify, copy, publish, distribute, disclose or transmit this software or the related documents without Intel's prior written permission.
# This software and the related documents are provided as is, with no express or implied warranties, other than those that are expressly stated in the License.
### INTEL LICENSE END
locals {
  os_disk_config = {
    name                 = "${var.name}-osdisk"
    caching              = "ReadWrite",
    storage_account_type = format("%s_LRS", var.os_storagetype),
    disk_size_gb         = var.os_disksize
  }
}

resource "azurerm_linux_virtual_machine" "vm" {

  name                = var.name
  location            = var.module_cloud_env.resources_location
  resource_group_name = var.module_cloud_env.resource_group_name

  network_interface_ids = [lookup(var.module_cloud_env.cloud_network_interfaces, var.nic_name)]

  custom_data    = var.custom_data
  size           = var.instancetype
  admin_username = var.admin_username

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.module_cloud_env.vm_access_key_store_public
  }


  source_image_reference {
    publisher = local.source_images_list[var.os_name].publisher
    offer     = local.source_images_list[var.os_name].offer
    sku       = local.source_images_list[var.os_name].sku
    version   = local.source_images_list[var.os_name].version
  }

  os_disk {
    name                 = local.os_disk_config.name
    caching              = local.os_disk_config.caching
    storage_account_type = local.os_disk_config.storage_account_type
    disk_size_gb         = local.os_disk_config.disk_size_gb
  }

  tags = var.tags
}
