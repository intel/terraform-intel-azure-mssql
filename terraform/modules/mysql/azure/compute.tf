### INTEL LICENSE STARTS BELOW
# INTEL CONFIDENTIAL
# Copyright (C) 2021-2022 Intel Corporation
# This software and the related documents are Intel copyrighted materials, and your use of them is governed by the express license under which they were provided to you ("License"). Unless the License provides otherwise, you may not use, modify, copy, publish, distribute, disclose or transmit this software or the related documents without Intel's prior written permission.
# This software and the related documents are provided as is, with no express or implied warranties, other than those that are expressly stated in the License.
### INTEL LICENSE END
# TODO: Maybe rework this to use vm_list local?

module "vm-mysql" {

  count = var.linux ? 1 : 0

  source           = "../../compute/azure/linux/"
  module_cloud_env = module.cloud-env

  name         = "vm-mysql"
  nic_name     = "vm-mysql-0-nic"
  instancetype = var.server_instancetype

  admin_username = local.admin_username
  os_name        = var.server_os_name
  os_disksize    = var.server_os_disksize
  os_storagetype = var.server_os_storagetype

  tags = merge(var.global_tags, var.vm_tags)
}

module "vm-hammerdb" {

  count = var.linux ? (var.dbOnly ? 0 : 1) : 0

  source           = "../../compute/azure/linux/"
  module_cloud_env = module.cloud-env

  name         = "vm-hammerdb"
  nic_name     = "vm-hammerdb-0-nic"
  instancetype = var.server_hammerdb_instancetype

  admin_username = local.admin_username
  os_name        = "CentOS8.1"
  os_disksize    = null
  os_storagetype = "Standard"

  tags = merge(var.global_tags, var.vm_tags)
}
