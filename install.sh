#!/usr/bin/env bash
#
# Install Claude Code configuration
# Copies CLAUDE.md, settings.json, and commands/ to ~/.claude/
#
# Usage: ./install.sh [--force]
#   --force  Overwrite existing files without prompting

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"
FORCE=false

if [[ "${1:-}" == "--force" ]]; then
    FORCE=true
fi

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

info()  { echo -e "${GREEN}[+]${NC} $1"; }
warn()  { echo -e "${YELLOW}[!]${NC} $1"; }
error() { echo -e "${RED}[x]${NC} $1"; }

confirm() {
    if $FORCE; then return 0; fi
    read -rp "$1 [y/N] " response
    [[ "$response" =~ ^[Yy]$ ]]
}

# Ensure ~/.claude exists
mkdir -p "$CLAUDE_DIR"
mkdir -p "$CLAUDE_DIR/commands"

echo ""
echo "Claude Code Config Installer"
echo "=============================="
echo ""

# Install CLAUDE.md
if [[ -f "$CLAUDE_DIR/CLAUDE.md" ]] && ! $FORCE; then
    warn "~/.claude/CLAUDE.md already exists."
    warn "  Your existing CLAUDE.md may contain custom instructions."
    if confirm "  Overwrite it? (Your current file will be backed up to CLAUDE.md.bak)"; then
        cp "$CLAUDE_DIR/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md.bak"
        info "Existing CLAUDE.md backed up to CLAUDE.md.bak"
        cp "$SCRIPT_DIR/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md"
        info "CLAUDE.md updated."
    else
        warn "Skipped CLAUDE.md."
    fi
else
    cp "$SCRIPT_DIR/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md"
    info "CLAUDE.md installed."
fi

# Install settings.json
if [[ -f "$CLAUDE_DIR/settings.json" ]] && ! $FORCE; then
    warn "~/.claude/settings.json already exists."
    warn "  Your existing settings may contain personal permissions and tool approvals."
    if confirm "  Overwrite it? (Your current settings will be backed up to settings.json.bak)"; then
        cp "$CLAUDE_DIR/settings.json" "$CLAUDE_DIR/settings.json.bak"
        info "Existing settings backed up to settings.json.bak"
        cp "$SCRIPT_DIR/settings.json" "$CLAUDE_DIR/settings.json"
        info "settings.json updated."
    else
        warn "Skipped settings.json."
    fi
else
    cp "$SCRIPT_DIR/settings.json" "$CLAUDE_DIR/settings.json"
    info "settings.json installed."
fi

# Install commands
COMMANDS_INSTALLED=0
COMMANDS_SKIPPED=0

for cmd_file in "$SCRIPT_DIR"/commands/*.md; do
    filename="$(basename "$cmd_file")"
    target="$CLAUDE_DIR/commands/$filename"

    if [[ -f "$target" ]] && ! $FORCE; then
        COMMANDS_SKIPPED=$((COMMANDS_SKIPPED + 1))
    else
        cp "$cmd_file" "$target"
        COMMANDS_INSTALLED=$((COMMANDS_INSTALLED + 1))
    fi
done

if [[ $COMMANDS_INSTALLED -gt 0 ]]; then
    info "$COMMANDS_INSTALLED command(s) installed to ~/.claude/commands/"
fi
if [[ $COMMANDS_SKIPPED -gt 0 ]]; then
    warn "$COMMANDS_SKIPPED command(s) already existed (use --force to overwrite)."
fi

echo ""
info "Done! Restart Claude Code to pick up the new configuration."
echo ""
echo "Installed to: $CLAUDE_DIR"
echo ""
echo "What's included:"
echo "  - CLAUDE.md       Global instructions (writing style, safety, git, code quality)"
echo "  - settings.json   Permissions, hooks, status line, plugins"
echo "  - commands/       20 slash commands (/status, /deploy, /probe-start, etc.)"
echo ""
echo "Tip: Review settings.json and customize permissions for your workflow."
