# O365-Admin Project Outline

## Overview
A Claude Code skill for managing Microsoft 365 services via Graph API and Power Platform APIs.

---

## 1. Entra ID (Identity & Access Management)

### 1.1 User Management
| Operation | Endpoint | Status |
|-----------|----------|--------|
| List users | `GET /users` | ✅ |
| Get user | `GET /users/{id}` | ✅ |
| Create user | `POST /users` | ✅ |
| Update user | `PATCH /users/{id}` | ✅ |
| Delete user | `DELETE /users/{id}` | ✅ |
| Get manager | `GET /users/{id}/manager` | ✅ |
| Set manager | `PUT /users/{id}/manager/$ref` | ✅ |
| Get direct reports | `GET /users/{id}/directReports` | ✅ |
| Reset password | `POST /users/{id}/authentication/methods/{id}/resetPassword` | 📝 TODO |
| Revoke sessions | `POST /users/{id}/revokeSignInSessions` | 📝 TODO |

### 1.2 Group Management
| Operation | Endpoint | Status |
|-----------|----------|--------|
| List groups | `GET /groups` | ✅ |
| Create M365 group | `POST /groups` | ✅ |
| Create security group | `POST /groups` | ✅ |
| Add member | `POST /groups/{id}/members/$ref` | ✅ |
| Remove member | `DELETE /groups/{id}/members/{id}/$ref` | ✅ |
| List owners | `GET /groups/{id}/owners` | ✅ |
| Add owner | `POST /groups/{id}/owners/$ref` | 📝 TODO |

### 1.3 Directory Roles
| Operation | Endpoint | Status |
|-----------|----------|--------|
| List roles | `GET /directoryRoles` | ✅ |
| Assign role | `POST /directoryRoles/{id}/members/$ref` | ✅ |
| Remove role | `DELETE /directoryRoles/{id}/members/{id}/$ref` | ✅ |
| List role members | `GET /directoryRoles/{id}/members` | ✅ |

### 1.4 App Registrations
| Operation | Endpoint | Status |
|-----------|----------|--------|
| List apps | `GET /applications` | 📝 TODO |
| Get app | `GET /applications/{id}` | 📝 TODO |
| Create app | `POST /applications` | 📝 TODO |
| Add client secret | `POST /applications/{id}/addPassword` | 📝 TODO |
| Remove client secret | `POST /applications/{id}/removePassword` | 📝 TODO |
| List service principals | `GET /servicePrincipals` | 📝 TODO |

### 1.5 Conditional Access (Beta)
| Operation | Endpoint | Status |
|-----------|----------|--------|
| List policies | `GET /identity/conditionalAccess/policies` | 📝 TODO |
| Create policy | `POST /identity/conditionalAccess/policies` | 📝 TODO |
| Enable/disable policy | `PATCH /identity/conditionalAccess/policies/{id}` | 📝 TODO |
| List named locations | `GET /identity/conditionalAccess/namedLocations` | 📝 TODO |

### 1.6 Licenses
| Operation | Endpoint | Status |
|-----------|----------|--------|
| List subscribed SKUs | `GET /subscribedSkus` | 📝 TODO |
| Assign license | `POST /users/{id}/assignLicense` | 📝 TODO |
| Remove license | `POST /users/{id}/assignLicense` (remove) | 📝 TODO |
| Get user licenses | `GET /users/{id}/licenseDetails` | 📝 TODO |

---

## 2. SharePoint

### 2.1 Sites
| Operation | Endpoint | Status |
|-----------|----------|--------|
| Get root site | `GET /sites/root` | ✅ |
| Get site by URL | `GET /sites/{host}:/{path}` | ✅ |
| Search sites | `GET /sites?search={q}` | ✅ |
| Get subsites | `GET /sites/{id}/sites` | ✅ |
| Create site | (Admin API) | 📝 TODO |

### 2.2 Document Libraries (Drives)
| Operation | Endpoint | Status |
|-----------|----------|--------|
| List drives | `GET /sites/{id}/drives` | ✅ |
| Get default drive | `GET /sites/{id}/drive` | ✅ |
| List root contents | `GET /drives/{id}/root/children` | ✅ |
| Get folder contents | `GET /drives/{id}/root:/{path}:/children` | ✅ |

