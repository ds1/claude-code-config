#
# Install Claude Code configuration (Windows)
# Copies CLAUDE.md, settings.json, and commands/ to ~/.claude/
#
# Usage: .\install.ps1 [-Force]

param(
    [switch]$Force
)

$ErrorActionPreference = "Stop"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ClaudeDir = Join-Path $env:USERPROFILE ".claude"

function Write-Info($msg)  { Write-Host "[+] $msg" -ForegroundColor Green }
function Write-Warn($msg)  { Write-Host "[!] $msg" -ForegroundColor Yellow }
function Write-Err($msg)   { Write-Host "[x] $msg" -ForegroundColor Red }

function Confirm-Action($msg) {
    if ($Force) { return $true }
    $response = Read-Host "$msg [y/N]"
    return $response -match '^[Yy]$'
}

# Ensure ~/.claude exists
New-Item -ItemType Directory -Path $ClaudeDir -Force | Out-Null
New-Item -ItemType Directory -Path (Join-Path $ClaudeDir "commands") -Force | Out-Null

Write-Host ""
Write-Host "Claude Code Config Installer"
Write-Host "=============================="
Write-Host ""

# Install CLAUDE.md
$claudeMdTarget = Join-Path $ClaudeDir "CLAUDE.md"
if ((Test-Path $claudeMdTarget) -and -not $Force) {
    Write-Warn "~/.claude/CLAUDE.md already exists."
    Write-Warn "  Your existing CLAUDE.md may contain custom instructions."
    if (Confirm-Action "  Overwrite it? (Your current file will be backed up to CLAUDE.md.bak)") {
        Copy-Item $claudeMdTarget (Join-Path $ClaudeDir "CLAUDE.md.bak") -Force
        Write-Info "Existing CLAUDE.md backed up to CLAUDE.md.bak"
        Copy-Item (Join-Path $ScriptDir "CLAUDE.md") $claudeMdTarget -Force
        Write-Info "CLAUDE.md updated."
    } else {
        Write-Warn "Skipped CLAUDE.md."
    }
} else {
    Copy-Item (Join-Path $ScriptDir "CLAUDE.md") $claudeMdTarget -Force
    Write-Info "CLAUDE.md installed."
}

# Install settings.json
$settingsTarget = Join-Path $ClaudeDir "settings.json"
if ((Test-Path $settingsTarget) -and -not $Force) {
    Write-Warn "~/.claude/settings.json already exists."
    Write-Warn "  Your existing settings may contain personal permissions and tool approvals."
    if (Confirm-Action "  Overwrite it? (Your current settings will be backed up to settings.json.bak)") {
        Copy-Item $settingsTarget (Join-Path $ClaudeDir "settings.json.bak") -Force
        Write-Info "Existing settings backed up to settings.json.bak"
        Copy-Item (Join-Path $ScriptDir "settings.json") $settingsTarget -Force
        Write-Info "settings.json updated."
    } else {
        Write-Warn "Skipped settings.json."
    }
} else {
    Copy-Item (Join-Path $ScriptDir "settings.json") $settingsTarget -Force
    Write-Info "settings.json installed."
}

# Install commands
$installed = 0
$skipped = 0

Get-ChildItem (Join-Path $ScriptDir "commands" "*.md") | ForEach-Object {
    $target = Join-Path $ClaudeDir "commands" $_.Name
    if ((Test-Path $target) -and -not $Force) {
        $skipped++
    } else {
        Copy-Item $_.FullName $target -Force
        $installed++
    }
}

if ($installed -gt 0) { Write-Info "$installed command(s) installed to ~/.claude/commands/" }
if ($skipped -gt 0)   { Write-Warn "$skipped command(s) already existed (use -Force to overwrite)." }

Write-Host ""
Write-Info "Done! Restart Claude Code to pick up the new configuration."
Write-Host ""
Write-Host "Installed to: $ClaudeDir"
Write-Host ""
Write-Host "What's included:"
Write-Host "  - CLAUDE.md       Global instructions (writing style, safety, git, code quality)"
Write-Host "  - settings.json   Permissions, hooks, status line, plugins"
Write-Host "  - commands/       20 slash commands (/status, /deploy, /probe-start, etc.)"
Write-Host ""
Write-Host "Tip: Review settings.json and customize permissions for your workflow."
