# SharePoint Sites, Drives, and Lists

This resource documents Graph API endpoints for SharePoint Online operations.

## Required Permissions

| Permission | Type | Description |
|------------|------|-------------|
| Sites.Read.All | Application | Read sites and lists |
| Sites.ReadWrite.All | Application | Create/modify content in sites |
| Sites.Manage.All | Application | Create/delete lists, manage permissions |
| Sites.FullControl.All | Application | Full admin access (rarely needed) |

**Note:** Use the minimum permission level required for your operation.

## Sites

### Get Root Site
```
GET /sites/root
```

### Get Site by SharePoint URL
```
GET /sites/{hostname}:/{site-path}
```

**Example:**
```
GET /sites/contoso.sharepoint.com:/sites/IT
```

### Get Site by ID
```
GET /sites/{site-id}
```

### Search Sites
```
GET /sites?search={query}
```

**Example:**
```
GET /sites?search=Marketing
```

### Get Subsites
```
GET /sites/{site-id}/sites
```

## Document Libraries (Drives)

### List All Document Libraries in a Site
```
GET /sites/{site-id}/drives
```

### Get Default Document Library
```
GET /sites/{site-id}/drive
```

### Get Specific Drive
```
GET /drives/{drive-id}
```

### Get Drive Root Contents
```
GET /sites/{site-id}/drive/root/children
```
or
```
GET /drives/{drive-id}/root/children
```

### Get Folder Contents by Path
```
GET /drives/{drive-id}/root:/{folder-path}:/children
```

**Example:**
```
GET /drives/{drive-id}/root:/Documents/Reports:/children
```

### Get Item by Path
```
GET /drives/{drive-id}/root:/{path}
```

**Example:**
```
GET /drives/{drive-id}/root:/Documents/report.docx
```

## Folders

### Create Folder at Root
```
POST /drives/{drive-id}/root/children
Content-Type: application/json

{
  "name": "New Folder",
  "folder": {},
  "@microsoft.graph.conflictBehavior": "rename"
}
```

### Create Folder at Path
```
POST /drives/{drive-id}/root:/{parent-path}:/children
Content-Type: application/json

{
  "name": "New Folder",
  "folder": {}
}
```

**Example:**
```
POST /drives/{drive-id}/root:/Documents:/children
Content-Type: application/json

{
  "name": "Reports",
  "folder": {}
}
```

### Conflict Behavior Options
- `rename` - Rename if exists
- `fail` - Fail if exists (default)
- `replace` - Replace if exists

## Files

### Upload Small File (<4MB)
```
PUT /drives/{drive-id}/root:/{path}/{filename}:/content
Content-Type: application/octet-stream

[file contents as binary]
```

**Example:**
```
PUT /drives/{drive-id}/root:/Documents/report.docx:/content
```

### Upload Large File (>4MB) - Upload Session
**Step 1: Create upload session**
```
POST /drives/{drive-id}/root:/{path}/{filename}:/createUploadSession
Content-Type: application/json

{
  "item": {
    "@microsoft.graph.conflictBehavior": "rename"
  }
}
```

**Response:**
```json
{
  "uploadUrl": "https://...",
  "expirationDateTime": "2024-01-02T00:00:00Z"
}
```

**Step 2: Upload chunks**
```
PUT {uploadUrl}
Content-Length: {chunk-size}
Content-Range: bytes {start}-{end}/{total}

[chunk bytes]
```

**Chunk size:** Use 5-10 MB chunks (must be multiple of 320 KB).

### Download File
```
GET /drives/{drive-id}/items/{item-id}/content
```
or
```
GET /drives/{drive-id}/root:/{path}:/content
```

### Copy File
```
POST /drives/{drive-id}/items/{item-id}/copy
Content-Type: application/json

{
  "parentReference": {
    "driveId": "{target-drive-id}",
    "id": "{target-folder-id}"
  },
  "name": "new-filename.docx"
}
```

### Move File
```
PATCH /drives/{drive-id}/items/{item-id}
Content-Type: application/json

{
  "parentReference": {
    "id": "{target-folder-id}"
  }
}
```

### Delete File/Folder
```
DELETE /drives/{drive-id}/items/{item-id}
```

## Lists

### Create Document Library
```
POST /sites/{site-id}/lists
Content-Type: application/json

{
  "displayName": "Project Documents",
  "list": {
    "template": "documentLibrary"
  }
}
```

