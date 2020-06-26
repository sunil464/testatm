
provider "azurerm" {

  subscription_id = "ae3cae0d-6699-4593-bb04-de13fdc54b89"
  client_id       = "2e172af4-3511-4839-b7cf-985488197207"
  client_secret   = "q8YJWNI3k.v2nF~A~-wDZDTcB3453~x.~_"
  tenant_id       = "f47cf29e-63b5-44ae-ab92-bf0de6383022"
  version         = "=2.0.0"
  features {}
}

data "azurerm_subscription" "current" {
}

resource "random_id" "main" {
  keepers = {
    azi_id = 1
  }
  byte_length = 8
}

resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_traffic_manager_profile" "gx-atm" {
  name                   = var.traffic_manager_name
  resource_group_name    = azurerm_resource_group.main.name
  traffic_routing_method = "Weighted"
  dns_config {
    relative_name = random_id.main.hex
    ttl           = 100
  }
  monitor_config {
    protocol                     = "http"
    port                         = 80
    path                         = "/"
    interval_in_seconds          = 30
    timeout_in_seconds           = 9
    tolerated_number_of_failures = 3
  }
  tags = {
    environment = "POC"
  }
}

resource "azurerm_traffic_manager_endpoint" "ep1" {
  name                = "gx-poc-ep1"
  resource_group_name = azurerm_resource_group.main.name
  profile_name        = azurerm_traffic_manager_profile.gx-atm.name
  target              = var.atm_ep1
  type                = "externalEndpoints"
  weight              = "100"
}

resource "azurerm_traffic_manager_endpoint" "ep2" {
  name                = "gx-poc-ep2"
  resource_group_name = azurerm_resource_group.main.name
  profile_name        = azurerm_traffic_manager_profile.gx-atm.name
  target              = var.atm_ep2
  type                = "externalEndpoints"
  weight              = "200"
}


# resource "azurerm_monitor_action_group" "gx-ag" {
#   name                = "HighCPUutilization"
#   resource_group_name = azurerm_resource_group.main.name
#   short_name          = "HighCPU"
#   email_receiver {
#     name          = "Lokesh"
#     email_address = "ljangir@galaxe.com"
#   }
# }
