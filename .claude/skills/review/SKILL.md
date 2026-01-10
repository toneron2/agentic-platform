---
name: review
description: Generate weekly review with patterns and recommendations
allowed-tools:
  - Read
  - Write
  - Bash
  - Glob
  - Grep
invocation: /review
---

# Review Skill - Weekly Analysis

You are the weekly review generator for the agentic platform. Your role is to provide deeper analysis of progress, patterns, and recommendations for the coming week.

## Core Function

Generate a comprehensive weekly review containing:
1. Progress summary (what moved forward)
2. Closed tasks analysis
3. Open loops and concerns
4. Pattern detection
5. Recommendations for next week

## Generation Process

### Step 1: Query Closed Tasks

```bash
bd list --status closed --since 7d --json
```

### Step 2: Query All Open Tasks

```bash
bd list --status open --json
bd list --status blocked --json
```

### Step 3: Scan Brain for Activity

```bash
# Find files modified in last 7 days
find brain/ -type f -mtime -7 -name "*.md"

# Count by category
# Identify most active areas
```

### Step 4: Analyze Patterns

Look for:
- Categories with high activity
- Recurring themes in captures
- Tasks that have been blocked too long
- People not contacted in a while
- Ideas that might connect to projects

### Step 5: Generate Review

Use this template:

```markdown
## Weekly Review - Week of [Date]

**Quick Stats:**
- Items captured: N
- Tasks completed: N
- Tasks created: N
- Categories: N people, N projects, N ideas, N admin

**What Moved Forward:**
- [Completed task/project with context]
- [Progress on ongoing work]
- [Wins to celebrate]

**Open Loops (Needs Attention):**
1. [Blocked task > 7 days] - Consider: [suggestion]
2. [Overdue item] - Action needed
3. [Stale project] - Review or archive?

**Patterns I Notice:**
[Observation about where energy is going]
[Theme in captures this week]
[Potential concern or opportunity]

**Suggested Focus for Next Week:**
1. [Specific action for highest priority]
2. [Second priority]
3. [Third priority]

**Items Needing Review:**
- [Inbox items still pending]
- [Low-confidence classifications]
```

## Pattern Detection

### Activity Patterns
- High capture volume → busy week, check for overwhelm
- Low capture volume → quiet week or forgetting to capture
- Spike in admin → operational mode
- Spike in ideas → creative mode

### Staleness Detection
- Projects not touched > 14 days → possibly stuck or abandoned
- People not contacted > 30 days → relationship maintenance needed
- Tasks blocked > 7 days → blocker may need escalation

### Theme Detection
- Multiple captures mentioning same topic → emerging priority
- Repeated admin tasks → potential for automation
- Connected ideas → possible project formation

## Recommendations Logic

Base suggestions on:
1. **Overdue items** → Clear the backlog first
2. **Long-blocked tasks** → Resolve blockers
3. **Stale relationships** → Reconnect with people
4. **Unprocessed inbox** → Classification session
5. **Connected ideas** → Synthesis opportunity

## Example Output

```
## Weekly Review - Week of January 6, 2026

**Quick Stats:**
- Items captured: 18
- Tasks completed: 7
- Tasks created: 5
- Categories: 4 people, 8 projects, 3 ideas, 3 admin

**What Moved Forward:**
- Completed API integration with Tom's help
- Shipped PR #42 (performance improvements)
- Cleared 3 overdue admin tasks
- Had productive conversation with Sarah about her job search

**Open Loops (Needs Attention):**
1. "Database migration" blocked for 12 days
   - Blocker: waiting on DevOps approval
   - Consider: Escalate or find workaround

2. Quarterly report still pending (due Jan 12)
   - 2 days left, substantial work remaining
   - Consider: Block time tomorrow

3. 4 items in inbox unclassified
   - Consider: Quick classification session

**Patterns I Notice:**
- Heavy focus on API work this week (5 related captures)
- Less attention to personal admin than usual
- Two ideas about mobile app improvements - potential project?

**Suggested Focus for Next Week:**
1. Complete quarterly report (deadline Jan 12)
2. Escalate database migration blocker
3. Process inbox backlog
4. Consider: Consolidate mobile app ideas into project

**Items Needing Review:**
- 4 inbox items pending classification
- 1 low-confidence classification (needs clarification)

Overall: Productive week with good task completion. Watch the
report deadline and blocked migration.
```

## Timing

Weekly review is ideally run:
- Sunday afternoon/evening (prep for week)
- Monday morning (fresh start planning)

Can be invoked anytime with `/review`.

## Save State

After generation, update `state/last-digest.json`:

```json
{
  "last_weekly_review": "2026-01-10T16:00:00Z",
  "week_summary": {
    "captures": 18,
    "completed": 7,
    "created": 5
  }
}
```

## Integration

Called by:
- Conductor skill (Sunday auto-trigger)
- User via `/review` command
