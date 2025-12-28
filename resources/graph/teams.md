# Microsoft Teams

This resource documents Graph API endpoints for Microsoft Teams operations.

## Required Permissions

| Permission | Type | Description |
|------------|------|-------------|
| Team.ReadBasic.All | Application | Read basic team info |
| Team.Create | Application | Create teams |
| TeamSettings.ReadWrite.All | Application | Read/write team settings |
| Channel.Create | Application | Create channels |
| ChannelSettings.ReadWrite.All | Application | Manage channel settings |
| TeamsApp.ReadWrite.All | Application | Manage Teams apps |
| TeamMember.ReadWrite.All | Application | Manage team members |

## Teams

### List Joined Teams
**TODO:** Document listing teams for a user

```
GET /users/{user-id}/joinedTeams
```

### Get Team
**TODO:** Document getting team details

```
GET /teams/{team-id}
```

### Create Team
**TODO:** Document team creation options

```
POST /teams
Content-Type: application/json

{
  "template@odata.bind": "https://graph.microsoft.com/v1.0/teamsTemplates('standard')",
  "displayName": "Team Name",
  "description": "Team description"
}
```

### Update Team
**TODO:** Document team update operations

```
PATCH /teams/{team-id}
```

### Delete Team
**TODO:** Document team deletion

```
DELETE /groups/{group-id}
```

### Archive Team
**TODO:** Document team archiving

```
POST /teams/{team-id}/archive
```

## Channels

### List Channels
**TODO:** Document channel listing

```
GET /teams/{team-id}/channels
```

### Create Channel
**TODO:** Document channel creation (standard and private)

```
POST /teams/{team-id}/channels
Content-Type: application/json

{
  "displayName": "Channel Name",
  "description": "Channel description",
  "membershipType": "standard"
}
```

### Get Channel
**TODO:** Document getting channel details

```
GET /teams/{team-id}/channels/{channel-id}
```

### Delete Channel
**TODO:** Document channel deletion

```
DELETE /teams/{team-id}/channels/{channel-id}
```

## Tabs

### List Tabs
**TODO:** Document listing tabs in a channel

```
GET /teams/{team-id}/channels/{channel-id}/tabs
```

### Add Tab
**TODO:** Document adding tabs (different app types)

```
POST /teams/{team-id}/channels/{channel-id}/tabs
```

### Remove Tab
**TODO:** Document tab removal

```
DELETE /teams/{team-id}/channels/{channel-id}/tabs/{tab-id}
```

## Apps

### List Installed Apps
**TODO:** Document listing installed apps in a team

```
GET /teams/{team-id}/installedApps
```

### Install App
**TODO:** Document app installation

```
POST /teams/{team-id}/installedApps
```

### Uninstall App
**TODO:** Document app removal

```
DELETE /teams/{team-id}/installedApps/{app-installation-id}
```

## Members

### List Team Members
**TODO:** Document listing team members

```
GET /teams/{team-id}/members
```

### Add Member
**TODO:** Document adding members (member vs owner roles)

```
POST /teams/{team-id}/members
Content-Type: application/json

{
  "@odata.type": "#microsoft.graph.aadUserConversationMember",
  "roles": ["member"],
  "user@odata.bind": "https://graph.microsoft.com/v1.0/users/{user-id}"
}
```

### Remove Member
**TODO:** Document member removal

```
DELETE /teams/{team-id}/members/{membership-id}
```

### List Channel Members
**TODO:** Document listing channel members (for private channels)

```
GET /teams/{team-id}/channels/{channel-id}/members
```
