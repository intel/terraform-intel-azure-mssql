########################
####     Intel      ####
########################

#MSSQL Sever SKU
#The Fsv2-series run on the 3rd Generation Intel® Xeon® Platinum 8370C (Ice Lake), the Intel® Xeon® Platinum 8272CL (Cascade Lake) processors, or the Intel® Xeon® Platinum 8168 (Skylake) processors.
# We recommend Compute Optimized instances - GP_Fsv2_8, GP_Fsv2_10, GP_Fsv2_12, GP_Fsv2_14, GP_Fsv2_16, GP_Fsv2_18, GP_Fsv2_20, GP_Fsv2_24, GP_Fsv2_32, GP_Fsv2_36, GP_Fsv2_72
# Ex.: GP_Fsv2_8 -> 8 stands for vCPU count
# Azure Docs:  https://learn.microsoft.com/en-us/azure/azure-sql/database/sql-database-paas-overview?view=azuresql#service-tiers

variable "db_server_sku" {
  description = "Instance SKU, see comments above for guidance"
  type        = string
  default     = "GP_Fsv2_8"
}

########################
####    Required    ####
########################

#Resource group name
variable "resource_group_name" {
  description = "Resource Group where resource will be created. It should already exist"
  type        = string
}

#MSSQL Server Name 
variable "db_server_name" {
  description = "MSSQL server name"
  type        = string
}

#MSSQL Database Name 
variable "db_name" {
  description = "MSSQL database name"
  type        = string
}

#MSSQL Server admin password. Do not commit password to version control systems 
variable "db_password" {
  description = "Password for the master database user."
  type        = string
  sensitive   = true
  validation {
    condition     = length(var.db_password) >= 8
    error_message = "The db_password value must be at least 8 characters in length."
  }
}

########################
####     Other      ####
########################

#MSSQL Server admin username 
variable "db_username" {
  description = "Username for the master database user."
  type        = string
  default     = "mssqladmin"
}

#MSSQL Version ("2.0" - v11 server) or ("12.0 "- v12 server)  
variable "db_server_version" {
  description = "Database server engine version for the Azure database instance."
  type        = string
  validation {
    condition     = contains(["2.0", "12.0"], var.db_server_version)
    error_message = "The db_server_version must be \"2.0\", or \"12.0\"."
  }
  default = "12.0"
}

#MSSQL TLS Version (Valid Values : 1.0, 1.1, 1.2, Disabled).
variable "db_min_tls_version" {
  description = "The Minimum TLS Version for all SQL Database and SQL Data Warehouse databases associated with the server"
  type        = string
  validation {
    condition     = contains(["1.0", "1.1", "1.2", "Disabled"], var.db_min_tls_version)
    error_message = "The db_min_tls_version must be \"1.0\",\"1.1\",\"1.2\", or \"Disabled\"."
  }
  default = "1.2"
}

#Flag to enable/disable public access to SQL server
variable "db_public_network_access_enabled" {
  description = "Public network access. Server is still by identity/authentication with public access enabled"
  type        = bool
  default     = false
}

#Connection Policy of SQL server
variable "db_connection_policy" {
  description = "The connection policy the server will use. Possible values are Default, Proxy, and Redirect."
  type        = string
  validation {
    condition     = contains(["Default", "Proxy", "Redirect"], var.db_connection_policy)
    error_message = "The db_connection_policy must be \"Default\",\"Proxy\" or \"Redirect\"."
  }
  default = "Default"
}

#Mode of creation for SQL DB
variable "db_create_mode" {
  description = "The create mode of the database. Possible values are Copy, Default, OnlineSecondary, PointInTimeRestore, Recovery, Restore, RestoreExternalBackup, RestoreExternalBackupSecondary, RestoreLongTermRetentionBackup and Secondary. Mutually exclusive with import."
  type        = string
  validation {
    condition     = contains(["Default", "Copy", "OnlineSecondary", "PointInTimeRestore", "Recovery", "Restore", "RestoreExternalBackup", "RestoreExternalBackupSecondary", "Secondary"], var.db_create_mode)
    error_message = "The db_create_mode must be \"Default\", \"Copy\", \"OnlineSecondary\", \"PointInTimeRestore\", \"Recovery\", \"Restore\", \"RestoreExternalBackup\",  \"RestoreExternalBackupSecondary\" or \"Secondary\"."
  }
  default = "Default"
}

