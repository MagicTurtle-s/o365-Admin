# Email-to-Leaderboard Processing System

## System Overview

```
┌──────────────────┐      ┌─────────────────┐      ┌─────────────────┐
│   Shared Inbox   │      │  Power Automate │      │   SharePoint    │
│                  │─────►│                 │─────►│                 │
│  Receives emails │      │  - Match sender │      │  - Members      │
│  from members    │      │  - Create entry │      │  - Leaderboard  │
│                  │      │  - Process/OCR  │      │  - Attachments  │
└──────────────────┘      └─────────────────┘      └─────────────────┘
                                   │
                                   ▼
                          ┌─────────────────┐
                          │     Admin       │
                          │                 │
                          │  Review/Approve │
                          └─────────────────┘
```

---

## 1. SharePoint List Schemas

### 1.1 Members List (Admin-Managed Roster)

**Purpose:** Master list of recognized members for matching incoming emails.

| Display Name | Internal Name | Type | Required | Notes |
|--------------|---------------|------|----------|-------|
| Member ID | MemberID | Auto-number or Text | Yes | Unique identifier |
| Display Name | Title | Single line text | Yes | Default Title column |
| First Name | FirstName | Single line text | Yes | |
| Last Name | LastName | Single line text | Yes | |
| Email | Email | Single line text | Yes | Primary match field |
| Secondary Email | EmailSecondary | Single line text | No | Alternate email |
| Phone | Phone | Single line text | No | For SMS/phone matching |
| Status | MemberStatus | Choice | Yes | Active, Inactive, Suspended |
| Join Date | JoinDate | Date only | No | |
| Notes | Notes | Multi-line text | No | Admin notes |

**Indexes needed:** Email, EmailSecondary, Phone (for fast lookups)

```json
// API: Create Members list
POST /sites/{site-id}/lists
{
  "displayName": "Members",
  "list": { "template": "genericList" }
}

// API: Add Email column
POST /sites/{site-id}/lists/{list-id}/columns
{
  "name": "Email",
  "text": { "maxLength": 255 },
  "required": true,
  "enforceUniqueValues": true
}
```

---

### 1.2 Leaderboard List (Activity Tracking)

**Purpose:** Track member submissions and their processing status.

| Display Name | Internal Name | Type | Required | Notes |
|--------------|---------------|------|----------|-------|
| Entry ID | Title | Single line text | Yes | Auto-generated reference |
| Member | Member | Lookup (Members) | Yes | Links to Members list |
| Email Subject | EmailSubject | Single line text | No | Original email subject |
| Email Received | EmailReceivedDate | DateTime | Yes | When email arrived |
| Email Message ID | EmailMessageID | Single line text | Yes | For linking back to email |
| Status | Status | Choice | Yes | See status values below |
| Processed Date | ProcessedDate | DateTime | No | When status changed to Processed |
| Approved Date | ApprovedDate | DateTime | No | When admin approved |
| Approved By | ApprovedBy | Person | No | Admin who approved |
| Error Notes | ErrorNotes | Multi-line text | No | Any processing errors |
| Activity Type | ActivityType | Choice | No | Category of submission |
| Points | Points | Number | No | Calculated or assigned |

**Status Values:**
- `Received` - Email matched and entry created
- `Unmatched` - Email received but sender not in roster
- `Processing` - AI/OCR extraction in progress
- `PreProcessed` - Extraction complete, pending review
- `Approved` - Admin verified and approved
- `Rejected` - Admin rejected submission
- `Error` - Processing failed

---

### 1.3 Submissions List (Email Content/Attachments)

**Purpose:** Store extracted data from emails. Separate from Leaderboard for flexibility.

| Display Name | Internal Name | Type | Required | Notes |
|--------------|---------------|------|----------|-------|
| Title | Title | Single line text | Yes | Auto-generated |
| Leaderboard Entry | LeaderboardEntry | Lookup | Yes | Links to Leaderboard |
| Email Body | EmailBody | Multi-line text | No | Plain text content |
| Attachment Count | AttachmentCount | Number | No | How many files |
| Attachment URLs | AttachmentURLs | Multi-line text | No | Links to stored files |
| Extracted Field 1 | ExtractedField1 | Text | No | OCR/AI extracted data |
| Extracted Field 2 | ExtractedField2 | Text | No | Customize per use case |
| Extraction Confidence | ExtractionConfidence | Number | No | AI confidence score |
| Raw Extraction JSON | ExtractionRaw | Multi-line text | No | Full AI response |

---

## 2. Folder Structure (Document Library)

```
/Submissions
├── /2024
│   ├── /01-January
│   │   ├── /MemberID-12345
│   │   │   ├── email-attachment-1.jpg
│   │   │   └── email-attachment-2.pdf
│   │   └── /MemberID-67890
│   └── /02-February
└── /Unmatched
    └── (emails that couldn't be matched)
```

---

## 3. Workflow Architecture

### 3.1 Flow: Email Arrival Processing

