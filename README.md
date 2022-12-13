<p align="center">
  <img src="https://github.com/intel/terraform-intel-azure-postgresql-flexible-server/blob/main/images/logo-classicblue-800px.png?raw=true" alt="Intel Logo" width="250"/>
</p>

# Intel Cloud Optimization Modules for Terraform

© Copyright 2022, Intel Corporation

## Azure MSSQL Server Module

This module can be used to deploy an Intel optimized Azure MSSQL Server instance.
Instance selection is included by default in the code.

The MSSQL Optimizations were based off [Intel Xeon Tunning guides](<https://www.intel.com/content/www/us/en/developer/articles/guide/open-source-database-tuning-guide-on-xeon-systems.html>)

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
  source                             = "github.com/intel/terraform-intel-azure-mssql"
  resource_group_name                = "ENTER_RG_NAME_HERE"
  mssql_server_name                  = "ENTER_MSSQL_SERVER_NAME_HERE"
  mssql_db_name                      = "ENTER_MSSQL_DB_NAME_HERE"
  mssql_administrator_login_password = var.mssql_administrator_login_password
  
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
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~>3.26.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~>3.26.0 |

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
| <a name="input_azuread_input_variables"></a> [azuread\_input\_variables](#input\_azuread\_input\_variables) | The values for azuread\_administrator block | <pre>list(object({<br>    azuread_login_username = string<br>    azuread_object_id      = string <br>    azuread_authentication_only = bool<br>  }))</pre> | `[]` | no |
| <a name="input_azuread_login_username"></a> [azuread\_login\_username](#input\_azuread\_login\_username) | The login username of the Azure AD Administrator of this SQL Server. | `string` | n/a | yes |
| <a name="input_azuread_object_id"></a> [azuread\_object\_id](#input\_azuread\_object\_id) | The object id of the Azure AD Administrator of this SQL Server. | `string` | n/a | yes |
| <a name="input_connection_policy"></a> [connection\_policy](#input\_connection\_policy) | The connection policy the server will use. Possible values are Default, Proxy, and Redirect. | `string` | `"Default"` | no |
| <a name="input_create_mode"></a> [create\_mode](#input\_create\_mode) | The create mode of the database. Possible values are Copy, Default, OnlineSecondary, PointInTimeRestore, Recovery, Restore, RestoreExternalBackup, RestoreExternalBackupSecondary, RestoreLongTermRetentionBackup and Secondary. Mutually exclusive with import. | `string` | `"Default"` | no |
| <a name="input_firewall_ip_range"></a> [firewall\_ip\_range](#input\_firewall\_ip\_range) | User will provide range of IP adrress in form of List of (objects) | <pre>list(object({<br>    start_ip_address  = string<br>    end_ip_address    = string<br>  }))</pre> | `[]` | no |
| <a name="input_license_type"></a> [license\_type](#input\_license\_type) | Specifies the license type applied to this database. Possible values are LicenseIncluded and BasePrice. | `string` | `"LicenseIncluded"` | no |
| <a name="input_max_size_gb"></a> [max\_size\_gb](#input\_max\_size\_gb) | The max size of the database in gigabytes. | `number` | `20` | no |
| <a name="input_mssql_administrator_login"></a> [mssql\_administrator\_login](#input\_mssql\_administrator\_login) | MSSQL server name admin username | `string` | `"mssqladmin"` | no |
| <a name="input_mssql_administrator_login_password"></a> [mssql\_administrator\_login\_password](#input\_mssql\_administrator\_login\_password) | MSSQL server name admin password | `string` | n/a | yes |
| <a name="input_mssql_db_name"></a> [mssql\_db\_name](#input\_mssql\_db\_name) | MSSQL database name | `string` | n/a | yes |
| <a name="input_mssql_server_name"></a> [mssql\_server\_name](#input\_mssql\_server\_name) | MSSQL server name | `string` | n/a | yes |
| <a name="input_mssql_server_sku"></a> [mssql\_server\_sku](#input\_mssql\_server\_sku) | Instance SKU, see comments above for guidance | `string` | `"GP_Fsv2_8"` | no |
| <a name="input_mysql_min_tls_version"></a> [mysql\_min\_tls\_version](#input\_mysql\_min\_tls\_version) | MySQL minimum TLS Version | `string` | `"1.2"` | no |
| <a name="input_mysql_version"></a> [mysql\_version](#input\_mysql\_version) | MySQL Version | `string` | `"12.0"` | no |
| <a name="input_public_network_access_enabled"></a> [public\_network\_access\_enabled](#input\_public\_network\_access\_enabled) | Public network access. Server is still by identity/authentication with public access enabled | `bool` | `true` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Resource Group where resource will be created. It should already exist | `string` | n/a | yes |
| <a name="input_storage_account_type"></a> [storage\_account\_type](#input\_storage\_account\_type) | Specifies the storage account type used to store backups for this database. Possible values are Geo, Local and Zone. The default value is Geo | `string` | `"Geo"` | no |
| <a name="input_subnet_name"></a> [subnet\_name](#input\_subnet\_name) | Specifies the name of the Subnet. | `string` | `null` | no |
| <a name="input_subnet_resource_group_name"></a> [subnet\_resource\_group\_name](#input\_subnet\_resource\_group\_name) | Specifies the name of the resource group the Virtual Network is located in. | `string` | `null` | no |
| <a name="input_subnet_virtual_network_name"></a> [subnet\_virtual\_network\_name](#input\_subnet\_virtual\_network\_name) | Specifies the name of the Virtual Network this Subnet is located within. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags | `map(string)` | `{}` | no |
| <a name="input_transparent_data_encryption_enabled"></a> [transparent\_data\_encryption\_enabled](#input\_transparent\_data\_encryption\_enabled) | If set to true, Transparent Data Encryption will be enabled on the database. | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_fqdn"></a> [fqdn](#output\_fqdn) | n/a |
| <a name="output_id"></a> [id](#output\_id) | n/a |
| <a name="output_name"></a> [name](#output\_name) | n/a |
<!-- END_TF_DOCS -->