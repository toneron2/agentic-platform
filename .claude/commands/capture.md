---
name: capture
description: Capture a thought to the Brain2 inbox
arguments:
  - name: thought
    description: The thought to capture
    required: true
---

# /capture Command

Captures a thought to the Brain2 inbox with automatic classification and routing.

## Usage

```
/capture [your thought here]
```

## Examples

```
/capture Sarah mentioned she's looking for a new job
/capture project: need to finish the Q1 report by Friday
/capture idea: what if we added a dark mode to the app
/capture remember to renew car registration
```

## Behavior

1. Writes immediately to `brain/inbox/` (never lose data)
2. Classifies using AI into People/Projects/Ideas/Admin
3. Routes to appropriate `brain/` subdirectory
4. Creates Beads task if actionable (Projects/Admin)
5. Confirms what was done

## Prefixes (Optional)

For faster classification, use prefixes:
- `person:` → Routes to People
- `project:` → Routes to Projects
- `idea:` → Routes to Ideas
- `admin:` or `task:` → Routes to Admin

## Output

```
Filed to [Category]: [Title]
Confidence: 0.XX
[If task created]: Task created: bd-xxxx
```

## Low Confidence

If classification confidence < 0.6:
- Keeps item in inbox
- Asks for clarification
- Suggests prefixes
