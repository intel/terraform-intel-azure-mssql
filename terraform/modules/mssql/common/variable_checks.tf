### INTEL LICENSE STARTS BELOW
# INTEL CONFIDENTIAL
# Copyright (C) 2021-2022 Intel Corporation
# This software and the related documents are Intel copyrighted materials, and your use of them is governed by the express license under which they were provided to you ("License"). Unless the License provides otherwise, you may not use, modify, copy, publish, distribute, disclose or transmit this software or the related documents without Intel's prior written permission.
# This software and the related documents are provided as is, with no express or implied warranties, other than those that are expressly stated in the License.
### INTEL LICENSE END

#variable "rdp_vars_check" {
#  type = object({
#    expose_rdp      = bool
#    rdp_allowed_ips = list(string)
#  })
#  description = "Internal testing variable, do not set or override."
#  validation {
#    condition     = var.rdp_vars_check.expose_rdp == true ? var.rdp_vars_check.rdp_allowed_ips != null : true
#    error_message = "If expose_rdp variable is set to true, rdp_allowed_ips must be set."
#  }
#}


