### INTEL LICENSE STARTS BELOW
# INTEL CONFIDENTIAL
# Copyright (C) 2021-2022 Intel Corporation
# This software and the related documents are Intel copyrighted materials, and your use of them is governed by the express license under which they were provided to you ("License"). Unless the License provides otherwise, you may not use, modify, copy, publish, distribute, disclose or transmit this software or the related documents without Intel's prior written permission.
# This software and the related documents are provided as is, with no express or implied warranties, other than those that are expressly stated in the License.
### INTEL LICENSE END
locals {
  device_names = ["/dev/xvdg", "/dev/xvdf", "/dev/xvdh", "/dev/xvdi", "/dev/xvdj", "/dev/xvdk", "/dev/xvdl", "/dev/xvdm", "/dev/xvdn", "/dev/xvdo", "/dev/xvdp", "/dev/xvdq", "/dev/xvdr", "/dev/xvds", "/dev/xvdt", "/dev/xvdu", "/dev/xvdv", "/dev/xvdw", "/dev/xvdx", "/dev/xvdy", "/dev/xvdz"] # xvdg is changed with xvdf to amount for F for data, G for logs

  data_disks = {
    for i in range(var.server_disks_data_disks) : format("%s", local.device_names[i + 1]) => {
      storagetype = var.server_storagetype
      size        = var.server_disks_data_size
      device_path = local.device_names[i + 1]
      iops        = var.server_disks_data_iops
      throughput  = var.server_disks_data_throughput
      tags        = var.global_tags
    }
  }
  wal_disks = {
    "${local.device_names[0]}" = {
      storagetype = var.server_storagetype
      size        = var.server_disks_wal_size
      device_path = local.device_names[0]
      iops        = var.server_disks_wal_iops
      throughput  = var.server_disks_wal_throughput
      tags        = var.global_tags
    }
  }

  disks = merge(local.data_disks, local.wal_disks)
}

module "disks" {
  source           = "../../disks/aws/"
  module_cloud_env = module.cloud-env

  depends_on = [module.vm-mssql, module.cloud-env]

  for_each = local.disks

  availability_zone = module.vm-mssql[0].vm.availability_zone
  storagetype       = each.value.storagetype
  size              = each.value.size
  device_path       = each.value.device_path
  iops              = each.value.iops
  tags              = each.value.tags
  throughput        = each.value.throughput
  vm_id             = module.vm-mssql[0].vm.id
  vm_name           = module.vm-mssql[0].vm.tags.Name
}