### Create Custom List
```
POST /sites/{site-id}/lists
Content-Type: application/json

{
  "displayName": "Project Tracker",
  "list": {
    "template": "genericList"
  }
}
```

### Get All Lists
```
GET /sites/{site-id}/lists
```

### Get List by ID
```
GET /sites/{site-id}/lists/{list-id}
```

### Get List by Name
```
GET /sites/{site-id}/lists/{list-title}
```

## List Columns

### Get List Columns
```
GET /sites/{site-id}/lists/{list-id}/columns
```

### Add Text Column
```
POST /sites/{site-id}/lists/{list-id}/columns
Content-Type: application/json

{
  "name": "ProjectCode",
  "text": {}
}
```

### Add Choice Column
```
POST /sites/{site-id}/lists/{list-id}/columns
Content-Type: application/json

{
  "name": "Status",
  "choice": {
    "allowTextEntry": false,
    "choices": ["Not Started", "In Progress", "Completed"],
    "displayAs": "dropDownMenu"
  }
}
```

### Add Number Column
```
POST /sites/{site-id}/lists/{list-id}/columns
Content-Type: application/json

{
  "name": "Budget",
  "number": {
    "decimalPlaces": "two"
  }
}
```

### Add DateTime Column
```
POST /sites/{site-id}/lists/{list-id}/columns
Content-Type: application/json

{
  "name": "DueDate",
  "dateTime": {
    "format": "dateOnly"
  }
}
```

### Add Person Column
```
POST /sites/{site-id}/lists/{list-id}/columns
Content-Type: application/json

{
  "name": "AssignedTo",
  "personOrGroup": {
    "allowMultipleSelection": false,
    "chooseFromType": "peopleOnly"
  }
}
```

## List Items

### Get All Items
```
GET /sites/{site-id}/lists/{list-id}/items?expand=fields
```

### Get Item by ID
```
GET /sites/{site-id}/lists/{list-id}/items/{item-id}?expand=fields
```

### Create Item
```
POST /sites/{site-id}/lists/{list-id}/items
Content-Type: application/json

{
  "fields": {
    "Title": "New Project",
    "ProjectCode": "PRJ-001",
    "Status": "Not Started",
    "DueDate": "2024-12-31"
  }
}
```

### Update Item
```
PATCH /sites/{site-id}/lists/{list-id}/items/{item-id}/fields
Content-Type: application/json

{
  "Status": "In Progress"
}
```

### Delete Item
```
DELETE /sites/{site-id}/lists/{list-id}/items/{item-id}
```

### Filter Items
```
GET /sites/{site-id}/lists/{list-id}/items?$filter=fields/Status eq 'In Progress'&expand=fields
```

## Permissions

### Get Item Permissions
```
GET /drives/{drive-id}/items/{item-id}/permissions
```
or
```
GET /drives/{drive-id}/root:/{path}:/permissions
```

### Share with Specific Users (Send Link)
```
POST /drives/{drive-id}/items/{item-id}/invite
Content-Type: application/json

{
  "recipients": [
    {"email": "user@contoso.com"}
  ],
  "roles": ["read"],
  "requireSignIn": true,
  "sendInvitation": true,
  "message": "Please review this document"
}
```

### Share without Email (Create Permission)
```
POST /drives/{drive-id}/items/{item-id}/invite
Content-Type: application/json

{
  "recipients": [
    {"email": "user@contoso.com"}
  ],
  "roles": ["write"],
  "requireSignIn": true,
  "sendInvitation": false
}
```

### Role Types
- `read` - View only
- `write` - Edit
- `owner` - Full control

### Create Sharing Link
```
POST /drives/{drive-id}/items/{item-id}/createLink
Content-Type: application/json

{
  "type": "view",
  "scope": "organization"
}
```

**Link types:** `view`, `edit`, `embed`
**Scopes:** `anonymous`, `organization`, `users`

### Remove Permission
```
DELETE /drives/{drive-id}/items/{item-id}/permissions/{permission-id}
```

## Search

### Search Within a Drive
```
GET /drives/{drive-id}/root/search(q='{search-term}')
```

### Search Within a Site
```
GET /sites/{site-id}/drive/root/search(q='{search-term}')
```

### Search Across All Sites
```
GET /search/query
Content-Type: application/json

{
  "requests": [
    {
      "entityTypes": ["driveItem"],
      "query": {
        "queryString": "contoso report"
      }
    }
  ]
}
```
