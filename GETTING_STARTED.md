# Getting Started with the Agentic Platform

Welcome! This guide will help you set up your first agentic project in about 10 minutes.

---

## What This Is

An **agentic platform** for managing long-running projects using AI. Think of it as:

- **A second brain** that captures and organizes your thoughts
- **A task tracker** (Beads) with dependencies and priorities
- **An AI assistant** that helps you stay on top of everything
- **All running locally** in your terminal with Claude Code

---

## Prerequisites

Before starting, you need:

### Required

| Tool | Purpose | Install |
|------|---------|---------|
| **Claude Code** | AI assistant CLI | [docs.anthropic.com](https://docs.anthropic.com/en/docs/claude-code) |
| **Claude Max** | API access | Anthropic subscription |
| **Git** | Version control | Your package manager |
| **Python 3.8+** | Hooks & automation | Your package manager |

### Recommended

| Tool | Purpose | Install |
|------|---------|---------|
| **Go** | For installing Beads | [go.dev/doc/install](https://go.dev/doc/install) |
| **Beads CLI** | Task tracking | `go install github.com/steveyegge/beads/cmd/bd@latest` |

---

## Installation

### Option 1: Clone and Run (Recommended)

```bash
# Clone the template
git clone https://github.com/YOUR_USERNAME/agentic-platform.git

# Run the installer
cd agentic-platform
./install.sh my-dream-project
```

### Option 2: Manual Setup

```bash
# Create project directory
mkdir my-project && cd my-project

# Clone into .template and copy
git clone https://github.com/YOUR_USERNAME/agentic-platform.git .template
cp -r .template/.claude .
cp -r .template/brain .
cp -r .template/governance .
cp -r .template/schemas .
cp .template/.gitignore .
rm -rf .template

# Initialize
git init
bd init
```

---

## First Run Walkthrough

### 1. Start Claude Code

```bash
cd my-project
claude
```

You should see Claude Code's interface. The skills and commands are now available.

### 2. Capture Your First Thought

```
/capture I want to build an app that helps people track their reading habits
```

Claude will:
1. Save this to `brain/inbox/`
2. Classify it (probably as "ideas" or "projects")
3. Route it to the right folder
4. Tell you what it did

**Example response:**
```
Filed to Ideas: Reading habit tracker app
Confidence: 0.88
```

### 3. Create Your First Task

```
/task Research existing reading tracker apps
```

This creates a Beads task with a unique ID like `bd-a3f8`.

### 4. Check What's Ready

```
/ready
```

Shows all unblocked tasks ready for work.

### 5. Generate Your First Digest

```
/digest
```

Creates a summary of:
- Ready tasks
- Due items
- People to follow up with
- Open loops

---

## Daily Workflow

Here's how a typical day might look:

### Morning

```bash
claude
# Claude shows your daily digest automatically (if it's morning)
```

Or manually:
```
/digest
```

### Throughout the Day

**Capture thoughts as they come:**
```
/capture Met Sarah for coffee - she's working on a similar problem
/capture idea: what if the app gamified reading streaks?
/capture Need to renew library card by Friday
```

**Work on tasks:**
```
/ready                    # See what's available
/task Write user stories  # Create new tasks
/done bd-a3f8             # Complete tasks
```

### End of Day

Just exit Claude Code - the session hook automatically syncs your work:
- Beads tasks saved to git
- Session state preserved
- Ready for tomorrow

---

## Understanding the Brain

Your knowledge is organized into four categories:

### People (`brain/people/`)
Notes about people you interact with.

```
/capture Tom mentioned he's an expert in mobile UX
```
→ Creates/updates `brain/people/tom.md`

### Projects (`brain/projects/`)
Multi-step work efforts.

```
/capture project: Reading tracker MVP - need to define core features
```
→ Creates `brain/projects/reading-tracker-mvp.md` + Beads task

### Ideas (`brain/ideas/`)
Thoughts to explore later.

```
/capture idea: What if we partnered with local libraries?
```
→ Creates `brain/ideas/library-partnership.md`

### Admin (`brain/admin/`)
Tasks with due dates.

```
/capture Renew domain registration by Jan 20
```
→ Creates `brain/admin/renew-domain.md` + Beads task with due date

---

## Understanding Beads

[Beads](https://github.com/steveyegge/beads) is a git-backed task tracker designed for AI agents.

### Key Commands

| Command | Description |
|---------|-------------|
| `/ready` | Tasks with no blockers |
| `/task [title]` | Create a task |
| `/done [id]` | Complete a task |
| `/sync` | Save to git |

### Dependencies

Tasks can block each other:

```
/task Design the database schema
# Returns: bd-a1b2

/task Build the API endpoints
# Returns: bd-c3d4

# Make API depend on schema
/block bd-c3d4 bd-a1b2
```

Now `bd-c3d4` won't show in `/ready` until `bd-a1b2` is done.

### Why Beads?

- **Git-backed**: Your tasks are version controlled
- **Merge-safe**: Hash-based IDs prevent conflicts
- **AI-native**: Designed for agent workflows
- **Dependency-aware**: Knows what's truly ready

---

## Weekly Review

Every Sunday (or whenever you want):

```
/review
```

Generates a comprehensive analysis:
- What moved forward this week
- What's stuck
- Patterns in your work
- Suggested focus for next week

---

## Tips for Success

### 1. Capture Liberally

Don't overthink it. Capture everything. The AI will classify it.

```
/capture Random thought about the project
```

Better to capture and classify later than to lose the thought.

### 2. Use Prefixes for Speed

If you know the category:
```
/capture person: met Jake at the conference
/capture project: MVP needs user authentication
/capture idea: what about a Chrome extension?
/capture admin: file taxes by April 15
```

### 3. Review Your Inbox

Periodically check `brain/inbox/` for items that weren't auto-classified:
```
ls brain/inbox/
```

### 4. Trust the Sync

The system auto-syncs on session end. But if you're paranoid:
```
/sync
```

### 5. Keep Tasks Atomic

Bad: "Build the app"
Good: "Write user authentication flow"

Smaller tasks = more satisfying progress.

---

## Troubleshooting

### "bd command not found"

Install Beads:
```bash
go install github.com/steveyegge/beads/cmd/bd@latest
```

Make sure `$GOPATH/bin` is in your PATH.

### "Classification confidence low"

The AI wasn't sure. It kept the item in `brain/inbox/`. You can:
1. Resubmit with a prefix: `/capture project: [your thought]`
2. Manually move the file

### "Sync failed"

Run diagnostics:
```bash
bd doctor --fix
```

Common fixes:
- Network issues: retry later
- Git conflicts: resolve manually
- Auth expired: re-authenticate

### Hooks Not Running

Check that Python hooks are executable:
```bash
chmod +x .claude/hooks/*.py
```

---

## Customization

### Change Categories

Edit the classification prompt in `.claude/skills/classify/SKILL.md`.

### Add New Commands

Create a new file in `.claude/commands/your-command.md`.

### Modify Guardrails

Edit `.logic` files in `governance/guardrails/`.

### Add Skills

Create a new folder in `.claude/skills/your-skill/SKILL.md`.

---

## Philosophy

This platform is built on a few key principles:

1. **Capture first, organize later** - Never lose a thought
2. **AI handles the boring parts** - Classification, routing, summarization
3. **You stay in control** - Everything is local markdown and git
4. **Small pieces, loosely joined** - Skills, commands, and hooks are modular
5. **Trust but verify** - Guardrails prevent dangerous operations

---

## Next Steps

1. Spend a week just capturing without worrying about organization
2. Use `/digest` every morning to review
3. Do your first `/review` on Sunday
4. Customize categories if the defaults don't fit

You're ready. Go build something amazing.

---

## Getting Help

- **Claude Code docs**: [docs.anthropic.com](https://docs.anthropic.com/en/docs/claude-code)
- **Beads docs**: [github.com/steveyegge/beads](https://github.com/steveyegge/beads)
- **This repo**: [issues and discussions]

---

*Happy building!*
