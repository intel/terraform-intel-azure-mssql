# Provision Intel Optimized Azure MSSQL server 
module "optimized-mssql-server" {
  source              = "intel/azure-mssql/intel"
  resource_group_name = "shreejan_test_mssql"
  db_server_name      = "optimized-mssql-server-2"
  db_name             = "optimized-mssql-db-2"
  db_password         = var.db_password
  tags = { owner = "owner@intel.com",
    duration          = "4"
    sql_public_access = "allow"
  }

  #Required parameters for adding the azuread block
  azuread_input_variables = [{
    azuread_login_username      = "module.username@company.com",
    azuread_object_id           = "0xxxxxxx-1aaa-2bbb-3ccc-4ddddddddddd",
    azuread_authentication_only = false
  }]

}


#terraform init  
#terraform plan -var="mssql_administrator_login_password=..." #Enter a complex password
#terraform apply -var="mssql_administrator_login_password=..." #Enter a complex password