variable "db_collation" {
  description = "Specifies the Collation for the MySQL Database."
  type        = string
  default     = "SQL_Latin1_General_CP1_CI_AS"
}

variable "db_geo_backup_enabled" {
  description = "A boolean that specifies if the Geo Backup Policy is enabled. Only applicable for DataWarehouse SKUs (DW*). This setting is ignored for all other SKUs."
  type        = bool
  default     = false
}

#License type for SQL DB
variable "db_license_type" {
  description = "Specifies the license type applied to this database. Possible values are LicenseIncluded and BasePrice."
  type        = string
  validation {
    condition     = contains(["LicenseIncluded", "BasePrice"], var.db_license_type)
    error_message = "The db_license_type must be \"LicenseIncluded\", or \"BasePrice\"."
  }
  default = "LicenseIncluded"
}

#Capacity for SQL DB
variable "db_max_size_gb" {
  description = "The max size of the database in gigabytes. This value should not be configured when the create_mode is Secondary or OnlineSecondary, as the sizing of the primary is then used as per Azure documentation."
  type        = number
  default     = 20
}

variable "db_create_source_id" {
  description = "The ID of the source database from which to create the new database. This should only be used for databases with create_mode values that use another database as reference. Changing this forces a new resource to be created. For creation modes other than Default, the source server ID to use."
  type        = string
  default     = null
}

variable "db_restore_time" {
  description = " Specifies the point in time (ISO8601 format) of the source database that will be restored to create the new database. This property is only settable for create_mode= PointInTimeRestore databases."
  type        = string
  default     = null
}

#Storage account type for SQL DB
variable "db_storage_account_type" {
  description = "Specifies the storage account type used to store backups for this database. Possible values are Geo, Local and Zone. The default value is Geo"
  type        = string
  validation {
    condition     = contains(["Geo", "Local", "Zone"], var.db_storage_account_type)
    error_message = "The db_license_type must be \"Geo\", \"Local\" or \"Zone\"."
  }
  default = "Geo"
}

#Flag to enable/disable Transparent Data Encryption
variable "db_transparent_data_encryption_enabled" {
  description = "If set to true, Transparent Data Encryption will be enabled on the database."
  type        = bool
  default     = true
}

variable "db_backup_retention_period" {
  description = "The days to retain backups for. Point In Time Restore configuration. Must be between 7 and 35."
  type        = number
  validation {
    condition     = var.db_backup_retention_period >= 1 && var.db_backup_retention_period <= 35
    error_message = "The db_backup_retention_period must be null or if specified between 7 and 35."
  }
  default = 7
}


variable "db_timeouts" {
  type = object({
    create = optional(string, null)
    delete = optional(string, null)
    update = optional(string, null)
  })
  description = "Map of timeouts that can be adjusted when executing the module. This allows you to customize how long certain operations are allowed to take before being considered to have failed."
  default = {
    db_timeouts = {}
  }
}

#Tags
variable "tags" {
  description = "Tags"
  type        = map(string)
  default     = {}
}
#Subnet Name
variable "subnet_name" {
  description = "Specifies the name of the Subnet."
  type        = string
  default     = null

}

#Virtual Network Name 
variable "subnet_virtual_network_name" {
  description = "Specifies the name of the Virtual Network this Subnet is located within."
  type        = string
  default     = null
}

#Resource group name that the subnet is within
variable "subnet_resource_group_name" {
  description = "Specifies the name of the resource group the Virtual Network is located in."
  type        = string
  default     = null
}

#Values for azuread_administrator block
variable "azuread_input_variables" {
  description = "The values for azuread_administrator block"
  type = list(object({
    azuread_login_username      = string
    azuread_object_id           = string
    azuread_authentication_only = bool
  }))
  default = []
}

#For example:  [{start_ip_address = ..., end_ip_address = ... },..]"
variable "firewall_ip_range" {
  type = list(object({
    start_ip_address = string
    end_ip_address   = string
  }))
  description = "User will provide range of IP adrress in form of List of (objects)"
  default     = []
}