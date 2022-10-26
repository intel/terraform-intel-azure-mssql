### INTEL LICENSE STARTS BELOW
# INTEL CONFIDENTIAL
# Copyright (C) 2021-2022 Intel Corporation
# This software and the related documents are Intel copyrighted materials, and your use of them is governed by the express license under which they were provided to you ("License"). Unless the License provides otherwise, you may not use, modify, copy, publish, distribute, disclose or transmit this software or the related documents without Intel's prior written permission.
# This software and the related documents are provided as is, with no express or implied warranties, other than those that are expressly stated in the License.
### INTEL LICENSE END
variable "script_definitions" {
  # map keys are arbitrary names
  description = "Dictionary of scripts to run on a specific VM. Each object is made of \"command_to_execute\" field, \"filepath\" from where the script can be templated, \"template_parameters\" which are passed to templatefile function and \"vm\" on which the script will be applied. \"template_parameters\" is optional if there is nothing to template in a script file and should be set to \"null\" then."
  type = map(object(
    {
      command_to_execute  = string,
      filepath            = string,
      template_parameters = any,
      vm                  = any
    })
  )
}

variable "prefix" {
  type        = string
  default     = "psscripts"
  description = "Prefix used for all resources in this module."
}

variable "cloud_env_params" {
  description = "Plugin for cloud-env outputs."
}

variable "tags" {
  description = "Tags to apply to resources. Can be null."
  default     = null
}
