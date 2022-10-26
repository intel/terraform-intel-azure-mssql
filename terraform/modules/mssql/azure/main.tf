### INTEL LICENSE STARTS BELOW
# INTEL CONFIDENTIAL
# Copyright (C) 2021-2022 Intel Corporation
# This software and the related documents are Intel copyrighted materials, and your use of them is governed by the express license under which they were provided to you ("License"). Unless the License provides otherwise, you may not use, modify, copy, publish, distribute, disclose or transmit this software or the related documents without Intel's prior written permission.
# This software and the related documents are provided as is, with no express or implied warranties, other than those that are expressly stated in the License.
### INTEL LICENSE END
locals {
  admin_username         = "testadmin" # testadmin is currently hardcoded in some ansible places
  admin_password         = random_password.mssql_password.result
  database_password      = var.database_password == null ? "${random_password.mssql_password.result}" : var.database_password
  database_startup_flags = join(",", var.database_startup_flags)

  server_storagetype = format("%s_LRS", var.server_storagetype)
  vms_list = var.dbOnly ? [
    "vm-mssql-0",
    ] : [
    "vm-mssql-0",
    "vm-hammerdb-0"
  ]

  tags = var.global_tags
}

resource "random_id" "storage_account" {
  byte_length = "8"
}

resource "random_password" "mssql_password" {
  length           = 12
  min_lower        = 1
  min_upper        = 1
  min_numeric      = 1
  min_special      = 1
  override_special = "_:"
}
## Windows

resource "azurerm_mssql_virtual_machine" "sqlextended-vm" {

  depends_on = [module.disks]

  count = var.windows ? 1 : 0

  virtual_machine_id               = module.vm-mssql[0].vm.id
  sql_license_type                 = "PAYG"
  sql_connectivity_update_password = local.database_password
  sql_connectivity_update_username = local.admin_username

  storage_configuration {
    disk_type             = "NEW"
    storage_workload_type = "OLTP"
    data_settings {
      # how can we expand this to fit multiple disks?
      default_file_path = "F:\\SQLData"
      luns              = [2]
    }
    log_settings {
      default_file_path = "G:\\SQLLog"
      luns              = [1]
    }
  }

  tags = local.tags
}
