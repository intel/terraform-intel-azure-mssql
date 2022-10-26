### INTEL LICENSE STARTS BELOW
# INTEL CONFIDENTIAL
# Copyright (C) 2021-2022 Intel Corporation
# This software and the related documents are Intel copyrighted materials, and your use of them is governed by the express license under which they were provided to you ("License"). Unless the License provides otherwise, you may not use, modify, copy, publish, distribute, disclose or transmit this software or the related documents without Intel's prior written permission.
# This software and the related documents are provided as is, with no express or implied warranties, other than those that are expressly stated in the License.
### INTEL LICENSE END

#module "dashboards" {
#  source = "../../modules/dashboards/azure"
#
#  location      = var.location
#  resourcegroup = var.resourcegroup
#
#  db_only     = var.dbOnly
#  vm_db       = module.benchmark.vm_db.vm
#  vm_stresser = var.dbOnly ? null : module.benchmark.vm_stresser.vm
#}

module "benchmark" {
  source = "../../modules/mssql/azure/"

# update into var.linux and var.windows passing in the future
  linux             = false
  windows           = true
  dbOnly            = var.dbOnly
  database_password = var.database_password

  location      = var.location
  resourcegroup = var.resourcegroup

  server_disks_data_disks = var.server_disks_data_disks
  server_disks_data_size  = var.server_disks_data_size
  server_disks_wal_size   = var.server_disks_wal_size
  server_storagetype      = var.server_storagetype
  server_os_storagetype   = var.server_os_storagetype

  server_instancetype          = var.server_instancetype
#  server_hammerdb_instancetype = var.server_hammerdb_instancetype
  server_os_name               = var.server_os_name

  make_key_vault  = var.make_key_vault
  expose_rdp      = var.expose_rdp
  rdp_allowed_ips = var.rdp_allowed_ips
  ssh_allowed_ips = var.ssh_allowed_ips
#  rdp_vars_check = {
#    expose_rdp      = var.expose_rdp
#    rdp_allowed_ips = var.rdp_allowed_ips
#  }
#
  global_tags = var.global_tags
  vm_tags     = var.vm_tags

  server_instancetype_disknumber_validation = {
    server_disks_data_disks = var.server_disks_data_disks
    server_instancetype     = var.server_instancetype
  }
}
