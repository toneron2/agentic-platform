---
name: ready
description: Show unblocked Beads tasks ready for work
arguments: []
---

# /ready Command

Shows all Beads tasks that have no blocking dependencies and are ready to work on.

## Usage

```
/ready
```

## Behavior

1. Runs `bd ready --json`
2. Parses the JSON output
3. Formats as readable list with priorities

## Output Format

```
Ready Work (N tasks):

1. [bd-a3f8] High priority task title
   Priority: 1 | Type: task

2. [bd-b2c1] Another ready task
   Priority: 2 | Type: feature

3. [bd-c3d2] Lower priority item
   Priority: 3 | Type: chore
```

## No Ready Tasks

If no tasks are ready:
```
No tasks ready.

This could mean:
- All tasks have blockers
- No open tasks exist
- Run /task to create one
```

## Related Commands

- `/task [title]` - Create a new task
- `/done [id]` - Mark a task as done
- `/sync` - Sync Beads state
