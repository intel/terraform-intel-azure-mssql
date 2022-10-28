#Resource group name
variable "resource_group_name" {
  description = "Resource Group where resource will be created. It should already exist"
  type        = string
}

variable "subnet_name"{
  description = "Specifies the name of the Subnet."
  type = string
}

variable "subnet_virtual_network_name"{
  description = "Specifies the name of the Virtual Network this Subnet is located within."
  type = string
}

variable "subnet_resource_group_name"{
  description = "Specifies the name of the resource group the Virtual Network is located in."
  type = string
}

variable "azuread_login_username" {
  description = "The login username of the Azure AD Administrator of this SQL Server."
  type = string
}

variable "azuread_object_id" {
  description =  "The object id of the Azure AD Administrator of this SQL Server."
  type = string
}


#MSSQL Server Name 
variable "mssql_server_name" {
  description = "MSSQL server name"
  type        = string
}

#MySQL Server admin password. Do not commit password to version control systems 
variable "mssql_administrator_login_password" {
  description = "MSSQL server name admin password"
  type        = string
}

#MSSQL Database Name (ASK LUCAS if we provide a default or not?)
variable "mssql_db_name" {
  description = "MSSQL database name"
  type        = string

}

#MySQL Server admin username 
variable "mssql_administrator_login" {
  description = "MSSQL server name admin username"
  type        = string
  default     = "mssqladmin"
}

#MSSQL Version ("2.0" - v11 server) or ("12.0 "- v12 server)  
variable "mysql_version" {
  description = "MySQL Version"
  type        = string
  default     = "12.0"
}

#MSSQL TLS Version (Valid Values : 1.0, 1.1, 1.2, Disabled).
variable "mysql_min_tls_version" {
  description = "MySQL minimum TLS Version"
  type        = string
  default     = "1.2"
}

#MSSQL Sever SKU
#The Fsv2-series run on the 3rd Generation Intel® Xeon® Platinum 8370C (Ice Lake), the Intel® Xeon® Platinum 8272CL (Cascade Lake) processors, or the Intel® Xeon® Platinum 8168 (Skylake) processors.
# We recommend Compute Optimized instances - GP_Fsv2_8, GP_Fsv2_10, GP_Fsv2_12, GP_Fsv2_14, GP_Fsv2_16, GP_Fsv2_18, GP_Fsv2_20, GP_Fsv2_24, GP_Fsv2_32, GP_Fsv2_36, GP_Fsv2_72
# Ex.: GP_Fsv2_8 -> 8 stands for vCPU count
variable "mssql_server_sku" {
  description = "Instance SKU, see comments above for guidance"
  default     = "GP_Fsv2_8"
}

variable "public_network_access_enabled" {
  description = "Public network access. Server is still by identity/authentication with public access enabled"
  type        = bool
  default     = true
}

variable "connection_policy" {
  description = "The connection policy the server will use. Possible values are Default, Proxy, and Redirect."
  type        = string 
  default     = "Default"
}

variable "create_mode" {
  description = "The create mode of the database. Possible values are Copy, Default, OnlineSecondary, PointInTimeRestore, Recovery, Restore, RestoreExternalBackup, RestoreExternalBackupSecondary, RestoreLongTermRetentionBackup and Secondary. Mutually exclusive with import."
  type        = string 
  default     = "Default" 
}

variable "license_type" {
  description = "Specifies the license type applied to this database. Possible values are LicenseIncluded and BasePrice."
  type        = string 
  default     = "LicenseIncluded" 
}

variable "max_size_gb" {
  description = "The max size of the database in gigabytes."
  type        = number 
  default     = 20
}

variable "storage_account_type" {
  description = "Specifies the storage account type used to store backups for this database. Possible values are Geo, Local and Zone. The default value is Geo"
  type        = string 
  default     = "Geo"
}

variable "transparent_data_encryption_enabled" {
  description = "If set to true, Transparent Data Encryption will be enabled on the database."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags"
  type        = map(string)
  default     = {}
}

#For example:  [{start_ip_address = ..., end_ip_address = ... },..]"
variable "firewall_ip_range" {
  type = list(object({
    start_ip_address  = string
    end_ip_address    = string
  }))
  description = "User will provide range of IP adrress in form of List of (objects)"             
  default = []
}

variable "azuread_authentication_only" {
  description = "Specifies whether only AD Users and administrators (like azuread_administrator.0.login_username) can be used to login, or also local database users (like administrator_login). When true, the administrator_login and administrator_login_password properties can be omitted"
  type = bool
  default = false
}


