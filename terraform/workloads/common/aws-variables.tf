### INTEL LICENSE STARTS BELOW
# INTEL CONFIDENTIAL
# Copyright (C) 2021-2022 Intel Corporation
# This software and the related documents are Intel copyrighted materials, and your use of them is governed by the express license under which they were provided to you ("License"). Unless the License provides otherwise, you may not use, modify, copy, publish, distribute, disclose or transmit this software or the related documents without Intel's prior written permission.
# This software and the related documents are provided as is, with no express or implied warranties, other than those that are expressly stated in the License.
### INTEL LICENSE END

# If used variable can have different validation dependent on the scenario,
# do not put it here, put it in benchmark-specific variables instead.

variable "scenario" {
  type        = string
  description = "Select scenario for benchmark."

  validation {
    condition     = contains(["mssql"], var.scenario)
    error_message = "Unsupported value, check documentation for supported value."
  }
}

variable "rdp_allowed_ips" {
  type        = list(string)
  default     = null
  description = "IPs to allow through RDP firewall. By default allows no addresses. This value is only used when expose_rdp is set to true simultaneously. Using literal range \"0.0.0.0/0\" is not allowed. Ranges are only correct if passed in form 'x.x.x.x/y'."
  validation {
    condition     = var.rdp_allowed_ips == null ? true : (!contains([for item in var.rdp_allowed_ips : !contains(["0.0.0.0/0"], item)], false) && !contains([for item in var.rdp_allowed_ips : can(cidrnetmask(item))], false))
    error_message = "Incorrect format of addresses or some disallowed RDP allowed addresses were passed to the variable. Using literal range \"0.0.0.0/0\" is not allowed. Consult the main repository README.md to see how to pass addresses to launcher. Ranges are only correct if passed in form 'x.x.x.x/y'."
  }
}

variable "ssh_allowed_ips" {
  type        = list(string)
  description = "IPs to allow through SSH firewall. This field must be populated for any of benchmark automation to work! Using an empty list and literal range \"0.0.0.0/0\" is not allowed. Ranges are only correct if passed in form 'x.x.x.x/y'."
  validation {
    condition     = var.ssh_allowed_ips != [""] && length(var.ssh_allowed_ips) > 0 && !contains([for item in var.ssh_allowed_ips : !contains(["0.0.0.0/0"], item)], false) && var.ssh_allowed_ips != ["''"] && !contains([for item in var.ssh_allowed_ips : can(cidrnetmask(item))], false)
    error_message = "Incorrect format of addresses or some disallowed SSH allowed addresses were passed to the variable. Using an empty list and literal range \"0.0.0.0/0\" is not allowed. Ranges are only correct if passed in form 'x.x.x.x/y'. Consult the main repository README.md to see how to pass addresses to launcher."
  }
}

variable "secret_key" {
  type        = string
  description = "AWS Secret Key to use."
  default     = null
  sensitive   = true
}

variable "access_key" {
  type        = string
  description = "AWS Access Key to use."
  default     = null
  sensitive   = true
}

variable "server_instancetype" {
  type        = string
  default     = "m6i.4xlarge"
  description = "Which instance type to use."
  validation {
    condition     = can(regex("^((r(5a|5b|6i))|(m(6a|6i|5n))).(2|4|8|16|24|32){0,1}xlarge$", var.server_instancetype))
    error_message = "Wrong database instance type has been provided. Make sure it was entered correctly."
  }
}

variable "server_hammerdb_instancetype" {
  type        = string
  default     = "m5.8xlarge"
  description = "Which instance type to use for HammerDB."
  validation {
    condition     = can(regex("^((m6i)|(m5)).(2|4|8|16|24|32){0,1}xlarge$", var.server_hammerdb_instancetype))
    error_message = "Wrong HammerDB instance type has been provided. Make sure it was entered correctly."
  }
}

variable "server_storagetype" {
  type        = string
  default     = "gp2"
  description = "Type of disks to use. Can be \"io1\", \"io2\", \"gp2\" and \"gp3\"."
  validation {
    condition     = contains(["io1", "io2", "gp2", "gp3"], var.server_storagetype)
    error_message = "Valid values for server_storagetype are 'io1', 'io2', 'gp2' and 'gp3'."
  }
}

