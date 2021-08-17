# hmi-apim-infrastructure
Repository for deploying support infrastructure for HMI APIM


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

### Changing password on pact-broker database:
~~If you need to change pact-broker database password:~~

~~- navigate to Azure Database for PostgreSQL server `hmi-pact-broker-*env*` and click "Reset password"~~

~~- update the secret `pact-db-password` in Key Vault `hmi-sharedinfra-kv-*env*`~~

~~IMPORTANT! - if you don't update the keyvault secret, AKS cluster won't be able to read it and will fail to start Pact on the pod.~~

The password is now dynamically created by Terraform.
The flow is to run the Shared Services Terraform, which creates the password and puts it into Key Vault.
Then run the Shared Infrastructure Terraform, which will fetch the password and update PostgreSQL. (Can also just run this to update the password as is currently in Key Vault)
