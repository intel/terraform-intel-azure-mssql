### INTEL LICENSE STARTS BELOW
# INTEL CONFIDENTIAL
# Copyright (C) 2021-2022 Intel Corporation
# This software and the related documents are Intel copyrighted materials, and your use of them is governed by the express license under which they were provided to you ("License"). Unless the License provides otherwise, you may not use, modify, copy, publish, distribute, disclose or transmit this software or the related documents without Intel's prior written permission.
# This software and the related documents are provided as is, with no express or implied warranties, other than those that are expressly stated in the License.
### INTEL LICENSE END

/**
 * Module which creates Windows VMs.
 */

locals {
  os_disk_config = {
    name                 = "${var.name}-osdisk"
    caching              = "ReadWrite",
    storage_account_type = format("%s_LRS", var.os_storagetype),
    disk_size_gb         = var.os_disksize
  }
}

# We should port this to azurerm_windows_virtual_machine - azurerm_virtual_machine is frozen and old
resource "azurerm_virtual_machine" "vm" {

  name = var.name

  location            = var.module_cloud_env.resources_location
  resource_group_name = var.module_cloud_env.resource_group_name

  network_interface_ids = [lookup(var.module_cloud_env.cloud_network_interfaces, var.nic_name)]

  vm_size = var.instancetype

  delete_os_disk_on_termination = true

  storage_os_disk {
    name              = local.os_disk_config.name
    caching           = local.os_disk_config.caching
    managed_disk_type = local.os_disk_config.storage_account_type
    create_option     = "FromImage"
    disk_size_gb      = var.os_disksize
  }

  storage_image_reference {
    publisher = local.source_images_list[var.os_name].publisher
    offer     = local.source_images_list[var.os_name].offer
    sku       = local.source_images_list[var.os_name].sku
    version   = local.source_images_list[var.os_name].version
  }

  os_profile_windows_config {
    provision_vm_agent = true
  }

  os_profile {
    computer_name  = var.name
    admin_username = var.admin_username
    admin_password = var.admin_password
  }

  tags = var.tags
}
