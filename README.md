<p align="center">
  <img src="https://github.com/intel/terraform-intel-azure-mssql/blob/main/images/logo-classicblue-800px.png?raw=true" alt="Intel Logo" width="250"/>
</p>

# Intel Optimized Cloud Modules for Terraform

© Copyright 2025, Intel Corporation

## Azure MSSQL Server Module

This module can be used to deploy an Intel optimized Azure SQL Server instance.
Instance selection is included by default in the code.

Additional MSSQL Optimizations can based off [Intel Xeon Tuning Guide](<https://www.intel.com/content/www/us/en/developer/articles/guide/sql-server-tuning-guide-for-otp-using-xeon.html#:~:text=benchmarking%20hardware%20configuration%3A-,Tuning%20SQL%20Server%20for%20OLTP%20Workload,-The%20following%20sp_configure%3E>). Scroll down to 'Tuning SQL Server for OLTP Workload' section.

## Performance Data
### Performance data below is for 3rd Generation Intel® Xeon® Scalable Processors, 5th Generation coming soon...
<center>

#### [Process up to 1.37x more transactions with Azure SQL Server on 3rd Generation Intel® Xeon® Scalable Processor (Ice Lake) vs. older instances](https://www.intel.com/content/www/us/en/content-details/755166/get-up-to-37-more-sql-server-oltp-performance-by-selecting-premium-series-microsoft-azure-sql-managed-instance-vms-with-3rd-gen-intel-xeon-scalable-processors.html)

<p align="center">
  <a href="https://www.intel.com/content/www/us/en/content-details/755166/get-up-to-37-more-sql-server-oltp-performance-by-selecting-premium-series-microsoft-azure-sql-managed-instance-vms-with-3rd-gen-intel-xeon-scalable-processors.html">
  <img src="https://github.com/intel/terraform-intel-azure-mssql/blob/main/images/azure-sql-1.png?raw=true" alt="Link" width="600"/>
  </a>
</p>

#

#### [Get up to 1.39x more Azure SQL Server performance on 3rd Generation Intel® Xeon® Scalable Processor (Ice Lake) vs. competition](https://www.intel.com/content/www/us/en/content-details/764685/achieve-more-microsoft-sql-server-work-by-selecting-microsoft-azure-d-series-and-e-series-vms-enabled-by-3rd-gen-intel-xeon-scalable-processors.html)

<p align="center">
  <a href="https://www.intel.com/content/www/us/en/content-details/764685/achieve-more-microsoft-sql-server-work-by-selecting-microsoft-azure-d-series-and-e-series-vms-enabled-by-3rd-gen-intel-xeon-scalable-processors.html">
  <img src="https://github.com/intel/terraform-intel-azure-mssql/blob/main/images/azure-sql-2.png?raw=true" alt="Link" width="600"/>
  </a>
</p>

#

#### [Handle up to 1.48x higher Azure SQL Server online transactions on 3rd Generation Intel® Xeon® Scalable Processor (Ice Lake) vs. older instances](https://www.intel.com/content/www/us/en/content-details/755095/microsoft-azure-esv5-virtual-machines-delivered-up-to-48-higher-microsoft-sql-server-online-transaction-processing-performance-than-esv4-virtual-machines.html)

<p align="center">
  <a href="https://www.intel.com/content/www/us/en/content-details/755095/microsoft-azure-esv5-virtual-machines-delivered-up-to-48-higher-microsoft-sql-server-online-transaction-processing-performance-than-esv4-virtual-machines.html">
  <img src="https://github.com/intel/terraform-intel-azure-mssql/blob/main/images/azure-sql-3.png?raw=true" alt="Link" width="600"/>
  </a>
</p>

#

#### [Get more Azure SQL server performance on 3rd Generation Intel® Xeon® Scalable Processor (Ice Lake)](https://www.intel.com/content/www/us/en/content-details/756434/get-up-to-49-better-microsoft-sql-server-online-transaction-processing-performance-by-selecting-microsoft-azure-dsv5-virtual-machines-rather-than-dsv4-virtual-machines.html)

<p align="center">
  <a href="https://www.intel.com/content/www/us/en/content-details/756434/get-up-to-49-better-microsoft-sql-server-online-transaction-processing-performance-by-selecting-microsoft-azure-dsv5-virtual-machines-rather-than-dsv4-virtual-machines.html">
  <img src="https://github.com/intel/terraform-intel-azure-mssql/blob/main/images/azure-sql-4.png?raw=true" alt="Link" width="600"/>
  </a>
</p>

</center>

## Usage

**See examples folder for complete examples.**

By default, you will only have to pass four variables

```hcl
resource_group_name 
mssql_server_name  
mssql_db_name 
mssql_administrator_login_password 
```
variables.tf

```hcl
variable "db_password" {
  description = "Password for the master database user."
  type        = string
  sensitive   = true
}
```
main.tf
```hcl
module "optimized-mssql-server" {
  source                             = "intel/azure-mssql/intel"
  resource_group_name                = "ENTER_RG_NAME_HERE"
  mssql_server_name                  = "ENTER_MSSQL_SERVER_NAME_HERE"
  mssql_db_name                      = "ENTER_MSSQL_DB_NAME_HERE"
  mssql_administrator_login_password = var.db_password
  
}
```



Run Terraform

```hcl
export TF_VAR_db_password ='<USE_A_STRONG_PASSWORD>'

terraform init  
terraform plan
terraform apply 
```
## Considerations

This module further provides the ability to add firewall_ip_range, virtual network rule and azuread_administration resource block (Usage Example provided above). For information : https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_server
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~>3.86 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~>3.86 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_mssql_database.mssql_db](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_database) | resource |
| [azurerm_mssql_firewall_rule.mssql_firewall_rule](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_firewall_rule) | resource |
| [azurerm_mssql_server.mssql_server](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_server) | resource |
| [azurerm_mssql_virtual_network_rule.mssql_vnet_rule](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_virtual_network_rule) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_subnet.subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_azuread_input_variables"></a> [azuread\_input\_variables](#input\_azuread\_input\_variables) | The values for azuread\_administrator block | <pre>list(object({<br>    azuread_login_username      = string<br>    azuread_object_id           = string<br>    azuread_authentication_only = bool<br>  }))</pre> | `[]` | no |
| <a name="input_db_backup_retention_period"></a> [db\_backup\_retention\_period](#input\_db\_backup\_retention\_period) | The days to retain backups for. Point In Time Restore configuration. Must be between 7 and 35. | `number` | `7` | no |
| <a name="input_db_collation"></a> [db\_collation](#input\_db\_collation) | Specifies the Collation for the MySQL Database. | `string` | `"SQL_Latin1_General_CP1_CI_AS"` | no |
| <a name="input_db_connection_policy"></a> [db\_connection\_policy](#input\_db\_connection\_policy) | The connection policy the server will use. Possible values are Default, Proxy, and Redirect. | `string` | `"Default"` | no |
| <a name="input_db_create_mode"></a> [db\_create\_mode](#input\_db\_create\_mode) | The create mode of the database. Possible values are Copy, Default, OnlineSecondary, PointInTimeRestore, Recovery, Restore, RestoreExternalBackup, RestoreExternalBackupSecondary, RestoreLongTermRetentionBackup and Secondary. Mutually exclusive with import. | `string` | `"Default"` | no |
| <a name="input_db_create_source_id"></a> [db\_create\_source\_id](#input\_db\_create\_source\_id) | The ID of the source database from which to create the new database. This should only be used for databases with create\_mode values that use another database as reference. Changing this forces a new resource to be created. For creation modes other than Default, the source server ID to use. | `string` | `null` | no |
| <a name="input_db_geo_backup_enabled"></a> [db\_geo\_backup\_enabled](#input\_db\_geo\_backup\_enabled) | A boolean that specifies if the Geo Backup Policy is enabled. Only applicable for DataWarehouse SKUs (DW*). This setting is ignored for all other SKUs. | `bool` | `false` | no |
| <a name="input_db_license_type"></a> [db\_license\_type](#input\_db\_license\_type) | Specifies the license type applied to this database. Possible values are LicenseIncluded and BasePrice. | `string` | `"LicenseIncluded"` | no |
| <a name="input_db_max_size_gb"></a> [db\_max\_size\_gb](#input\_db\_max\_size\_gb) | The max size of the database in gigabytes. This value should not be configured when the create\_mode is Secondary or OnlineSecondary, as the sizing of the primary is then used as per Azure documentation. | `number` | `20` | no |
| <a name="input_db_min_tls_version"></a> [db\_min\_tls\_version](#input\_db\_min\_tls\_version) | The Minimum TLS Version for all SQL Database and SQL Data Warehouse databases associated with the server | `string` | `"1.2"` | no |
| <a name="input_db_name"></a> [db\_name](#input\_db\_name) | MSSQL database name | `string` | n/a | yes |
| <a name="input_db_password"></a> [db\_password](#input\_db\_password) | Password for the master database user. | `string` | n/a | yes |
| <a name="input_db_public_network_access_enabled"></a> [db\_public\_network\_access\_enabled](#input\_db\_public\_network\_access\_enabled) | Public network access. Server is still by identity/authentication with public access enabled | `bool` | `false` | no |
| <a name="input_db_restore_time"></a> [db\_restore\_time](#input\_db\_restore\_time) | Specifies the point in time (ISO8601 format) of the source database that will be restored to create the new database. This property is only settable for create\_mode= PointInTimeRestore databases. | `string` | `null` | no |
| <a name="input_db_server_name"></a> [db\_server\_name](#input\_db\_server\_name) | MSSQL server name | `string` | n/a | yes |
| <a name="input_db_server_sku"></a> [db\_server\_sku](#input\_db\_server\_sku) | Instance SKU, see comments above for guidance | `string` | `"GP_Fsv2_8"` | no |
| <a name="input_db_server_version"></a> [db\_server\_version](#input\_db\_server\_version) | Database server engine version for the Azure database instance. | `string` | `"12.0"` | no |
| <a name="input_db_storage_account_type"></a> [db\_storage\_account\_type](#input\_db\_storage\_account\_type) | Specifies the storage account type used to store backups for this database. Possible values are Geo, Local and Zone. The default value is Geo | `string` | `"Geo"` | no |
| <a name="input_db_timeouts"></a> [db\_timeouts](#input\_db\_timeouts) | Map of timeouts that can be adjusted when executing the module. This allows you to customize how long certain operations are allowed to take before being considered to have failed. | <pre>object({<br>    create = optional(string, null)<br>    delete = optional(string, null)<br>    update = optional(string, null)<br>  })</pre> | <pre>{<br>  "db_timeouts": {}<br>}</pre> | no |
| <a name="input_db_transparent_data_encryption_enabled"></a> [db\_transparent\_data\_encryption\_enabled](#input\_db\_transparent\_data\_encryption\_enabled) | If set to true, Transparent Data Encryption will be enabled on the database. | `bool` | `true` | no |
| <a name="input_db_username"></a> [db\_username](#input\_db\_username) | Username for the master database user. | `string` | `"mssqladmin"` | no |
| <a name="input_firewall_ip_range"></a> [firewall\_ip\_range](#input\_firewall\_ip\_range) | User will provide range of IP adrress in form of List of (objects) | <pre>list(object({<br>    name             = string<br>    start_ip_address = string<br>    end_ip_address   = string<br>  }))</pre> | `[]` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Resource Group where resource will be created. It should already exist | `string` | n/a | yes |
| <a name="input_subnet_name"></a> [subnet\_name](#input\_subnet\_name) | Specifies the name of the Subnet. | `string` | `null` | no |
| <a name="input_subnet_resource_group_name"></a> [subnet\_resource\_group\_name](#input\_subnet\_resource\_group\_name) | Specifies the name of the resource group the Virtual Network is located in. | `string` | `null` | no |
| <a name="input_subnet_virtual_network_name"></a> [subnet\_virtual\_network\_name](#input\_subnet\_virtual\_network\_name) | Specifies the name of the Virtual Network this Subnet is located within. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_db_backup_retention_period"></a> [db\_backup\_retention\_period](#output\_db\_backup\_retention\_period) | Number of Days configured to retain backups for the database instance. |
| <a name="output_db_capacity"></a> [db\_capacity](#output\_db\_capacity) | Capacity of the Database |
| <a name="output_db_collation"></a> [db\_collation](#output\_db\_collation) | The Collation configured on the database. |
| <a name="output_db_connection_policy"></a> [db\_connection\_policy](#output\_db\_connection\_policy) | The connection policy the server uses |
| <a name="output_db_create_mode"></a> [db\_create\_mode](#output\_db\_create\_mode) | The creation mode that was configured on the instance. |
| <a name="output_db_create_source_id"></a> [db\_create\_source\_id](#output\_db\_create\_source\_id) | For creation modes other than Default, the source server ID to use. |
| <a name="output_db_engine_version_actual"></a> [db\_engine\_version\_actual](#output\_db\_engine\_version\_actual) | Running engine version of the database (full version number). |
| <a name="output_db_firewall_rules"></a> [db\_firewall\_rules](#output\_db\_firewall\_rules) | Database Firewall Rules. |
| <a name="output_db_geo_backup_enabled"></a> [db\_geo\_backup\_enabled](#output\_db\_geo\_backup\_enabled) | The Geo Backup Policy configured on the database |
| <a name="output_db_hostname"></a> [db\_hostname](#output\_db\_hostname) | Database instance fully qualified domain name. |
| <a name="output_db_id"></a> [db\_id](#output\_db\_id) | Database instance ID. |
| <a name="output_db_license_type"></a> [db\_license\_type](#output\_db\_license\_type) | The LicenseType configured on the database. |
| <a name="output_db_location"></a> [db\_location](#output\_db\_location) | Database instance location. |
| <a name="output_db_min_tls_version"></a> [db\_min\_tls\_version](#output\_db\_min\_tls\_version) | The Minimum TLS Version for all SQL Database and SQL Data Warehouse databases associated with the server |
| <a name="output_db_name"></a> [db\_name](#output\_db\_name) | Name of the database that has been provisioned on the database instance. |
| <a name="output_db_password"></a> [db\_password](#output\_db\_password) | Database instance master password. |
| <a name="output_db_public_network_access_enabled"></a> [db\_public\_network\_access\_enabled](#output\_db\_public\_network\_access\_enabled) | Public network access configured |
| <a name="output_db_resource_group_name"></a> [db\_resource\_group\_name](#output\_db\_resource\_group\_name) | Resource Group where the database instance resides. |
| <a name="output_db_restore_time"></a> [db\_restore\_time](#output\_db\_restore\_time) | Specifies the point in time to restore from creation\_source\_server\_id. |
| <a name="output_db_server_name"></a> [db\_server\_name](#output\_db\_server\_name) | Database instance hostname. |
| <a name="output_db_server_sku"></a> [db\_server\_sku](#output\_db\_server\_sku) | Instance SKU in use for the database instance that was created. |
| <a name="output_db_storage_account_type"></a> [db\_storage\_account\_type](#output\_db\_storage\_account\_type) | Storage account type used to store backups |
| <a name="output_db_subnet_id"></a> [db\_subnet\_id](#output\_db\_subnet\_id) | The ID of the virtual network subnet to create the virtual network rule. |
| <a name="output_db_username"></a> [db\_username](#output\_db\_username) | Database instance master username. |
<!-- END_TF_DOCS -->