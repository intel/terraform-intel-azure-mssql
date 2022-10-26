### INTEL LICENSE STARTS BELOW
# INTEL CONFIDENTIAL
# Copyright (C) 2021-2022 Intel Corporation
# This software and the related documents are Intel copyrighted materials, and your use of them is governed by the express license under which they were provided to you ("License"). Unless the License provides otherwise, you may not use, modify, copy, publish, distribute, disclose or transmit this software or the related documents without Intel's prior written permission.
# This software and the related documents are provided as is, with no express or implied warranties, other than those that are expressly stated in the License.
### INTEL LICENSE END

resource "azurerm_portal_dashboard" "db-dashboard" {

  name                = "${var.vm_db.name}-dashboard"
  location            = var.location
  resource_group_name = var.resourcegroup

  dashboard_properties = templatefile("${path.module}/templates/db-dashboard.tpl",
    {
      vmid   = var.vm_db.id
      vmname = var.vm_db.name
    }
  )
}

resource "azurerm_portal_dashboard" "stresser-dashboard" {

  count = var.db_only ? 0 : 1

  name                = "${var.vm_stresser.name}-dashboard"
  location            = var.location
  resource_group_name = var.resourcegroup

  dashboard_properties = templatefile("${path.module}/templates/stresser-dashboard.tpl",
    {
      vmid   = var.vm_stresser.id
      vmname = var.vm_stresser.name
    }
  )
}
