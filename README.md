## Intel Cloud Optimization Module for Azure MSSQL 

This module can be used to deploy an Intel optimized Azure MSSQL Server instance. 

Instance selection and configuration are included by default in the code. 

Xeon Tunning guide

<https://www.intel.com/content/www/us/en/developer/articles/guide/open-source-database-tuning-guide-on-xeon-systems.html>



## Usage

See examples folder for code ./examples/main.tf



By default, you will only have to pass three variables

```hcl
resource_group_name 
mssql_server_name  
mssql_db_name 
mssql_administrator_login_password 

```


Example of main.tf
```hcl
# main.tf

variable "mssql_administrator_login_password" {
  description = "The admin password"
}

# Provision Intel Optimized Azure MSSQL server 
module "optimized-mssql-server" {
  source                             = "github.com/intel/terraform-intel-azure-mssql"
  resource_group_name                = "ENTER_RG_NAME_HERE"
  mssql_server_name                  = "ENTER_MSSQL_SERVER_NAME_HERE"
  mssql_db_name                      = "ENTER_MSSQL_DB_NAME_HERE"
  mssql_administrator_login_password = var.mssql_administrator_login_password
  tags                               = {"ENTER_TAG_KEY" = "ENTER_TAG_VALUE", ... }                      #Can add tags as key-value pair
  
}

# Provision Intel Optimized Azure MSSQL server with Azure AD block, firewall_ip_range, and virtual network rule.
module "optimized-mssql-server" {
  source                             = "github.com/intel/terraform-intel-azure-mssql"
  resource_group_name                = "ENTER_RG_NAME_HERE"
  mssql_server_name                  = "ENTER_MSSQL_SERVER_NAME_HERE"
  mssql_db_name                      = "ENTER_MSSQL_DB_NAME_HERE"
  mssql_administrator_login_password = var.mssql_administrator_login_password
  tags                               = {"ENTER_TAG_KEY" = "ENTER_TAG_VALUE", ... }                      #Can add tags as key-value pair


  #azuread block
  azuread_input_variables = [{
    azuread_login_username = "ENTER_AZUREAD_LOGIN_USERNAME_HERE",
    azuread_object_id = "ENTER_AZUREAD_OBJECT_ID_HERE",
    azuread_authentication_only = ENTER_AZUREAD_AUTHENTICATION_ONLY_HERE                                # type = boolean
  }]

  #firewall_ip_ranges
  #For example: " [{start_ip_address = ..., end_ip_address = ... },..]"
  firewall_ip_range                 =  [
                                            {start_ip_address = "ENTER_START_IP_ADDRESS_HERE", end_ip_address = "ENTER_END_IP_ADDRESS_HERE" },...
                                       ]

  #Virtual Network rule requires a virtual network within the same resource group as MSSQL Server and DB
  subnet_name                       = "ENTER_SUBNET_NAME_HERE"
  subnet_virtual_network_name       = "ENTER_SUBNET_VIRTUAL_NETWORK_NAME_HERE"
  subnet_resource_group_name        = "ENTER_RG_NAME_HERE"

}


```
Run terraform
```
terraform init  
terraform plan -var="mssql_administrator_login_password=..." #Enter a complex password
terraform apply -var="mssql_administrator_login_password=..." #Enter a complex password

```
## Considerations

This module further provides the ability to add firewall_ip_range, virtual network rule and azuread_administration resource block (Usage Example provided above). For information : https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_server