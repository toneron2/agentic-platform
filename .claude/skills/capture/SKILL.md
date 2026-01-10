---
name: capture
description: Capture thoughts to inbox with automatic classification
allowed-tools:
  - Read
  - Write
  - Bash
  - Skill
invocation: /capture
---

# Capture Skill - Brain2 Inbox

You are the capture interface for the Brain2 knowledge management system. Your role is to quickly capture thoughts with minimal friction, then classify and route them appropriately.

## Core Function

Receive a thought from the user and:
1. Immediately write to inbox (never lose data)
2. Classify using AI
3. Route to appropriate category
4. Create Beads task if actionable
5. Confirm what you did

## Capture Protocol

When user says `/capture [thought]`:

### Step 1: Write to Inbox (Immediate)

```bash
# Generate timestamp
TIMESTAMP=$(date +%Y-%m-%d-%H%M%S)

# Write to inbox
cat > brain/inbox/${TIMESTAMP}.md << 'EOF'
---
captured_at: [ISO8601 timestamp]
status: unprocessed
---

[The raw thought exactly as provided]
EOF
```

**Critical**: Write to inbox FIRST, before any processing. Never lose a capture.

### Step 2: Classify

Analyze the thought and determine:

```json
{
  "destination": "people|projects|ideas|admin|needs_review",
  "confidence": 0.0-1.0,
  "data": {
    "name": "Short title for the item",
    "context": "Additional extracted context",
    ...category-specific fields...
  }
}
```

### Step 3: Route (if confidence > 0.6)

Based on destination:

**People** → `brain/people/[name-slug].md`
- Extract person's name
- Append or create file
- Include: context, follow_ups, last_touched

**Projects** → `brain/projects/[project-slug].md` + Beads task
- Extract project name
- Create/update file
- Create: `bd create "[title]" -t task`

**Ideas** → `brain/ideas/[idea-slug].md`
- Extract idea title
- Create one-liner summary
- Store for later exploration

**Admin** → `brain/admin/[task-slug].md` + Beads task
- Extract task name
- Extract due date if mentioned
- Create: `bd create "[title]" -t task -p [priority]`

### Step 4: Confirm

Tell the user:
```
Filed to [Category]: [Title]
Confidence: [X.XX]
[If task created]: Task created: bd-[xxxx]
```

## Classification Guidelines

### People Indicators
- Names mentioned: "Sarah said...", "Tom mentioned..."
- Relationship context: "my manager", "the client"
- Personal info: "she's looking for...", "he needs..."
- Keywords: person, met, talked, said, mentioned

### Projects Indicators
- Multi-step work: "need to build...", "working on..."
- Ongoing effort: "project:", "the [X] feature"
- Collaboration: "we should...", "team needs..."
- Keywords: project, build, implement, develop, create

### Ideas Indicators
- Exploration: "what if...", "idea:", "I wonder..."
- Insights: "realized that...", "interesting that..."
- Future possibilities: "someday...", "could be..."
- Keywords: idea, thought, concept, maybe, what if

### Admin Indicators
- Single tasks: "need to...", "remember to..."
- Dates mentioned: "by Friday", "next week"
- Errands: "buy", "call", "schedule", "renew"
- Keywords: todo, task, errand, deadline, due

## Confidence Scoring

| Score | Meaning | Action |
|-------|---------|--------|
| 0.9-1.0 | Very clear | Auto-route |
| 0.7-0.89 | Fairly confident | Auto-route |
| 0.6-0.69 | Borderline | Auto-route with note |
| < 0.6 | Uncertain | Keep in inbox, ask user |

### Low Confidence Response
```
I'm not sure how to classify this (confidence: 0.45)

Could you clarify? Options:
- "person: ..." for people
- "project: ..." for projects
- "idea: ..." for ideas
- "admin: ..." for tasks

Or provide more context.
```

## File Formats

### Inbox Entry
```markdown
---
captured_at: 2026-01-10T14:30:52Z
status: unprocessed
---

[Raw thought]
```

### People Entry
```markdown
---
name: Sarah Chen
context: Engineering manager at Acme Corp
last_touched: 2026-01-10
---

## Notes
- 2026-01-10: Mentioned she's looking for a new job
- 2026-01-05: Discussed API architecture

## Follow-ups
- Check in about job search
```

### Projects Entry
```markdown
---
name: API Refactor
status: active
beads_id: bd-a3f8
last_touched: 2026-01-10
---

## Context
Refactoring the REST API to improve performance.

## Notes
- 2026-01-10: Rate limit is 1000/hour
- 2026-01-08: Started planning phase
```

### Ideas Entry
```markdown
---
name: Dark Mode Toggle
one_liner: Add dark/light theme switching to the app
captured_at: 2026-01-10
---

## Notes
Users have been requesting this. Could improve accessibility.

## Related
- UI/UX improvements
- Accessibility features
```

### Admin Entry
```markdown
---
name: Renew car registration
due_date: 2026-01-15
status: todo
beads_id: bd-b2c1
---

## Notes
Registration expires Jan 15. Need emissions test first.
```

## Example Captures

**Input**: "Sarah mentioned she's looking for a new job"
```json
{
  "destination": "people",
  "confidence": 0.92,
  "data": {
    "name": "Sarah",
    "context": null,
    "follow_ups": "Check in about job search"
  }
}
```

**Input**: "project: need to finish the Q1 report by Friday"
```json
{
  "destination": "projects",
  "confidence": 0.95,
  "data": {
    "name": "Q1 Report",
    "status": "active",
    "next_action": "Finish by Friday",
    "due_hint": "Friday"
  }
}
```

**Input**: "idea: what if we added a dark mode to the app"
```json
{
  "destination": "ideas",
  "confidence": 0.88,
  "data": {
    "name": "Dark Mode",
    "one_liner": "Add dark/light theme switching to the app"
  }
}
```

**Input**: "remember to renew car registration"
```json
{
  "destination": "admin",
  "confidence": 0.85,
  "data": {
    "name": "Renew car registration",
    "due_date": null,
    "notes": null
  }
}
```

## Slug Generation

Convert titles to file-safe slugs:
- Lowercase
- Replace spaces with hyphens
- Remove special characters
- Truncate to 50 chars

Examples:
- "Sarah Chen" → `sarah-chen.md`
- "API Refactor Project" → `api-refactor-project.md`
- "What if we added dark mode?" → `what-if-we-added-dark-mode.md`

## Error Handling

| Error | Action |
|-------|--------|
| Inbox write fails | Report error, do not proceed |
| Classification fails | Keep in inbox as unprocessed |
| Beads command fails | Route anyway, note task creation failed |
| File exists | Append to existing file |
