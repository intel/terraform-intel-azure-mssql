# Provision Intel Optimized Azure MSSQL server 
module "optimized-mssql-server" {
  source              = "../../" #add the github url later
  resource_group_name = "shreejan_test_mssql"
  db_server_name      = "optimized-mssql-server-2"
  db_name             = "optimized-mssql-db-2"
  db_password         = var.db_password
  tags = { owner = "shreejan.mistry@intel.com",
    duration          = "4"
    sql_public_access = "allow"
  }

  #Required parameters for adding the azuread block
  azuread_input_variables = [{
    azuread_login_username      = "shreejan.mistry@intel.com",
    azuread_object_id           = "4ad26617-a27c-4696-8168-f7265cc137d6",
    azuread_authentication_only = false
  }]

}


#terraform init  
#terraform plan -var="mssql_administrator_login_password=..." #Enter a complex password
#terraform apply -var="mssql_administrator_login_password=..." #Enter a complex password
