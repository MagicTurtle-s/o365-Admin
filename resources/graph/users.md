# Entra ID Users and Groups

This resource documents Graph API endpoints for user and directory management.

## Required Permissions

| Permission | Type | Description |
|------------|------|-------------|
| User.Read.All | Application | Read all users |
| User.ReadWrite.All | Application | Create/update users |
| Directory.Read.All | Application | Read directory objects |
| Directory.ReadWrite.All | Application | Manage directory objects |
| Group.Read.All | Application | Read all groups |
| Group.ReadWrite.All | Application | Manage groups |
| RoleManagement.ReadWrite.Directory | Application | Manage directory roles |

## Users

### List Users
**TODO:** Document user listing with filtering

```
GET /users
GET /users?$filter=department eq 'Sales'
GET /users?$select=displayName,mail,department
```

### Get User
**TODO:** Document getting user details

```
GET /users/{user-id}
GET /users/{user-principal-name}
```

### Create User
**TODO:** Document user creation with required properties

```
POST /users
Content-Type: application/json

{
  "accountEnabled": true,
  "displayName": "John Doe",
  "mailNickname": "johnd",
  "userPrincipalName": "johnd@contoso.com",
  "passwordProfile": {
    "forceChangePasswordNextSignIn": true,
    "password": "TempPassword123!"
  }
}
```

### Update User
**TODO:** Document user updates

```
PATCH /users/{user-id}
Content-Type: application/json

{
  "displayName": "John Smith",
  "department": "Engineering"
}
```

### Delete User
**TODO:** Document user deletion

```
DELETE /users/{user-id}
```

### Get Manager
**TODO:** Document getting user's manager

```
GET /users/{user-id}/manager
```

### Set Manager
**TODO:** Document setting user's manager

```
PUT /users/{user-id}/manager/$ref
Content-Type: application/json

{
  "@odata.id": "https://graph.microsoft.com/v1.0/users/{manager-id}"
}
```

### Get Direct Reports
**TODO:** Document getting direct reports

```
GET /users/{user-id}/directReports
```

## Groups

### List Groups
**TODO:** Document group listing

```
GET /groups
GET /groups?$filter=groupTypes/any(c:c eq 'Unified')
```

### Get Group
**TODO:** Document getting group details

```
GET /groups/{group-id}
```

### Create Microsoft 365 Group
**TODO:** Document M365 group creation

```
POST /groups
Content-Type: application/json

{
  "displayName": "Marketing Team",
  "mailEnabled": true,
  "mailNickname": "marketing",
  "securityEnabled": false,
  "groupTypes": ["Unified"]
}
```

### Create Security Group
**TODO:** Document security group creation

```
POST /groups
Content-Type: application/json

{
  "displayName": "Finance Admins",
  "mailEnabled": false,
  "mailNickname": "financeadmins",
  "securityEnabled": true
}
```

### Update Group
**TODO:** Document group updates

```
PATCH /groups/{group-id}
```

### Delete Group
**TODO:** Document group deletion

```
DELETE /groups/{group-id}
```

### List Group Members
**TODO:** Document listing group members

```
GET /groups/{group-id}/members
```

### Add Group Member
**TODO:** Document adding members

```
POST /groups/{group-id}/members/$ref
Content-Type: application/json

{
  "@odata.id": "https://graph.microsoft.com/v1.0/users/{user-id}"
}
```

### Remove Group Member
**TODO:** Document removing members

```
DELETE /groups/{group-id}/members/{user-id}/$ref
```

### List Group Owners
**TODO:** Document listing group owners

```
GET /groups/{group-id}/owners
```

### Add Group Owner
**TODO:** Document adding owners

```
POST /groups/{group-id}/owners/$ref
```

## Directory Roles

### List Directory Roles
**TODO:** Document listing available roles

```
GET /directoryRoles
```

### List Role Templates
**TODO:** Document role templates (built-in roles)

```
GET /directoryRoleTemplates
```

### Activate Role
**TODO:** Document role activation

```
POST /directoryRoles
Content-Type: application/json

{
  "roleTemplateId": "{role-template-id}"
}
```

### Assign Role to User
**TODO:** Document role assignment

```
POST /directoryRoles/{role-id}/members/$ref
Content-Type: application/json

{
  "@odata.id": "https://graph.microsoft.com/v1.0/users/{user-id}"
}
```

### List Role Members
**TODO:** Document listing role members

```
GET /directoryRoles/{role-id}/members
```

### Remove Role from User
**TODO:** Document role removal

```
DELETE /directoryRoles/{role-id}/members/{user-id}/$ref
```
