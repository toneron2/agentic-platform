# Agentic Platform

**Turn your ideas into reality with AI-powered project management.**

A scaffolding for long-running projects that combines:
- **Thought capture** → Quickly save ideas, they get organized automatically
- **Task tracking** → Dependencies, priorities, and what's actually ready
- **AI orchestration** → Claude handles the boring parts
- **Local-first** → Everything is markdown and git, you own your data

Built for ambitious people who want to ship their dream projects.

---

## Quick Start

```bash
# Clone
git clone https://github.com/YOUR_USERNAME/agentic-platform.git
cd agentic-platform

# Create your project
./install.sh my-startup

# Start working
cd my-startup
claude

# Capture your first thought
/capture I want to build an app that solves X problem
```

**That's it.** Claude will classify your thought, file it, and you're off.

---

## What You Get

```
my-project/
├── brain/               # Your knowledge base
│   ├── inbox/           # Quick captures land here
│   ├── people/          # Relationship notes
│   ├── projects/        # Active work
│   ├── ideas/           # Things to explore
│   └── admin/           # Tasks with dates
├── .beads/              # Task tracking (git-backed)
├── .claude/             # AI configuration
│   ├── skills/          # What the AI knows how to do
│   ├── commands/        # /capture, /ready, /digest, etc.
│   └── hooks/           # Automation (auto-sync, logging)
└── governance/          # Safety guardrails
```

---

## Commands

| Command | What it does |
|---------|--------------|
| `/capture [thought]` | Save and auto-classify a thought |
| `/ready` | Show tasks you can work on right now |
| `/task [title]` | Create a new task |
| `/done [id]` | Mark a task complete |
| `/digest` | Get your daily summary |
| `/review` | Weekly analysis and recommendations |
| `/sync` | Save everything to git |

---

## How It Works

### 1. Capture Thoughts

```
/capture Sarah mentioned she knows a great designer
```

The AI:
1. Saves immediately (never lose data)
2. Classifies: "This is about a person"
3. Routes to `brain/people/sarah.md`
4. Confirms: "Filed to People: Sarah (confidence: 0.92)"

### 2. Track Tasks

Tasks live in [Beads](https://github.com/steveyegge/beads), a git-backed tracker:

```
/task Design the landing page
# Created: bd-a3f8

/task Write the copy
# Created: bd-b2c1

/block bd-b2c1 bd-a3f8    # Copy blocked by design
```

Now `/ready` only shows tasks that are actually unblocked.

### 3. Stay on Top

Every morning:
```
/digest
```

```
Daily Digest - January 10, 2026

Top 3 Actions:
1. [bd-a3f8] Design the landing page (High)
2. Call accountant (Due today)
3. [bd-c3d2] Review competitor apps

People to follow up:
- Sarah: Connect about designer (5 days)

Open Loops:
- 3 items in inbox need classification
```

### 4. Weekly Review

```
/review
```

Get a deep analysis of what moved, what's stuck, and where to focus.

---

## Requirements

| Tool | Required | Install |
|------|----------|---------|
| Claude Code | Yes | [docs.anthropic.com](https://docs.anthropic.com/en/docs/claude-code) |
| Claude Max | Yes | Anthropic subscription |
| Git | Yes | Package manager |
| Python 3.8+ | Yes | Package manager |
| Go | For Beads | [go.dev](https://go.dev/doc/install) |
| Beads CLI | Recommended | `go install github.com/steveyegge/beads/cmd/bd@latest` |

---

## Installation

### New Project

```bash
./install.sh my-project-name
```

The installer will:
1. Check dependencies
2. Create the directory structure
3. Copy all skills and commands
4. Initialize git and Beads
5. Get you ready to work

### Manual Setup

See [GETTING_STARTED.md](./GETTING_STARTED.md) for step-by-step instructions.

---

## Philosophy

1. **Capture liberally** → Don't overthink, just capture. AI classifies.
2. **Small tasks** → "Write auth flow" not "Build the app"
3. **Dependencies matter** → Know what's truly ready vs. blocked
4. **Review regularly** → Daily digest, weekly review
5. **Local first** → Markdown + git = you own everything

---

## Customization

### Add Categories

Edit `.claude/skills/classify/SKILL.md` to add new brain categories.

### New Commands

Add a file to `.claude/commands/your-command.md`.

### New Skills

Create `.claude/skills/your-skill/SKILL.md` with expertise.

### Guardrails

Modify `governance/guardrails/*.logic` for safety rules.

---

## Architecture

Based on patterns from:
- **[Beads](https://github.com/steveyegge/beads)** - Steve Yegge's git-backed issue tracker for AI agents
- **Brain2** - Slack/Notion automation patterns adapted for local-first
- **BROAD** - Enterprise governance patterns (EVO/NOEVO hierarchy)

All skills are **NOEVO** (non-evolutionary) - fixed, predictable behavior you can trust.

---

## Documentation

- [GETTING_STARTED.md](./GETTING_STARTED.md) - Detailed walkthrough for new users
- [CLAUDE.md](./CLAUDE.md) - Context file for Claude Code
- [governance/specs/agent-hierarchy.md](./governance/specs/agent-hierarchy.md) - How skills work together

---

## License

MIT - Use it, modify it, build something great.

---

## Contributing

1. Fork it
2. Create your feature branch
3. Make your changes
4. Submit a PR

Ideas welcome in Issues.

---

**Built for builders. Go ship something.**
