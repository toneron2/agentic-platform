# Agentic Platform

**Scaffolding for a long-running project: thoughts captured and filed by an agent, tasks
tracked with dependencies, everything as Markdown in git.**

| | |
|---|---|
| **Status** | v1.0, January 2026. A test, kept public, no further work. |
| **Parts** | 6 Claude Code skills (capture, classify, conductor, digest, prime, review), 5 slash commands, an installer, two guardrail schemes |
| **Task tracker** | [Beads](https://github.com/steveyegge/beads), git-backed |
| **Storage** | Markdown files and git. No service, no database |
| **Licence** | MIT |

A standalone project on this account. The guardrail schemes and the NOEVO rule (skills are
fixed, not self-modifying) are the governance pattern from
[BROAD](https://github.com/toneron2/broad), applied to a personal workflow.

## What it does

| Command | Effect |
|---|---|
| `/capture [thought]` | saves the text immediately, classifies it (person, project, idea, reference), files it under `brain/`, reports the classification and its confidence |
| `/task [title]` | creates a Beads task |
| `/block [id] [id]` | records a dependency |
| `/ready` | lists tasks with no open blockers |
| `/done [id]` | closes a task |
| `/digest` | the day's top actions, people to follow up, open loops |
| `/review` | weekly analysis: what moved, what is stuck |
| `/sync` | commits everything to git |

The working rules: capture without editing, keep tasks small, record dependencies so
"ready" means ready, review daily and weekly.

## Installation

Requires Claude Code, git, Python 3.8+, and Go for the Beads CLI
(`go install github.com/steveyegge/beads/cmd/bd@latest`).

```bash
git clone https://github.com/toneron2/agentic-platform.git && cd agentic-platform
./install.sh my-project      # creates the directory tree, copies skills and commands, initialises git and Beads
cd my-project && claude
```

[`GETTING_STARTED.md`](GETTING_STARTED.md) is the manual walkthrough. Categories are added
in `.claude/skills/classify/SKILL.md`, commands as files in `.claude/commands/`, rules in
`governance/guardrails/*.logic`.

## Sources

Beads (Steve Yegge), Brain2 (Slack and Notion automation patterns, adapted to local files; the original no-code build guide is [`docs/brain2-second-brain-build-guide.md`](docs/brain2-second-brain-build-guide.md)),
and BROAD's EVO/NOEVO hierarchy.

## Contact

Tony Slosar · TODOMODO.IO AGENCY LLC · anthonyslosar@gmail.com · [t.me/toneron2](https://t.me/toneron2) · [slosars.me](https://slosars.me)
