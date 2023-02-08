<p align="center">
  <img src="https://github.com/intel/terraform-intel-azure-mssql/blob/main/images/logo-classicblue-800px.png?raw=true" alt="Intel Logo" width="250"/>
</p>

# Intel Cloud Optimization Modules for Terraform

© Copyright 2022, Intel Corporation

## Azure MSSQL Server Module

This module can be used to deploy an Intel optimized Azure MSSQL Server instance.
Instance selection is included by default in the code.

Additional MSSQL Optimizations can based off [Intel Xeon Tunning guides](<https://www.intel.com/content/www/us/en/developer/articles/guide/sql-server-tuning-guide-for-otp-using-xeon.html#:~:text=benchmarking%20hardware%20configuration%3A-,Tuning%20SQL%20Server%20for%20OLTP%20Workload,-The%20following%20sp_configure%3E>). Scroll down to 'Tuning SQL Server for OLTP Workload' section.

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
  mssql_administrator_login_password = var.mssql_administrator_login_password
  db_public_network_access_enabled   = true  


  #Firewall Rules
  #For example: " [{name= ..., start_ip_address = ..., end_ip_address = ... },..]"
  firewall_ip_range                 =  [
                                            { 
                                              name             = "ENTER_FIREWALL_RULE_NAME,
                                              start_ip_address = "ENTER_START_IP_ADDRESS_HERE", 
                                              end_ip_address   = "ENTER_END_IP_ADDRESS_HERE" 
                                            },...
                                       ]
  
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