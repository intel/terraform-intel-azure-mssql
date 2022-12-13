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