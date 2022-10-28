variable "mssql_administrator_login_password" {
  description = "The admin password"
}


# Provision Intel Optimized Azure MSSQL server 
module "optimized-mssql-server" {
  source                             = "../"              #add the github url later
  resource_group_name                = "shreejan_test_mssql"
  mssql_server_name                  = "optimized-mssql-server"
  mssql_db_name                      = "optimized-mssql-db"
  mssql_administrator_login_password = var.mssql_administrator_login_password
#   public_network_access_enabled      = true            #have to remove this line (just for testing)
  tags                               = {"tagsadded" = "userAddTest",
                                        "sql_public_access" = "allow"
                                       }
  firewall_ip_range                 =  [
                                            {start_ip_address = "192.55.54.53",end_ip_address = "192.55.54.53" },
                                            {start_ip_address = "250.151.84.219",end_ip_address = "250.151.84.219" },
                                            {start_ip_address = "79.4.142.148",end_ip_address = "79.4.142.148"}
                                       ]
  subnet_name                       = "default"
  subnet_virtual_network_name       = "mssql_vnet_test"
  subnet_resource_group_name        = "shreejan_test_mssql"

  azuread_login_username = "shreejan.mistry@intel.com"
  azuread_object_id = "4ad26617-a27c-4696-8168-f7265cc137d6"


}

#Consumption Example
#terraform init  
#terraform plan -var="mssql_administrator_login_password=..." #Enter a complex password
#terraform apply -var="mssql_administrator_login_password=..." #Enter a complex password
