# install.ps1 - Install O365 Admin skill for Claude Code (Windows)
# Usage: Right-click and "Run with PowerShell" or run: .\install.ps1

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$SkillDir = "$env:USERPROFILE\.claude\skills\o365"
$CommandsDir = "$env:USERPROFILE\.claude\commands"

Write-Host "Installing O365 Admin skill..." -ForegroundColor Cyan

# Create directories
New-Item -ItemType Directory -Force -Path $SkillDir | Out-Null
New-Item -ItemType Directory -Force -Path $CommandsDir | Out-Null

# Copy skill files
Copy-Item "$ScriptDir\o365\README.md" -Destination $SkillDir -Force
Copy-Item "$ScriptDir\o365\get-token.ps1" -Destination $SkillDir -Force
Copy-Item "$ScriptDir\o365\graph-call.ps1" -Destination $SkillDir -Force
Copy-Item "$ScriptDir\o365\powerplatform-call.ps1" -Destination $SkillDir -Force
Copy-Item "$ScriptDir\o365\.env.example" -Destination $SkillDir -Force

# Copy slash command
Copy-Item "$ScriptDir\commands\o365.md" -Destination $CommandsDir -Force

Write-Host ""
Write-Host "Installation complete!" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Configure credentials:"
Write-Host "   Copy-Item $SkillDir\.env.example $SkillDir\.env"
Write-Host "   # Edit $SkillDir\.env with your Azure AD credentials"
Write-Host ""
Write-Host "2. Test the connection:"
Write-Host "   & $SkillDir\graph-call.ps1 GET /organization"
Write-Host ""
Write-Host "3. Use in Claude Code:"
Write-Host "   Type /o365 to activate the skill"
Write-Host ""
