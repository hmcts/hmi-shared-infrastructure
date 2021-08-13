terraform {
  backend "azurerm" {
    resource_group_name  = "hmi-sharedservices-state-sbox-rg"
    storage_account_name = "hmissinfrasboxsa"
    container_name       = "hmissterraform"
    key                  = "hmishared/sbox.tfstate"
    access_key           = "ZMj9bZ7acxKq392upsOFtHvTslVy4o+EoH/FM0OJf10kNXRvQRc3oFri7hIA0W4KmhUxvBhs2I7IEvKosleuTQ=="
    subscription_id      = "a8140a9e-f1b0-481f-a4de-09e2ee23f7ab"
  }
}
