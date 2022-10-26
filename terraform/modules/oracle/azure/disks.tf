### INTEL LICENSE STARTS BELOW
# INTEL CONFIDENTIAL
# Copyright (C) 2021-2022 Intel Corporation
# This software and the related documents are Intel copyrighted materials, and your use of them is governed by the express license under which they were provided to you ("License"). Unless the License provides otherwise, you may not use, modify, copy, publish, distribute, disclose or transmit this software or the related documents without Intel's prior written permission.
# This software and the related documents are provided as is, with no express or implied warranties, other than those that are expressly stated in the License.
### INTEL LICENSE END
locals {
  data_disks = var.spawn_disks ? {
    "lun0" = {
      managed_disk_type = local.server_storagetype
      disk_size_gb      = var.server_disks_data_size
      lun_number        = 0
      caching           = "auto"
      tags              = var.global_tags
    }
  } : {}
  wal_disks = var.spawn_disks ? {
    "lun1" = {
      managed_disk_type = local.server_storagetype
      disk_size_gb      = var.server_disks_wal_size
      lun_number        = 1
      caching           = "None"
      tags              = var.global_tags
    }
  } : {}

  disks = merge(local.data_disks, local.wal_disks)
}

module "disks" {

  source           = "../../disks/azure/"
  cloud_env_params = module.cloud-env

  depends_on = [module.vm-oracle]

  for_each = local.disks

  managed_disk_type = each.value.managed_disk_type
  disk_size_gb      = each.value.disk_size_gb
  lun_number        = each.value.lun_number
  caching           = each.value.caching
  tags              = each.value.tags
  vm_id             = module.vm-oracle[0].vm.id
  vm_name           = module.vm-oracle[0].vm.name
}
