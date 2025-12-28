# Power Platform Environments

This resource documents Power Platform API endpoints for environment management.

## Required Permissions

**TODO:** Document required permissions for environment management.

Environment management typically requires:
- Power Platform Admin role
- Dynamics 365 Service Admin role
- Global Admin role

## Environments

### List Environments
**TODO:** Document listing all environments in tenant

```
GET https://api.bap.microsoft.com/providers/Microsoft.BusinessAppPlatform/environments?api-version=2016-11-01
```

### Get Environment
**TODO:** Document getting environment details

```
GET https://api.bap.microsoft.com/providers/Microsoft.BusinessAppPlatform/environments/{environment-id}?api-version=2016-11-01
```

### Create Environment
**TODO:** Document environment creation

**Note:** Creating environments typically requires Power Platform Admin Center or PowerShell.

### Delete Environment
**TODO:** Document environment deletion

```
DELETE https://api.bap.microsoft.com/providers/Microsoft.BusinessAppPlatform/environments/{environment-id}?api-version=2016-11-01
```

### Environment Properties
**TODO:** Document key environment properties

- displayName
- location
- environmentType (Production, Sandbox, Default, Developer)
- azureRegion
- linkedEnvironmentMetadata (Dataverse details)

## DLP Policies

### List DLP Policies
**TODO:** Document listing Data Loss Prevention policies

```
GET https://api.bap.microsoft.com/providers/Microsoft.BusinessAppPlatform/scopes/admin/apiPolicies?api-version=2016-11-01
```

### Get DLP Policy
**TODO:** Document getting DLP policy details

```
GET https://api.bap.microsoft.com/providers/Microsoft.BusinessAppPlatform/scopes/admin/apiPolicies/{policy-id}?api-version=2016-11-01
```

### Create DLP Policy
**TODO:** Document DLP policy creation

DLP policies control which connectors can be used together:
- Business data group
- Non-business data group
- Blocked group

### Update DLP Policy
**TODO:** Document DLP policy updates

### Delete DLP Policy
**TODO:** Document DLP policy deletion

## Connector Classification

### List Connectors
**TODO:** Document listing available connectors

### Get Connector Classification
**TODO:** Document getting connector classification in policy

### Update Connector Classification
**TODO:** Document moving connectors between groups

## Environment Security

### List Environment Roles
**TODO:** Document listing environment security roles

### Add User to Environment
**TODO:** Document adding users with specific roles

### Remove User from Environment
**TODO:** Document removing user access

## Capacity

### Get Environment Capacity
**TODO:** Document checking environment capacity/usage

### Dataverse Database Size
**TODO:** Document checking database size and limits
