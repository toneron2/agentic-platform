# Agent Hierarchy Specification

**Version**: 1.0
**Based on**: BROAD EVO/NOEVO patterns

---

## Overview

The agentic platform uses a simplified EVO/NOEVO hierarchy adapted from BROAD's governance model. All skills operate as **NOEVO** (non-evolutionary) agents with fixed behavior.

---

## Agent Classification

### NOEVO (Non-Evolutionary)

All skills in this platform are NOEVO:
- Fixed behavior at deployment
- Deterministic given same inputs
- No learning during operation
- Acts as trusted components

### Why NOEVO Only

For a personal knowledge management system:
- Predictability is paramount
- User trust requires consistency
- No need for adaptive learning
- Simpler to audit and debug

---

## Skill Hierarchy

```
Conductor [NOEVO] ─────────────────────────────────────────────
│  Role: Master orchestrator
│  Guardrails: Scheme 0 + Scheme 1
│  Permissions: Full skill invocation
│
├── Capture [NOEVO] ───────────────────────────────────────────
│   │  Role: Inbox capture
│   │  Guardrails: Scheme 1
│   │  Permissions: Write brain/inbox/, invoke classify
│   │
│   └── Classify [NOEVO] (internal) ───────────────────────────
│       Role: AI categorization
│       Guardrails: Scheme 1
│       Permissions: Read-only analysis
│
├── Digest [NOEVO] ────────────────────────────────────────────
│   Role: Daily summary generation
│   Guardrails: Scheme 1
│   Permissions: Read brain/, query Beads, write state/
│
├── Review [NOEVO] ────────────────────────────────────────────
│   Role: Weekly analysis
│   Guardrails: Scheme 1
│   Permissions: Read brain/, query Beads, write state/
│
└── Prime [NOEVO] (internal) ──────────────────────────────────
    Role: Context injection
    Guardrails: Scheme 1
    Permissions: Read-only, bd prime
```

---

## Guardrail Schemes

### Scheme 0: Absolute Safety
- Applied to: All skills (inherited)
- Purpose: Prevent data loss, ensure integrity
- Violations: Block operation, alert user
- See: `governance/guardrails/scheme-0.logic`

### Scheme 1: Operational Bounds
- Applied to: All skills (explicit)
- Purpose: Define allowed operations
- Violations: Warn or block depending on severity
- See: `governance/guardrails/scheme-1.logic`

---

## Communication Patterns

### Conductor → Skill
Direct invocation with parameters:
```
Conductor invokes Capture:
  input: "Sarah mentioned she's looking for a new job"
  expects: Capture writes inbox, invokes classify, routes, confirms
```

### Skill → Skill (Internal)
Only through conductor mediation:
```
Capture → Classify:
  Via conductor orchestration
  Classify returns JSON, Capture continues
```

### Skill → External (Beads)
Via Bash tool with bd CLI:
```
Digest → Beads:
  bd ready --json
  Returns structured task data
```

---

## Audit Requirements

All skills must:
1. Log significant operations to `state/pipeline.log`
2. Update `state/session.json` with counts
3. Preserve audit trail for user review

Log format:
```
[2026-01-10T14:30:52Z] [skill:capture] Captured to inbox/2026-01-10-143052.md
[2026-01-10T14:30:53Z] [skill:classify] Classified as people (confidence: 0.92)
[2026-01-10T14:30:53Z] [skill:capture] Routed to brain/people/sarah.md
```

---

## Error Escalation

| Level | Handled By | Action |
|-------|------------|--------|
| Recoverable | Skill | Retry once, log |
| Skill failure | Conductor | Report to user, preserve state |
| System failure | Hooks | Sync what's possible, alert |

---

## Future Considerations

If EVO agents needed later:
1. Designer agent for custom workflows
2. Learning classification improvements
3. Adaptive digest formatting

Would require:
- Scheme 2/3 guardrails
- Verification pipeline
- Rollback capability

For now, NOEVO provides the right balance of reliability and simplicity.
