# Power Automate Flows

This resource documents Power Platform API endpoints for flow management.

## Required Permissions

**TODO:** Document required permissions for flow management.

Power Automate uses different permission models:
- Maker permissions (create/edit own flows)
- Admin permissions (manage all flows in environment)
- Flow-specific permissions (run, edit, own)

## Flows

### List Flows
**TODO:** Document listing flows in an environment

```
GET https://api.flow.microsoft.com/providers/Microsoft.ProcessSimple/environments/{environment-id}/flows?api-version=2016-11-01
```

### Get Flow
**TODO:** Document getting flow details

```
GET https://api.flow.microsoft.com/providers/Microsoft.ProcessSimple/environments/{environment-id}/flows/{flow-id}?api-version=2016-11-01
```

### Enable Flow
**TODO:** Document enabling a flow

```
POST https://api.flow.microsoft.com/providers/Microsoft.ProcessSimple/environments/{environment-id}/flows/{flow-id}/start?api-version=2016-11-01
```

### Disable Flow
**TODO:** Document disabling a flow

```
POST https://api.flow.microsoft.com/providers/Microsoft.ProcessSimple/environments/{environment-id}/flows/{flow-id}/stop?api-version=2016-11-01
```

### Delete Flow
**TODO:** Document flow deletion

```
DELETE https://api.flow.microsoft.com/providers/Microsoft.ProcessSimple/environments/{environment-id}/flows/{flow-id}?api-version=2016-11-01
```

## Flow Runs

### List Flow Runs
**TODO:** Document listing flow run history

```
GET https://api.flow.microsoft.com/providers/Microsoft.ProcessSimple/environments/{environment-id}/flows/{flow-id}/runs?api-version=2016-11-01
```

### Get Flow Run
**TODO:** Document getting run details

```
GET https://api.flow.microsoft.com/providers/Microsoft.ProcessSimple/environments/{environment-id}/flows/{flow-id}/runs/{run-id}?api-version=2016-11-01
```

### Resubmit Failed Run
**TODO:** Document resubmitting failed runs

```
POST https://api.flow.microsoft.com/providers/Microsoft.ProcessSimple/environments/{environment-id}/flows/{flow-id}/triggers/{trigger-name}/histories/{run-id}/resubmit?api-version=2016-11-01
```

### Cancel Running Flow
**TODO:** Document canceling in-progress runs

```
POST https://api.flow.microsoft.com/providers/Microsoft.ProcessSimple/environments/{environment-id}/flows/{flow-id}/runs/{run-id}/cancel?api-version=2016-11-01
```

## Flow Connections

### List Connections
**TODO:** Document listing connections used by flows

```
GET https://api.flow.microsoft.com/providers/Microsoft.ProcessSimple/environments/{environment-id}/connections?api-version=2016-11-01
```

### Get Connection
**TODO:** Document getting connection details

```
GET https://api.flow.microsoft.com/providers/Microsoft.ProcessSimple/environments/{environment-id}/connections/{connection-id}?api-version=2016-11-01
```

### Delete Connection
**TODO:** Document connection deletion

```
DELETE https://api.flow.microsoft.com/providers/Microsoft.ProcessSimple/environments/{environment-id}/connections/{connection-id}?api-version=2016-11-01
```

## Flow Definition JSON Structure

**TODO:** Document flow definition structure

Flow definitions are stored as JSON with the following high-level structure:

```json
{
  "properties": {
    "definition": {
      "$schema": "https://schema.management.azure.com/providers/Microsoft.Logic/schemas/2016-06-01/workflowdefinition.json#",
      "actions": { ... },
      "triggers": { ... },
      "outputs": { ... }
    },
    "connectionReferences": { ... },
    "parameters": { ... }
  }
}
```

### Triggers
**TODO:** Document common trigger types

### Actions
**TODO:** Document common action types

### Expressions
**TODO:** Document expression syntax

## Flow Permissions

### List Flow Permissions
**TODO:** Document listing who has access to a flow

### Share Flow
**TODO:** Document sharing flows with users

### Remove Flow Access
**TODO:** Document removing user access
