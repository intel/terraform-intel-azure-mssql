### INTEL LICENSE STARTS BELOW
# INTEL CONFIDENTIAL
# Copyright (C) 2021-2022 Intel Corporation
# This software and the related documents are Intel copyrighted materials, and your use of them is governed by the express license under which they were provided to you ("License"). Unless the License provides otherwise, you may not use, modify, copy, publish, distribute, disclose or transmit this software or the related documents without Intel's prior written permission.
# This software and the related documents are provided as is, with no express or implied warranties, other than those that are expressly stated in the License.
### INTEL LICENSE END

locals {
  ssh_config_path = "${path.module}/${var.windows-config_file}"

  ssh_configuration = templatefile(local.ssh_config_path, { key = module.cloud-env.vm_access_key_store_public })
}

module "vm-mssql" {

  count = var.windows ? 1 : 0

  source           = "../../compute/aws/windows/"
  module_cloud_env = module.cloud-env

  name     = "${local.prefix}-vm-mssql"
  nic_name = "vm-mssql-0-nic"

  instancetype   = var.server_instancetype
  admin_username = local.admin_username
  admin_password = local.admin_password
  os_name        = var.server_os_name
  os_disksize    = null
  os_storagetype = var.server_os_storagetype
  user_data      = [local.ssh_configuration]

  tags = merge(local.tags, var.vm_tags)
}

module "vm-hammerdb" {

  count = var.windows ? (var.dbOnly ? 0 : 1) : 0

  source           = "../../compute/aws/windows/"
  module_cloud_env = module.cloud-env

  name     = "${local.prefix}-vm-hammerdb"
  nic_name = "vm-hammerdb-0-nic"

  instancetype   = var.server_hammerdb_instancetype
  admin_username = local.admin_username
  admin_password = local.admin_password
  os_name        = "WindowsServer2019"
  os_disksize    = null
  os_storagetype = "standard"
  user_data      = [local.ssh_configuration]

  tags = merge(local.tags, var.vm_tags)
}
