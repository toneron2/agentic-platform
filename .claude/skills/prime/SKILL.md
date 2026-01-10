---
name: prime
description: Inject context at session start
allowed-tools:
  - Read
  - Bash
  - Glob
invocation: (internal)
---

# Prime Skill - Context Injection

You are the context primer for the agentic platform. Your role is to efficiently load relevant context at session start without overwhelming the token budget.

## Core Function

At session start:
1. Run `bd prime` for Beads context
2. Scan brain/ for recent activity
3. Check inbox for pending items
4. Load last session state
5. Return condensed context

## Priming Process

### Step 1: Beads Prime

```bash
bd prime
```

This returns ~1-2k tokens of:
- Ready work (unblocked tasks)
- Blocked items (what's blocking)
- Recent activity
- Key dependencies

### Step 2: Brain Scan (Lightweight)

```bash
# Recent activity (last 3 days)
find brain/ -type f -mtime -3 -name "*.md" | head -10

# Inbox count
ls brain/inbox/*.md 2>/dev/null | wc -l

# Due soon (admin)
grep -l "due_date:" brain/admin/*.md 2>/dev/null | head -5
```

### Step 3: Load Session State

```bash
cat state/session.json 2>/dev/null
cat state/last-digest.json 2>/dev/null
```

### Step 4: Compile Context

Return a condensed summary:

```
## Session Context

**Beads State:**
- Ready: N tasks
- Blocked: N tasks
- Recent: [last 3 activities]

**Brain Activity:**
- Recent files: [list of 5 most recent]
- Inbox pending: N items
- Due soon: [items due in 3 days]

**Last Session:**
- Date: [timestamp]
- Captures: N
- Tasks completed: N

**Digest Status:**
- Last digest: [timestamp]
- Last review: [timestamp]
```

## Token Budget

Target: ~500-1000 tokens total

Prioritize:
1. Ready tasks (most actionable)
2. Overdue items (urgent)
3. Recent brain activity (continuity)
4. Session state (context)

Truncate if necessary:
- Max 5 ready tasks shown
- Max 5 recent files
- Max 3 due items

## When to Prime

- **Session start**: Always (via conductor)
- **After long idle**: If session > 30 min without activity
- **Before compaction**: Preserve critical context

## Example Output

```
## Session Context

**Beads State:**
- Ready: 5 tasks
- Blocked: 2 tasks
- Recent: [bd-a3f8] closed 2h ago

**Top Ready:**
1. [bd-b2c1] Review PR #42 (P1)
2. [bd-c3d2] Update docs (P2)
3. [bd-d4e3] Fix login bug (P2)

**Brain Activity:**
- brain/people/tom.md (modified 1h ago)
- brain/projects/api-refactor.md (modified 3h ago)
- Inbox: 2 items pending

**Due Soon:**
- Renew car registration (tomorrow)
- Quarterly report (3 days)

**Last Session:**
- 6 hours ago
- 3 captures, 1 task completed

Ready to work. What's your focus?
```

## Error Handling

| Error | Action |
|-------|--------|
| Beads not initialized | Note it, skip beads context |
| brain/ empty | Note it, suggest first capture |
| state/ missing | Initialize fresh session state |
| bd command fails | Continue with brain-only context |

## Integration

Called by:
- Conductor skill at session start
- Automatically before context compaction events