### 2.3 Files & Folders
| Operation | Endpoint | Status |
|-----------|----------|--------|
| Create folder | `POST /drives/{id}/root/children` | ✅ |
| Upload small file | `PUT /drives/{id}/root:/{path}:/content` | ✅ |
| Upload large file | `POST .../createUploadSession` | ✅ |
| Download file | `GET /drives/{id}/items/{id}/content` | ✅ |
| Copy file | `POST /drives/{id}/items/{id}/copy` | ✅ |
| Move file | `PATCH /drives/{id}/items/{id}` | ✅ |
| Delete | `DELETE /drives/{id}/items/{id}` | ✅ |

### 2.4 Lists
| Operation | Endpoint | Status |
|-----------|----------|--------|
| List all lists | `GET /sites/{id}/lists` | ✅ |
| Create list | `POST /sites/{id}/lists` | ✅ |
| Add column | `POST /sites/{id}/lists/{id}/columns` | ✅ |
| List items | `GET /sites/{id}/lists/{id}/items` | ✅ |
| Create item | `POST /sites/{id}/lists/{id}/items` | ✅ |
| Update item | `PATCH /sites/{id}/lists/{id}/items/{id}` | ✅ |
| Delete item | `DELETE /sites/{id}/lists/{id}/items/{id}` | ✅ |
| Filter items | `GET .../items?$filter=...` | ✅ |

### 2.5 Permissions & Sharing
| Operation | Endpoint | Status |
|-----------|----------|--------|
| Get permissions | `GET /drives/{id}/items/{id}/permissions` | ✅ |
| Share with users | `POST /drives/{id}/items/{id}/invite` | ✅ |
| Create sharing link | `POST /drives/{id}/items/{id}/createLink` | ✅ |
| Remove permission | `DELETE .../permissions/{id}` | ✅ |

### 2.6 Search
| Operation | Endpoint | Status |
|-----------|----------|--------|
| Search in drive | `GET /drives/{id}/root/search(q='...')` | ✅ |
| Search across tenant | `POST /search/query` | ✅ |

---

## 3. Power Automate (Flows)

### 3.1 Flow Management
| Operation | Endpoint | Status |
|-----------|----------|--------|
| List flows | `GET .../environments/{id}/flows` | ✅ |
| Get flow | `GET .../flows/{id}` | ✅ |
| Enable flow | `POST .../flows/{id}/start` | ✅ |
| Disable flow | `POST .../flows/{id}/stop` | ✅ |
| Delete flow | `DELETE .../flows/{id}` | ✅ |
| Export flow | `POST .../flows/{id}/exportPackage` | 📝 TODO |
| Import flow | `POST .../flows/importPackage` | 📝 TODO |

### 3.2 Flow Runs
| Operation | Endpoint | Status |
|-----------|----------|--------|
| List runs | `GET .../flows/{id}/runs` | ✅ |
| Get run details | `GET .../flows/{id}/runs/{id}` | ✅ |
| Cancel run | `POST .../runs/{id}/cancel` | ✅ |
| Resubmit failed run | `POST .../resubmit` | ✅ |
| Get run actions | `GET .../runs/{id}/actions` | 📝 TODO |

### 3.3 Connections
| Operation | Endpoint | Status |
|-----------|----------|--------|
| List connections | `GET .../connections` | ✅ |
| Get connection | `GET .../connections/{id}` | ✅ |
| Delete connection | `DELETE .../connections/{id}` | ✅ |
| Test connection | `POST .../connections/{id}/testConnection` | 📝 TODO |

### 3.4 Flow Permissions
| Operation | Endpoint | Status |
|-----------|----------|--------|
| List permissions | `GET .../flows/{id}/permissions` | 📝 TODO |
| Share flow | `POST .../flows/{id}/modifyPermissions` | 📝 TODO |
| Remove access | `DELETE .../flows/{id}/permissions/{id}` | 📝 TODO |

---

## 4. Power Apps

