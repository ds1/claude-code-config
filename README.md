# Claude Code Config (aka BOILERPLATE.md)

By [@ds1](https://github.com/ds1) | [boilerplate.md](https://boilerplate.md)

A complete, opinionated [Claude Code](https://docs.anthropic.com/en/docs/claude-code) configuration with global instructions, 20 slash commands, and sensible defaults.

Drop this into `~/.claude/` and get a power-user setup out of the box.

## What's Included

### Global Instructions (`CLAUDE.md`)

Behavioral rules that apply to every Claude Code session:

- **Preference persistence** - "Save globally" option for all yes/no prompts, so preferences survive `/clear` and context compaction
- **Safety guardrails** - Announce destructive actions, atomic commits, never force-push without confirmation
- **Project state management** - Standardized file structure (`STATUS.md`, `CHANGELOG.md`, `_planning/`) to keep CLAUDE.md clean and stable
- **Context preservation** - Auto-save hook that dumps session state before context compaction
- **Token optimization** - Targeted file reads, subagent delegation, no re-reads after edits
- **Code quality** - Auto-lint, treat warnings as errors, co-locate components
- **Git conventions** - Conventional commits, branch naming, no auto-commits
- **Security** - Never commit secrets, auto-check `.gitignore`, flag exposed keys
- **Writing style** - No em dashes, minimal hyphens, concise communication

### Settings (`settings.json`)

- **Bypass permissions mode** with a curated allow/deny list for common CLI tools (npm, git, node, python, cargo, vercel, etc.)
- **Deny list** for dangerous operations (`rm -rf`, `git push --force`, `git reset --hard`, `drop table`)
- **PreCompact hook** that triggers automatic context saving before compaction
- **Status line** showing context window usage percentage and model name (PowerShell)
- **Extended thinking** always enabled

### Slash Commands (`commands/`)

20 commands available as `/command-name` in Claude Code:

| Command | Description |
|---------|-------------|
| `/status` | Review current project status from STATUS.md |
| `/update-status` | Update STATUS.md with current work state |
| `/log` | Add entries to CHANGELOG.md with semver tagging |
| `/backlog` | Review and prioritize the project backlog |
| `/plans` | List and open saved plans from Plan Mode |
| `/init` | Scaffold standard project structure (STATUS.md, CHANGELOG.md, .gitignore, etc.) |
| `/dev` | Launch dev server in a separate terminal, open browser |
| `/deploy` | Deploy to production with pre-flight checks |
| `/pr` | Create a pull request with standardized format |
| `/docs` | Update documentation to match current code state |
| `/cleanup` | Run lint, format, remove unused imports |
| `/remember` | Save a global preference to the right config file |
| `/probe-start` | Launch full 6-agent Socratic analysis of a document |
| `/probe-clarify` | Socratic probe: clarify thinking |
| `/probe-assume` | Socratic probe: challenge assumptions |
| `/probe-evidence` | Socratic probe: examine evidence basis |
| `/probe-pov` | Socratic probe: alternative viewpoints |
| `/probe-implications` | Socratic probe: implications and consequences |
| `/probe-qq` | Socratic probe: question the question |
| `/probe-synthesis` | Synthesize findings from Socratic evaluations |

#### Socratic Probe System

The `/probe-*` commands form a document analysis framework adapted from [ds1/socratic-probes](https://github.com/ds1/socratic-probes). Run `/probe-start <document> <output-dir>` to launch 6 parallel analysis agents that each examine a document through a different critical lens, then synthesize findings into an actionable summary. Useful for evaluating proposals, research docs, vendor comparisons, or any document where you want rigorous critical analysis.

## Installation

### macOS / Linux

```bash
git clone https://github.com/YOUR_USERNAME/boilerplate.md.git
cd boilerplate.md
chmod +x install.sh
./install.sh
```

### Windows (PowerShell)

```powershell
git clone https://github.com/YOUR_USERNAME/boilerplate.md.git
cd boilerplate.md
.\install.ps1
```

### Manual

Copy these into `~/.claude/`:

```
~/.claude/
├── CLAUDE.md         # Copy CLAUDE.md here
├── settings.json     # Copy settings.json here
└── commands/         # Copy all commands/*.md files here
    ├── backlog.md
    ├── cleanup.md
    ├── deploy.md
    ├── ...
    └── update-status.md
```

### Options

| Flag | Description |
|------|-------------|
| `--force` / `-Force` | Overwrite existing files without prompting |

The installer backs up your existing `CLAUDE.md` and `settings.json` (to `.bak` files) before overwriting.

## Customization

### Adding Permissions

The `settings.json` includes common CLI tools pre-approved. Add your own:

```json
"Bash(docker:*)",
"Bash(bun:*)",
"Bash(yarn:*)",
"WebFetch(domain:your-docs-site.com)"
```

Or use `/remember allow docker commands` to add permissions conversationally.

### Changing the Default Stack

Edit the "Default Stack" section in `CLAUDE.md` to match your preferences. The default is Next.js + TypeScript + Tailwind + shadcn/ui + Supabase + Vercel.

### Status Line

The included status line is PowerShell-based (Windows). For bash, replace the `statusLine` in `settings.json`:

```json
"statusLine": {
  "type": "command",
  "command": "echo \"Context: $(echo $CLAUDE_CONTEXT_USED)% | $CLAUDE_MODEL\""
}
```

### Writing Your Own Commands

Add `.md` files to `~/.claude/commands/`. They become available as `/filename` in Claude Code. Use `$ARGUMENTS` in the prompt to accept user input.

## Project Structure Convention

This config encourages a standard structure for every project:

```
project/
├── CLAUDE.md           # Stable: commands, conventions, architecture
├── STATUS.md           # Active: current TODOs, in-progress work, blockers
├── CHANGELOG.md        # History: versioned release notes
└── _planning/          # Planning (optional)
    ├── backlog.md      # Prioritized feature backlog
    ├── sprint.md       # Current sprint scope
    └── plans/          # Saved plans from Plan Mode
```

The key principle: **CLAUDE.md is for stable instructions only.** Anything that changes frequently (TODOs, status, sprint progress) goes in `STATUS.md` or `_planning/`. This keeps context window usage minimal since CLAUDE.md is loaded into every conversation.

## What's NOT Included

These files from `~/.claude/` are excluded because they contain personal or session data:

- `.credentials.json` - OAuth tokens
- `history.jsonl` - Conversation history
- `projects/` - Per-project memory
- `debug/`, `telemetry/`, `statsig/` - Runtime data
- `backups/`, `cache/`, `plans/` - Session state
- `plugins/cache/`, `plugins/marketplaces/` - Plugin runtime data

## Quick Start via boilerplate.md

Visit [boilerplate.md](https://boilerplate.md) for a guided setup experience, shareable links, and easy one-click installation options.

## Contributing

Have an idea for a new configuration, command, or improvement? Contributions are welcome. [Open an issue](https://github.com/ds1/boilerplate.md/issues) to suggest ideas or [submit a pull request](https://github.com/ds1/boilerplate.md/pulls) to contribute directly.

## Credits

Created by [@ds1](https://github.com/ds1). Socratic probe commands adapted from [ds1/socratic-probes](https://github.com/ds1/socratic-probes).

## License

MIT
