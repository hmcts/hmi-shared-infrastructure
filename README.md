# hmi-apim-infrastructure
Repository for deploying support infrastructure for HMI APIM



### Changing password on pact-broker database:
If you need to change pact-broker database password:
- navigate to Azure Database for PostgreSQL server `hmi-pact-broker-*env*` and click "Reset password"
- update the secret `pact-db-password` in Key Vault `hmi-sharedinfra-kv-*env*`

IMPORTANT! - if you don't update the keyvault secret, AKS cluster won't be able to read it and will fail to start Pact on the pod.