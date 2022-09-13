resource "azurerm_resource_group" "funcdeploy" {
  name     = "rg-functionapp"
  location = "UK West"
}

resource "azurerm_storage_account" "funcdeploy" {
  name                     = "larastorageaccount"
  resource_group_name      = azurerm_resource_group.funcdeploy.name
  location                 = azurerm_resource_group.funcdeploy.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "funcdeploy" {
  name                  = "larascontents"
  storage_account_name  = azurerm_storage_account.funcdeploy.name
  container_access_type = "private"
}

resource "azurerm_application_insights" "funcdeploy" {
  name                = "funcapp-appinsights-001"
  location            = azurerm_resource_group.funcdeploy.location
  resource_group_name = azurerm_resource_group.funcdeploy.name
  application_type    = "web"
  tags = {
    "Monitoring" = "functionApp"
  }
}

resource "azurerm_app_service_plan" "funcdeploy" {
  name                = "functions-consumption-asp"
  location            = azurerm_resource_group.funcdeploy.location
  resource_group_name = azurerm_resource_group.funcdeploy.name
  kind                = "FunctionApp"
  reserved            = true

  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}

resource "azurerm_function_app" "funcdeploy" {
  name                       = "larasfunctionapp"
  location                   = azurerm_resource_group.funcdeploy.location
  resource_group_name        = azurerm_resource_group.funcdeploy.name
  app_service_plan_id        = azurerm_app_service_plan.funcdeploy.id
  storage_account_name       = azurerm_storage_account.funcdeploy.name
  storage_account_access_key = azurerm_storage_account.funcdeploy.primary_access_key
  https_only                 = true
  version                    =  "~3"
  os_type                    = "linux"
  app_settings = {
     "WEBSITE_RUN_FROM_PACKAGE" = "1"
     "FUNCTIONS_WORKER_RUNTIME" = "python"
     "APPINSIGHTS_INSTRUMENTATIONKEY" = "${azurerm_application_insights.funcdeploy.instrumentation_key}"
  }
  site_config {
        linux_fx_version= "Python|3.8"
        ftps_state = "Disabled"
    }
  identity {
    type = "SystemAssigned"
  }
}