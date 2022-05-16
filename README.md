# hmi-apim-infrastructure
`terraform\deployments\sharedinfra` is the path for the Shared APIM Infrastructure Terraform.

### Monitoring and Alerting:
If you need to update web test endpoint, add or modify `var.ping_tests` in /environments/*env*.tfvars:

```
ping_tests = [
  {
    pingTestName = "webcheck-name"
    pingTestURL  = "https://webcheck-url"
    pingText     = "Status: UP" # optional
  }
]
```

To change action group email, modify `var.support_email` in `/environments/shared.tfvars`

### Adding External Access to Key Vault
To give access to the Key Vault the client must have an Azure Managed Identity within the CJS Common Tenant.
This will be what we use to grant the MI GET access on the Key Vault.

They will then need to provide use with the `Name` and `Client ID` of the resource.

We can then add these per environment in the Terraform.

1. Edit the correct environment `tfvars` in the `environments` folder.
2. update or addd the variable `client_kv_mi_access`. <br/>
A single entry should look like: </br>
```terraform
client_kv_mi_access = {
  "HMI" = {
    name  = "hmi-mi-sbox"
    value = "7ac06558-a513-4259-b094-fef5d4de526b"
  }
}
```

### Changing password on pact-broker database:
~~If you need to change pact-broker database password:~~

~~- navigate to Azure Database for PostgreSQL server `hmi-pact-broker-*env*` and click "Reset password"~~

~~- update the secret `pact-db-password` in Key Vault `hmi-sharedinfra-kv-*env*`~~

~~IMPORTANT! - if you don't update the keyvault secret, AKS cluster won't be able to read it and will fail to start Pact on the pod.~~

The password is now dynamically created by Terraform.
The flow is to run the Shared Services Terraform, which creates the password and puts it into Key Vault.
Then run the Shared Infrastructure Terraform, which will fetch the password and update PostgreSQL. (Can also just run this to update the password as is currently in Key Vault)

# hmi-shared-services
`terraform\deployments\sharedservices` is the path for the Shared Services Terraform.