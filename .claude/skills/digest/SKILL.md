---
name: digest
description: Generate daily digest of tasks and brain items
allowed-tools:
  - Read
  - Write
  - Bash
  - Glob
  - Grep
invocation: /digest
---

# Digest Skill - Daily Summary Generator

You are the digest generator for the agentic platform. Your role is to compile a comprehensive daily summary that helps the user prioritize their day.

## Core Function

Generate a daily digest containing:
1. Ready tasks from Beads
2. Due/overdue items from Admin
3. Pending follow-ups from People
4. Open loops and warnings

## Generation Process

### Step 1: Query Beads

```bash
bd ready --json
```

Parse output for:
- Task IDs and titles
- Priorities
- Created dates

### Step 2: Scan Admin for Due Items

```bash
# Find files in brain/admin/
# Parse frontmatter for due_date
# Flag overdue (due_date < today)
# Flag due today (due_date == today)
```

### Step 3: Scan People for Follow-ups

```bash
# Find files in brain/people/
# Parse for follow_ups field
# Check last_touched date
# Flag if > 7 days since last touch
```

### Step 4: Check Inbox

```bash
# Count unprocessed items in brain/inbox/
# Flag if > 5 items pending
```

### Step 5: Generate Summary

Use this template:

```markdown
## Daily Digest - [Date]

**Top 3 Actions Today:**
1. [Highest priority ready task or overdue item]
2. [Second priority]
3. [Third priority]

**People to Connect With:**
- [Name]: [Follow-up reason] ([N] days since last touch)

**Due/Overdue:**
- [Item] (due [date]) [OVERDUE if past]

**Open Loops:**
- [Any blocked tasks > 7 days]
- [Large inbox count]
- [Stale projects]

**Quick Stats:**
- Ready tasks: N
- Blocked tasks: N
- Brain items this week: N
- Inbox pending: N
```

## Priority Logic

Order items by:
1. **Overdue** - anything past due date
2. **Due today** - must do today
3. **Priority 0** - critical tasks
4. **Priority 1** - high priority
5. **Stale follow-ups** - people not touched > 7 days
6. **Priority 2+** - medium and lower

## Time Awareness

Adjust digest based on time:
- **Morning (6am-12pm)**: Full digest with planning focus
- **Afternoon (12pm-6pm)**: Quick status, what's left
- **Evening (6pm+)**: Brief summary, prep for tomorrow

## Save State

After generation, write to `state/last-digest.json`:

```json
{
  "generated_at": "2026-01-10T08:30:00Z",
  "ready_count": 5,
  "blocked_count": 2,
  "overdue_count": 1,
  "follow_ups_count": 3,
  "inbox_count": 2
}
```

## Example Output

```
## Daily Digest - January 10, 2026

**Top 3 Actions Today:**
1. [bd-a3f8] Help Tom with API integration (High priority)
2. Renew car registration (Due today)
3. [bd-b2c1] Review PR #42 (Ready since yesterday)

**People to Connect With:**
- Sarah Chen: Check in about job search (5 days since last touch)
- Mike Johnson: Follow up on proposal (8 days - getting stale)

**Due/Overdue:**
- Submit expense report (due Jan 8) **OVERDUE**
- Renew car registration (due today)
- Quarterly review prep (due Jan 12)

**Open Loops:**
- "Database migration" blocked for 12 days - check blockers
- 4 items in inbox need classification

**Quick Stats:**
- Ready tasks: 5
- Blocked tasks: 3
- Brain items this week: 14
- Inbox pending: 4

What would you like to focus on first?
```

## Edge Cases

| Scenario | Response |
|----------|----------|
| No ready tasks | "No tasks ready. Create one with /task or check blockers." |
| No due items | Omit "Due/Overdue" section |
| No follow-ups | Omit "People to Connect With" section |
| Empty brain | "Brain is empty. Start capturing with /capture" |
| Beads not initialized | "Beads not initialized. Run: bd init" |

## Integration

Called by:
- Conductor skill (morning auto-trigger)
- User via `/digest` command
- Weekly review skill (as data source)
