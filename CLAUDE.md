# Agentic Platform - Claude Code Context

## Project Overview

**Purpose**: Long-running project orchestration with day-to-day thought capture, operated agentically.

**Architecture**: Beads (task tracking) + Brain2 (knowledge capture) + BROAD governance patterns

---

## Quick Reference

### Capture a Thought
```
/capture [your thought here]
```
The system will classify and route to People/Projects/Ideas/Admin.

### Check Ready Work
```
/ready
```
Shows unblocked Beads tasks ready for action.

### Create a Task
```
/task [title]
```
Creates a Beads task with hash-based ID.

### Sync State
```
/sync
```
Exports to JSONL, commits, pushes. Auto-runs on session end.

### Generate Digest
```
/digest
```
Generates daily summary of tasks and brain items.

---

## Directory Structure

```
brain2/
├── .beads/              # Beads issue tracker (git-backed JSONL)
├── .claude/
│   ├── skills/          # Agentic expertise encoding
│   ├── commands/        # Slash commands
│   └── hooks/           # Event handlers
├── brain/               # Brain2 knowledge base
│   ├── inbox/           # Uncategorized captures
│   ├── people/          # Relationship notes
│   ├── projects/        # Project context
│   ├── ideas/           # Concepts to explore
│   └── admin/           # Tasks with dates
├── governance/          # Guardrails (.logic files)
├── state/               # Session state (JSON)
└── schemas/             # Validation schemas
```

---

## Skills Architecture

### Conductor (Master Orchestrator)
- **Invocation**: `/orchestrate` or automatic on session start
- **Role**: Coordinates all other skills, manages session lifecycle
- **Responsibilities**:
  - Morning: Prime context, generate digest
  - During: Route captures, track tasks
  - End: Auto-sync via hook

### Capture Skills
| Skill | Purpose | Invocation |
|-------|---------|------------|
| capture | Write to inbox | `/capture` |
| classify | AI categorization | (internal) |
| route | Move to destination | (internal) |

### Project Skills (via Beads)
| Command | Beads Operation |
|---------|-----------------|
| `/ready` | `bd ready` |
| `/task [title]` | `bd create "title" -t task` |
| `/done [id]` | `bd close [id]` |
| `/sync` | `bd sync` |

### Digest Skills
| Skill | Purpose | Invocation |
|-------|---------|------------|
| digest | Daily summary | `/digest` |
| review | Weekly review | `/review` |
| prime | Context injection | (automatic) |

---

## Brain2 Categories

| Category | Directory | When to Use |
|----------|-----------|-------------|
| People | `brain/people/` | Info about a person, relationship update |
| Projects | `brain/projects/` | Multi-step work, ongoing efforts |
| Ideas | `brain/ideas/` | Concepts, insights, things to explore |
| Admin | `brain/admin/` | Errands, tasks with due dates |

### Capture Classification
The classify skill returns:
```json
{
  "destination": "people|projects|ideas|admin|needs_review",
  "confidence": 0.85,
  "data": {
    "name": "Extracted title",
    "context": "Additional details",
    ...
  }
}
```
- Confidence > 0.6 → auto-route
- Confidence <= 0.6 → needs_review, ask user

---

## Beads Integration

This platform uses [Beads](https://github.com/steveyegge/beads) for task tracking.

### Key Concepts
- **Hash-based IDs**: `bd-a3f8` format prevents merge conflicts
- **Dependencies**: `bd dep add child parent` - child blocked by parent
- **Ready work**: `bd ready` shows unblocked tasks
- **JSONL storage**: Git-friendly, merge-safe

### Auto-behaviors
- **Session start**: `bd prime` injects context (~1-2k tokens)
- **Session end**: `bd sync` commits and pushes
- **Project capture**: Auto-creates Beads task if actionable

---

## Governance

### Guardrails (Deontic Logic)
- **Scheme-0**: Absolute safety - never bypass
- **Scheme-1**: Operational bounds - session rules

### Key Constraints
```logic
F(delete_without_confirmation)    # Forbidden: delete without confirm
O(sync_before_session_end)        # Obligated: sync at end
O(classify_before_route)          # Obligated: classify first
```

---

## Session Lifecycle

```
Session Start
    ↓
[Hook: SessionStart]
    ↓
Prime Context (bd prime + brain/ scan)
    ↓
Daily Digest (if morning)
    ↓
User Commands (captures, tasks, code)
    ↓
[Hook: SessionEnd]
    ↓
Auto-Sync (bd sync + state save)
```

---

## Development Guidelines

### Adding a New Skill
1. Create `.claude/skills/[name]/SKILL.md`
2. Define YAML frontmatter (name, description, allowed-tools, invocation)
3. Write expertise in markdown body
4. Test via invocation command

### Adding a New Command
1. Create `.claude/commands/[name].md`
2. Define behavior and parameters
3. Reference skills to invoke

### Modifying Guardrails
1. Edit `governance/guardrails/scheme-N.logic`
2. Use deontic operators: O() P() F()
3. Test constraint enforcement

---

## File Naming Conventions

| Type | Pattern | Example |
|------|---------|---------|
| Inbox capture | `YYYY-MM-DD-HHMMSS.md` | `2026-01-10-143052.md` |
| Person file | `[firstname-lastname].md` | `sarah-chen.md` |
| Project file | `[project-slug].md` | `api-refactor.md` |
| Idea file | `[idea-slug].md` | `dark-mode-toggle.md` |
| Admin file | `[task-slug].md` | `renew-car-registration.md` |

---

## Dependencies

- **Claude Code CLI**: This tool
- **Git**: Version control for .beads/ and brain/
- **bd CLI**: `go install github.com/steveyegge/beads/cmd/bd@latest`
- **uv**: Python package manager for hooks

---

## Quick Troubleshooting

| Issue | Solution |
|-------|----------|
| `bd` command not found | Install: `go install github.com/steveyegge/beads/cmd/bd@latest` |
| Sync failed | Run `bd doctor --fix` |
| Classification wrong | Reply with correction context |
| Hook not firing | Check `.claude/settings.json` hook config |

---

**Last Updated**: 2026-01-10
**Status**: Initial Scaffolding
