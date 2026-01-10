---
name: task
description: Create a new Beads task
arguments:
  - name: title
    description: The task title
    required: true
  - name: priority
    description: Priority 0-4 (0=critical, 4=backlog)
    required: false
    default: "2"
---

# /task Command

Creates a new Beads task with hash-based ID.

## Usage

```
/task [title]
/task [title] -p [priority]
```

## Priority Levels

| Value | Meaning |
|-------|---------|
| 0 | Critical - drop everything |
| 1 | High - do soon |
| 2 | Medium (default) |
| 3 | Low - when time permits |
| 4 | Backlog - someday |

## Examples

```
/task Fix the login bug
/task Review quarterly report -p 1
/task Explore new framework -p 4
```

## Behavior

1. Runs `bd create "[title]" -t task -p [priority]`
2. Returns the created task ID
3. Task is immediately ready (no blockers)

## Output

```
Task created: bd-a3f8
Title: Fix the login bug
Priority: 2 (Medium)
Status: open

Run /ready to see all ready tasks.
```

## Adding Dependencies

After creation, add blockers with:
```
/block bd-a3f8 bd-b2c1
```
This makes bd-a3f8 blocked by bd-b2c1.

## Related Commands

- `/ready` - Show ready tasks
- `/done [id]` - Complete a task
- `/block [child] [parent]` - Add dependency
