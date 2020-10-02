# hmi-apim-infrastructure
Repository for deploying support infrastructure for HMI APIM



### Changing password on pact-broker database:
Password for the database is stored as a secret `pact-db-password` in in Key Vault `hmi-sharedservices-kv-*env*` in Resource Group `hmi-sharedservices-*env*-rg`

If you need to change pact-broker database password:
- navigate to Azure Database for PostgreSQL server `hmi-pact-broker-*env*` and click "Reset password"
- update the secret `pact-db-password` in Key Vault corresponding with environment you're updating.

IMPORTANT! - if you don't update the keyvault secret, AKS cluster won't be able to read it and will fail to start Pact on the pod.