### INTEL LICENSE STARTS BELOW
# INTEL CONFIDENTIAL
# Copyright (C) 2021-2022 Intel Corporation
# This software and the related documents are Intel copyrighted materials, and your use of them is governed by the express license under which they were provided to you ("License"). Unless the License provides otherwise, you may not use, modify, copy, publish, distribute, disclose or transmit this software or the related documents without Intel's prior written permission.
# This software and the related documents are provided as is, with no express or implied warranties, other than those that are expressly stated in the License.
### INTEL LICENSE END
output "vm" {
  description = "VM object created by this module."
  value       = azurerm_linux_virtual_machine.vm
}

output "vm_info" {
  description = "Object which contains additional information about VM."
  value = {
    vm_family = "linux"
  }
}
