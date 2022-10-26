### INTEL LICENSE STARTS BELOW
# INTEL CONFIDENTIAL
# Copyright (C) 2021-2022 Intel Corporation
# This software and the related documents are Intel copyrighted materials, and your use of them is governed by the express license under which they were provided to you ("License"). Unless the License provides otherwise, you may not use, modify, copy, publish, distribute, disclose or transmit this software or the related documents without Intel's prior written permission.
# This software and the related documents are provided as is, with no express or implied warranties, other than those that are expressly stated in the License.
### INTEL LICENSE END
module "cloud-env" {
  source         = "../../cloud-env/azure"
  make_ssh_keys  = true
  make_key_vault = var.make_key_vault
  vms            = local.vms_list

  expose_rdp      = var.expose_rdp
  location        = var.location
  resourcegroup   = var.resourcegroup
  rdp_allowed_ips = var.rdp_allowed_ips
  ssh_allowed_ips = var.ssh_allowed_ips

  global_tags = var.global_tags
}