### 4.1 App Management
| Operation | Endpoint | Status |
|-----------|----------|--------|
| List apps | `GET .../apps` | 📝 TODO |
| Get app | `GET .../apps/{id}` | 📝 TODO |
| Delete app | `DELETE .../apps/{id}` | 📝 TODO |
| Publish app | `POST .../apps/{id}/publish` | 📝 TODO |

### 4.2 App Permissions
| Operation | Endpoint | Status |
|-----------|----------|--------|
| List app roles | `GET .../apps/{id}/permissions` | 📝 TODO |
| Share app | `POST .../apps/{id}/modifyPermissions` | 📝 TODO |
| Remove access | `DELETE .../apps/{id}/permissions/{id}` | 📝 TODO |

### 4.3 App Versions
| Operation | Endpoint | Status |
|-----------|----------|--------|
| List versions | `GET .../apps/{id}/versions` | 📝 TODO |
| Restore version | `POST .../apps/{id}/versions/{id}/restore` | 📝 TODO |

---

## 5. Power Platform Environments

### 5.1 Environment Management
| Operation | Endpoint | Status |
|-----------|----------|--------|
| List environments | `GET .../environments` | ✅ |
| Get environment | `GET .../environments/{id}` | ✅ |
| Create environment | `POST .../environments` | 📝 TODO |
| Delete environment | `DELETE .../environments/{id}` | ✅ |
| Get capacity | `GET .../environments/{id}/capacity` | 📝 TODO |

### 5.2 DLP Policies
| Operation | Endpoint | Status |
|-----------|----------|--------|
| List policies | `GET .../apiPolicies` | ✅ |
| Get policy | `GET .../apiPolicies/{id}` | ✅ |
| Create policy | `POST .../apiPolicies` | 📝 TODO |
| Update policy | `PATCH .../apiPolicies/{id}` | 📝 TODO |
| Delete policy | `DELETE .../apiPolicies/{id}` | 📝 TODO |

### 5.3 Environment Security
| Operation | Endpoint | Status |
|-----------|----------|--------|
| List users | `GET .../environments/{id}/users` | 📝 TODO |
| Add user | `POST .../environments/{id}/users` | 📝 TODO |
| Remove user | `DELETE .../environments/{id}/users/{id}` | 📝 TODO |
| List security roles | `GET .../environments/{id}/securityRoles` | 📝 TODO |

---

## 6. Cross-Service Integrations

### 6.1 Common Patterns
| Pattern | Services | Status |
|---------|----------|--------|
| Create Team from SharePoint site | SharePoint → Teams | 📝 TODO |
| Provision site with Team | Teams → SharePoint | 📝 TODO |
| Flow triggered by SharePoint | SharePoint → Power Automate | 📝 TODO |
| Power App with SharePoint data | Power Apps → SharePoint | 📝 TODO |
| Onboard user (full lifecycle) | Entra → Groups → Teams → License | 📝 TODO |
| Offboard user (full lifecycle) | Revoke → Remove → Disable | 📝 TODO |

### 6.2 Automation Recipes
| Recipe | Description | Status |
|--------|-------------|--------|
| New employee onboarding | Create user, assign license, add to groups, create mailbox | 📝 TODO |
| Project workspace setup | Create Team, SharePoint site, document libraries, channels | 📝 TODO |
| Bulk user import | CSV → Create users → Assign licenses | 📝 TODO |
| License audit report | List users → Check licenses → Generate report | 📝 TODO |
| Inactive flow cleanup | List flows → Check last run → Disable/delete stale | 📝 TODO |

---

## Summary

| Category | Total Operations | Documented | TODO |
|----------|-----------------|------------|------|
| Entra ID | 28 | 14 | 14 |
| SharePoint | 25 | 25 | 0 |
| Power Automate | 18 | 10 | 8 |
| Power Apps | 9 | 0 | 9 |
| Environments | 14 | 5 | 9 |
| Integrations | 11 | 0 | 11 |
| **Total** | **105** | **54** | **51** |

---

## Recommended Priority

1. **Phase A:** Complete Entra ID (user lifecycle is foundational)
2. **Phase B:** Complete Power Automate (flow management is high-value)
3. **Phase C:** Add Power Apps (completes Power Platform)
4. **Phase D:** Add cross-service integrations (advanced recipes)
