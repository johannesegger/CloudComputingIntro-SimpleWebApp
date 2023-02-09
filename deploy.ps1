az group create --location westeurope --resource-group rgSimpleWebApp
az deployment group create --resource-group rgSimpleWebApp --template-file .\app.bicep
