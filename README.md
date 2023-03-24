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


### Adding ADO Variables into Key Vault
This is directions on how to get Azure DevOps variable in the libraries into the HMI Key Vaults.

1. Add the variable to the ADO library with the prefix `tf_secret_` for example `tf_secret_my-secret-name`
2. Edit the file `pipeline\steps\tf-SharedInfra-variables.yaml`
3. Add onto the parameter `libarySecrets` another set of name/value objects.<br/>
The `secName` needs to be the Key Vault serect name plus the prefix `tf_secret_`.<br/>
The `secValue` needs to be the ADO serect name with the prefix `tf_secret_`.<br/>
example:
```
- secName: "tf_secret_key-vault-secret-name"
  secValue: "$(tf_secret_ado-variable-name)"
```