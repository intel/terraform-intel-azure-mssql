### INTEL LICENSE STARTS BELOW
# INTEL CONFIDENTIAL
# Copyright (C) 2021-2022 Intel Corporation
# This software and the related documents are Intel copyrighted materials, and your use of them is governed by the express license under which they were provided to you ("License"). Unless the License provides otherwise, you may not use, modify, copy, publish, distribute, disclose or transmit this software or the related documents without Intel's prior written permission.
# This software and the related documents are provided as is, with no express or implied warranties, other than those that are expressly stated in the License.
### INTEL LICENSE END
locals {
  # throughput is in MiB/s
  default_settings = {
    "gp3" = { "iops" = 3000, "throughput" = 125 },
    "io1" = { "iops" = 3000 },
    "io2" = { "iops" = 3000 }
  }

  disk_prefix_fstring = "${var.vm_name}-${var.device_path}"

  iops_sanitized = contains(["io1", "io2", "gp3"], var.storagetype) ? (
  var.iops == null ? local.default_settings[var.storagetype].iops : var.iops) : null

  throughput_sanitized = contains(["gp3"], var.storagetype) ? (
  var.throughput == null ? local.default_settings[var.storagetype].throughput : var.throughput) : null
}

# iops works only on io1, io2 and gp3
# throughput works only on gp3

resource "aws_ebs_volume" "disk" {

  tags = merge(var.tags, {
    Name = local.disk_prefix_fstring,
  })

  availability_zone = var.availability_zone
  encrypted         = true
  kms_key_id        = var.module_cloud_env.kms_key_arn
  iops              = local.iops_sanitized
  throughput        = local.throughput_sanitized
  size              = var.size
  type              = var.storagetype
}

resource "aws_volume_attachment" "disks_attachments" {
  volume_id    = aws_ebs_volume.disk.id
  instance_id  = var.vm_id
  device_name  = var.device_path
  force_detach = true
}
