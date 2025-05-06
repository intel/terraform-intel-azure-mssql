# Provision Intel Optimized Azure MSSQL server 
module "optimized-mssql-server" {
  source              = "intel/azure-mssql/intel"
  resource_group_name = "<your_resource_group> "
  db_server_name      = "<your_dbservername>"
  db_name             = "<your_dbname>"
  db_password         = var.db_password
  tags = {
    owner    = "owner@intel.com",
    duration = "3"
  }
}

#terraform init  
#terraform plan -var="mssql_administrator_login_password=..." #Enter a complex password
#terraform apply -var="mssql_administrator_login_password=..." #Enter a complex password