```
Trigger: When email arrives in shared mailbox
    │
    ▼
┌─────────────────────────────────────┐
│ Extract sender email address        │
└─────────────────────────────────────┘
    │
    ▼
┌─────────────────────────────────────┐
│ Query Members list:                 │
│ $filter=Email eq '{sender}'         │
│      or EmailSecondary eq '{sender}'│
└─────────────────────────────────────┘
    │
    ├─── Match found ──────────────────────┐
    │                                      ▼
    │                         ┌─────────────────────────────────────┐
    │                         │ Create Leaderboard entry            │
    │                         │ - Status: "Received"                │
    │                         │ - Member: {matched member}          │
    │                         │ - EmailMessageID: {message id}      │
    │                         └─────────────────────────────────────┘
    │                                      │
    │                                      ▼
    │                         ┌─────────────────────────────────────┐
    │                         │ Save attachments to document library│
    │                         │ /Submissions/{Year}/{Month}/{MemberID}
    │                         └─────────────────────────────────────┘
    │                                      │
    │                                      ▼
    │                         ┌─────────────────────────────────────┐
    │                         │ Option A: Trigger AI processing     │
    │                         │ Option B: Notify admin for manual   │
    │                         └─────────────────────────────────────┘
    │
    └─── No match ─────────────────────────┐
                                           ▼
                              ┌─────────────────────────────────────┐
                              │ Create Leaderboard entry            │
                              │ - Status: "Unmatched"               │
                              │ - Store email for admin review      │
                              │ - Notify admin                      │
                              └─────────────────────────────────────┘
```

### 3.2 Flow: AI Processing (Option A)

```
Trigger: When Leaderboard item Status = "Received"
    │
    ▼
┌─────────────────────────────────────┐
│ Get attachments from document lib   │
└─────────────────────────────────────┘
    │
    ▼
┌─────────────────────────────────────┐
│ For each image attachment:          │
│ - AI Builder: Extract text (OCR)    │
│ - OR Azure Form Recognizer          │
│ - OR Azure OpenAI Vision            │
└─────────────────────────────────────┘
    │
    ├─── Success ──────────────────────────┐
    │                                      ▼
    │                         ┌─────────────────────────────────────┐
    │                         │ Update Submissions list with        │
    │                         │ extracted data                      │
    │                         │ Update Status: "PreProcessed"       │
    │                         │ Notify admin for review             │
    │                         └─────────────────────────────────────┘
    │
    └─── Error ────────────────────────────┐
                                           ▼
                              ┌─────────────────────────────────────┐
                              │ Update Status: "Error"              │
                              │ Log error details                   │
                              │ Notify admin                        │
                              └─────────────────────────────────────┘
```

---

## 4. Permission Model

### Challenge: Item-Level Visibility

SharePoint item-level permissions are possible but expensive (performance, management overhead).

### Recommended Approach: View-Based Filtering

| View | Filter | Who Sees |
|------|--------|----------|
| My Submissions | `[Member] = [CurrentUser]` AND `Status != Received` | Members see their own approved items |
| Admin Queue | `Status in (Received, PreProcessed, Unmatched)` | Admins only |
| All Approved | `Status = Approved` | Everyone (or public) |

**For external members:** Use Power Apps portal or a custom Power App that filters by logged-in user's email matched to the Members list.

### Alternative: Separate Lists

```
LeaderboardPublic  ← Only approved items, visible to all
LeaderboardQueue   ← Received/Processing items, admin-only permissions
```

Flow moves items from Queue → Public upon approval.

---

## 5. Processing Options & Costs

### Option A: AI Processing

| Tool | What It Does | Cost |
|------|--------------|------|
| **AI Builder (Power Platform)** | OCR, form processing, text extraction | Included in some M365 plans; otherwise ~$500/month for 1M credits |
| **Azure Form Recognizer** | Document intelligence, custom models | ~$1.50 per 1000 pages (prebuilt); custom models higher |
| **Azure OpenAI (GPT-4 Vision)** | Analyze images, extract structured data | ~$0.01-0.03 per image |
| **Azure Cognitive Services OCR** | Basic text extraction | ~$1 per 1000 images |

**Recommendation for low cost:**
- Low volume (<100/month): Azure OpenAI Vision or Cognitive Services OCR
- Medium volume: AI Builder if included in license
- High volume: Azure Form Recognizer with custom model

### Option B: Manual Processing

| Step | Tool | Cost |
|------|------|------|
| View email/attachments | Teams/SharePoint | Free |
| Transcribe to list fields | SharePoint form or Power App | Free |
| Update status | SharePoint/Power Automate | Free |

**Total cost: $0** (just admin time)

---

## 6. Implementation Phases

### Phase 1: Foundation (Lists + Manual Workflow)
1. Create Members list with schema
2. Create Leaderboard list with schema
3. Create Submissions document library
4. Set up views and permissions
5. Create Power Automate: Email → Match → Create Entry
6. Manual admin processing (Option B)

### Phase 2: Automation (Flows + Notifications)
1. Add notification flows (admin alerts, member confirmations)
2. Add approval workflow
3. Add status change automation

### Phase 3: AI Processing (Option A)
1. Evaluate AI tool based on volume/budget
2. Create processing flow
3. Test and refine extraction accuracy
4. Add confidence scoring and error handling

---

## 7. Questions to Refine

1. **What data is in the email images?** (receipts, forms, screenshots, photos?)
2. **How many submissions per day/week/month?** (affects AI tool choice)
3. **Are senders internal (M365 users) or external?** (affects permission model)
4. **What specific fields need extraction?** (date, amount, description, etc.)
5. **Is the leaderboard public or private?** (visible to all members or just admins?)
