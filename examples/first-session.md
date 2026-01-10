# Example: Your First Session

This walkthrough shows a complete first session with the agentic platform.

---

## Scenario

You're starting a new project: a mobile app for tracking reading habits.

---

## Session Transcript

### Starting Up

```bash
$ cd reading-tracker
$ claude
```

Claude loads your project context from `CLAUDE.md`.

---

### Capturing Initial Ideas

```
You: /capture I want to build a reading tracker app - something simple that helps people build a daily reading habit

Claude: Classifying...

Filed to Projects: Reading tracker app
Confidence: 0.91
Task created: bd-a1b2

The item has been saved to brain/projects/reading-tracker-app.md and a Beads task created for tracking.
```

---

### More Captures

```
You: /capture idea: gamification with streaks like Duolingo

Claude: Filed to Ideas: Gamification with streaks
Confidence: 0.88

You: /capture Met Jake at the coffee shop - he's built 3 mobile apps, could be a good advisor

Claude: Filed to People: Jake
Confidence: 0.94
Context: Mobile app experience, potential advisor

You: /capture Need to research App Store guidelines before going too far

Claude: Filed to Admin: Research App Store guidelines
Confidence: 0.82
Task created: bd-c3d4
```

---

### Checking Status

```
You: /ready

Claude: Ready Work (2 tasks):

1. [bd-a1b2] Reading tracker app
   Priority: 2 (Medium) | Type: project | Created: just now

2. [bd-c3d4] Research App Store guidelines
   Priority: 2 (Medium) | Type: task | Created: just now

Both tasks are ready with no blockers.
```

---

### Creating More Tasks

```
You: /task Define core features for MVP

Claude: Task created: bd-e5f6
Title: Define core features for MVP
Priority: 2 (Medium)
Status: open
```

---

### Adding Dependencies

```
You: The feature definition should come before the App Store research makes sense

You: /block bd-c3d4 bd-e5f6

Claude: Dependency added.
bd-c3d4 (Research App Store guidelines) is now blocked by bd-e5f6 (Define core features for MVP)

You: /ready

Claude: Ready Work (2 tasks):

1. [bd-a1b2] Reading tracker app
   Priority: 2 (Medium)

2. [bd-e5f6] Define core features for MVP
   Priority: 2 (Medium)

Note: bd-c3d4 is blocked, waiting on bd-e5f6
```

---

### Working and Completing

```
You: I've defined the core features: daily reading log, streak tracking, and weekly stats

You: /done bd-e5f6

Claude: Task completed: bd-e5f6 (Define core features for MVP)

This unblocks:
- bd-c3d4 (Research App Store guidelines)

You: /ready

Claude: Ready Work (2 tasks):

1. [bd-a1b2] Reading tracker app
2. [bd-c3d4] Research App Store guidelines

Both tasks are now ready.
```

---

### Generating a Digest

```
You: /digest

Claude:
## Daily Digest - January 10, 2026

**Quick Stats:**
- Tasks created: 3
- Tasks completed: 1
- Brain items: 4

**Top 3 Actions:**
1. [bd-a1b2] Reading tracker app - main project
2. [bd-c3d4] Research App Store guidelines - unblocked today
3. Follow up with Jake about advising

**People to Connect With:**
- Jake: Potential advisor for mobile app (just met)

**Ideas to Explore:**
- Gamification with streaks like Duolingo

**What's Going Well:**
You've captured your initial vision and broken it into trackable tasks. Good momentum!
```

---

### Ending the Session

```
You: I'm done for today, going to think more about this

Claude: Sounds good! Your session will be synced automatically.

[You exit Claude Code with Ctrl+C or /exit]

[SessionEnd hook fires]
[bd sync runs]
[state/session.json updated]
```

---

## What Got Created

After this session, your project looks like:

```
reading-tracker/
├── brain/
│   ├── people/
│   │   └── jake.md              # Jake's info
│   ├── projects/
│   │   └── reading-tracker-app.md
│   ├── ideas/
│   │   └── gamification-with-streaks.md
│   └── admin/
│       └── research-app-store-guidelines.md
├── .beads/
│   └── issues.jsonl             # 2 open tasks, 1 closed
└── state/
    └── session.json             # Session record
```

---

## Brain Files Created

### brain/people/jake.md

```markdown
---
name: Jake
context: Mobile app experience, built 3 apps
last_touched: 2026-01-10
---

## Notes
- 2026-01-10: Met at coffee shop. Potential advisor for reading tracker project.

## Follow-ups
- Reach out about advising on the app
```

### brain/projects/reading-tracker-app.md

```markdown
---
name: Reading Tracker App
status: active
beads_id: bd-a1b2
last_touched: 2026-01-10
---

## Vision
Simple app to help people build a daily reading habit.

## Notes
- 2026-01-10: Initial capture - want something simple
- Core features defined: daily log, streaks, weekly stats
```

### brain/ideas/gamification-with-streaks.md

```markdown
---
name: Gamification with Streaks
one_liner: Add Duolingo-style streak tracking
captured_at: 2026-01-10
---

## Notes
Could make reading more engaging. Research what makes Duolingo streaks work.

## Related
- Reading tracker app project
```

---

## Key Takeaways

1. **Capture everything** - Even casual thoughts become organized knowledge
2. **Tasks have structure** - Dependencies prevent working on the wrong things
3. **Context persists** - Everything is saved, nothing lost
4. **AI handles organization** - You just dump thoughts, it classifies

---

## Next Session

Tomorrow, you might:
1. Check `/ready` to see what's unblocked
2. Work on App Store research
3. Capture more ideas as they come
4. Reach out to Jake

The platform remembers everything and keeps you on track.

---

*This is just the beginning. Go build something amazing.*
