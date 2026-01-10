---
name: digest
description: Generate daily digest of tasks and brain items
arguments: []
---

# /digest Command

Generates a summary of ready tasks, due items, and follow-ups.

## Usage

```
/digest
```

## Behavior

1. Queries Beads for ready tasks
2. Scans `brain/admin/` for due items
3. Scans `brain/people/` for pending follow-ups
4. Generates AI summary
5. Saves to `state/last-digest.json`

## Output Format

```
Daily Digest - January 10, 2026

**Top 3 Actions Today:**
1. [bd-a3f8] Help Tom with API integration
2. [bd-b2c1] Review PR #42
3. Renew car registration (due today)

**People to Connect With:**
- Sarah Chen: Job search check-in (5 days since last touch)

**Due/Overdue:**
- Renew car registration (due today)
- Submit expense report (2 days overdue)

**Open Loops:**
- API refactor has been blocked for 7 days
- 3 items in inbox need classification

**Quick Stats:**
- Ready tasks: 5
- Blocked tasks: 2
- Brain items this week: 12
```

## Auto-Trigger

Daily digest runs automatically:
- On morning session start (before noon)
- Can be invoked manually anytime

## Customization

The digest prioritizes:
1. Overdue items
2. Due today items
3. High priority tasks
4. Stale follow-ups (>7 days)

## Related Commands

- `/review` - Weekly review (more comprehensive)
- `/ready` - Just show ready tasks
- `/capture` - Add new items
