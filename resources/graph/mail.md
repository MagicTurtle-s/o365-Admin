# Exchange Online Mail

This resource documents Graph API endpoints for mail and calendar operations.

## Required Permissions

| Permission | Type | Description |
|------------|------|-------------|
| Mail.Read | Application | Read mail in all mailboxes |
| Mail.ReadWrite | Application | Read/write mail |
| Mail.Send | Application | Send mail as any user |
| Calendars.Read | Application | Read calendars |
| Calendars.ReadWrite | Application | Read/write calendars |
| MailboxSettings.ReadWrite | Application | Manage mailbox settings |

## Messages

### List Messages
**TODO:** Document message listing with filtering

```
GET /users/{user-id}/messages
GET /users/{user-id}/messages?$filter=isRead eq false
GET /users/{user-id}/messages?$select=subject,from,receivedDateTime
```

### Get Message
**TODO:** Document getting message details

```
GET /users/{user-id}/messages/{message-id}
```

### Send Message
**TODO:** Document sending mail

```
POST /users/{user-id}/sendMail
Content-Type: application/json

{
  "message": {
    "subject": "Meeting Tomorrow",
    "body": {
      "contentType": "Text",
      "content": "Let's meet at 10am."
    },
    "toRecipients": [
      {
        "emailAddress": {
          "address": "recipient@contoso.com"
        }
      }
    ]
  },
  "saveToSentItems": true
}
```

### Create Draft
**TODO:** Document draft creation

```
POST /users/{user-id}/messages
```

### Update Message
**TODO:** Document message updates

```
PATCH /users/{user-id}/messages/{message-id}
```

### Delete Message
**TODO:** Document message deletion

```
DELETE /users/{user-id}/messages/{message-id}
```

### Move Message
**TODO:** Document moving messages

```
POST /users/{user-id}/messages/{message-id}/move
Content-Type: application/json

{
  "destinationId": "{folder-id}"
}
```

## Folders

### List Folders
**TODO:** Document folder listing

```
GET /users/{user-id}/mailFolders
```

### Get Folder
**TODO:** Document getting folder details

```
GET /users/{user-id}/mailFolders/{folder-id}
```

### Create Folder
**TODO:** Document folder creation

```
POST /users/{user-id}/mailFolders
Content-Type: application/json

{
  "displayName": "Project Updates"
}
```

### Delete Folder
**TODO:** Document folder deletion

```
DELETE /users/{user-id}/mailFolders/{folder-id}
```

### Well-Known Folders
**TODO:** Document accessing well-known folders

```
GET /users/{user-id}/mailFolders/inbox
GET /users/{user-id}/mailFolders/sentitems
GET /users/{user-id}/mailFolders/drafts
GET /users/{user-id}/mailFolders/deleteditems
```

## Mail Rules

### List Rules
**TODO:** Document listing inbox rules

```
GET /users/{user-id}/mailFolders/inbox/messageRules
```

### Get Rule
**TODO:** Document getting rule details

```
GET /users/{user-id}/mailFolders/inbox/messageRules/{rule-id}
```

### Create Rule
**TODO:** Document rule creation

```
POST /users/{user-id}/mailFolders/inbox/messageRules
Content-Type: application/json

{
  "displayName": "From boss",
  "sequence": 1,
  "isEnabled": true,
  "conditions": {
    "senderContains": ["boss@contoso.com"]
  },
  "actions": {
    "forwardTo": [
      {
        "emailAddress": {
          "address": "assistant@contoso.com"
        }
      }
    ],
    "stopProcessingRules": true
  }
}
```

### Update Rule
**TODO:** Document rule updates

```
PATCH /users/{user-id}/mailFolders/inbox/messageRules/{rule-id}
```

### Delete Rule
**TODO:** Document rule deletion

```
DELETE /users/{user-id}/mailFolders/inbox/messageRules/{rule-id}
```

## Calendar Events

### List Events
**TODO:** Document event listing

```
GET /users/{user-id}/calendar/events
GET /users/{user-id}/calendarView?startDateTime=2024-01-01T00:00:00&endDateTime=2024-01-31T23:59:59
```

### Get Event
**TODO:** Document getting event details

```
GET /users/{user-id}/calendar/events/{event-id}
```

### Create Event
**TODO:** Document event creation

```
POST /users/{user-id}/calendar/events
Content-Type: application/json

{
  "subject": "Team Meeting",
  "body": {
    "contentType": "HTML",
    "content": "Discuss Q1 goals"
  },
  "start": {
    "dateTime": "2024-01-15T10:00:00",
    "timeZone": "Pacific Standard Time"
  },
  "end": {
    "dateTime": "2024-01-15T11:00:00",
    "timeZone": "Pacific Standard Time"
  },
  "location": {
    "displayName": "Conference Room A"
  },
  "attendees": [
    {
      "emailAddress": {
        "address": "colleague@contoso.com"
      },
      "type": "required"
    }
  ]
}
```

### Update Event
**TODO:** Document event updates

```
PATCH /users/{user-id}/calendar/events/{event-id}
```

### Delete Event
**TODO:** Document event deletion

```
DELETE /users/{user-id}/calendar/events/{event-id}
```

### Accept/Decline Event
**TODO:** Document responding to events

```
POST /users/{user-id}/calendar/events/{event-id}/accept
POST /users/{user-id}/calendar/events/{event-id}/decline
POST /users/{user-id}/calendar/events/{event-id}/tentativelyAccept
```