variable "server_os_storagetype" {
  type        = string
  default     = "standard"
  description = "Type of disks to use. Can be \"io1\", \"io2\", \"gp2\" and \"gp3\" and \"standard\"."
  validation {
    condition     = contains(["io1", "io2", "gp2", "gp3", "standard"], var.server_os_storagetype)
    error_message = "Valid values for server_os_storagetype are 'io1', 'io2', 'gp2', 'gp3' and 'standard'."
  }
}

variable "server_disks_data_iops" {
  type        = number
  description = "IOPS for supported AWS disks (io1, io2, gp3). Ignored on other storage types."
  default     = 3000
  validation {
    condition = (
      var.server_disks_data_iops > 0 &&
      var.server_disks_data_iops <= 16000
    )
    error_message = "Value can't be bigger than 16000 IOPS."
  }
}

variable "server_disks_data_throughput" {
  type        = number
  description = "Throughput in MiB/s for AWS GP3 disks. Ignored on other storage types."
  default     = 125
  validation {
    condition = (
      var.server_disks_data_throughput > 0 &&
      var.server_disks_data_throughput <= 1000
    )
    error_message = "Value can't be bigger than 1000 MiB/s."
  }
}

variable "server_disks_wal_iops" {
  type        = number
  description = "IOPS for supported AWS disks (io1, io2, gp3). Ignored on other storage types."
  default     = 3000
  validation {
    condition = (
      var.server_disks_wal_iops > 0 &&
      var.server_disks_wal_iops <= 16000
    )
    error_message = "Value can't be bigger than 16000 IOPS."
  }
}

variable "server_disks_wal_throughput" {
  type        = number
  description = "Throughput in MiB/s for AWS GP3 disks. Ignored on other storage types."
  default     = 125
  validation {
    condition = (
      var.server_disks_wal_throughput > 0 &&
      var.server_disks_wal_throughput <= 1000
    )
    error_message = "Value can't be bigger than 1000 MiB/s."
  }
}

# Maybe attach that one to resources names in AWS
variable "resourcegroup" {
  type        = string
  default     = "IOCS"
  description = "What resource group should be used to spawn the resources."
  validation {
    condition = (
      length(var.resourcegroup) < 64 &&
      can(regex("^[\\w+-=._:@]+$", var.resourcegroup))
    )
    error_message = "Resourcegroup tag value can't be longer than 64 characters, and can't include special characters, besides '+', '-', '=', '.', '_', ':' and '@'."
  }
}

variable "location" {
  type        = string
  default     = "us-west-1"
  description = "What AWS region should be used for the resources."
  validation {
    condition     = contains(["us-east-2", "us-east-1", "us-west-1", "us-west-2", "af-south-1", "ap-east-1", "ap-southeast-3", "ap-south-1", "ap-northeast-3", "ap-northeast-2", "ap-southeast-1", "ap-southeast-2", "ap-northeast-1", "ca-central-1", "eu-central-1", "eu-west-1", "eu-west-2", "eu-south-1", "eu-west-3", "eu-north-1", "me-south-1", "sa-east-1"], var.location)
    error_message = "Valid values for location are: 'us-east-2', 'us-east-1', 'us-west-1', 'us-west-2', 'af-south-1', 'ap-east-1', 'ap-southeast-3', 'ap-south-1', 'ap-northeast-3', 'ap-northeast-2', 'ap-southeast-1', 'ap-southeast-2', 'ap-northeast-1', 'ca-central-1', 'eu-central-1', 'eu-west-1', 'eu-west-2', 'eu-south-1', 'eu-west-3', 'eu-north-1', 'me-south-1', 'sa-east-1'."
  }
}

variable "make_key_vault" {
  description = "If true, key vault will be created and keys uploaded into it."
  type        = bool
  default     = true
  validation {
    condition     = can(regex("true|false", var.make_key_vault))
    error_message = "Value needs to be 'true' or 'false'."
  }
}
