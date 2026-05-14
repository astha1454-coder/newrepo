resource "azurerm_resource_group" "astharg" {
  name     = "astha--rg"
  location = "Central India"
}

resource "azurerm_mssql_server" "mysqlserver" {
  name                         = "mysqlserver"
  resource_group_name          = azurerm_resource_group.astharg.name
  location                     = "Central India"
  version                      = "12.0"
  administrator_login          = "Astha@123"
  administrator_login_password = "nikki123"
}

resource "azurerm_storage_account" "asthast" {
  name                     = "asthast"
  resource_group_name      = azurerm_resource_group.astharg.name
  location                 = azurerm_resource_group.astharg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_mssql_database" "mysqldatabase" {
  name      = "mysqldatabase"
  server_id = azurerm_mssql_server.mysqlserver.id
  sku_name  = "Basic"
}

resource "azurerm_mssql_database_extended_auditing_policy" "audit" {
  database_id = azurerm_mssql_database.mysqldatabase.id

  storage_endpoint           = azurerm_storage_account.asthast.primary_blob_endpoint
  storage_account_access_key = azurerm_storage_account.asthast.primary_access_key

  retention_in_days = 6
}
