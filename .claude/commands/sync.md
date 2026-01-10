---
name: sync
description: Sync Beads state to git
arguments: []
---

# /sync Command

Exports Beads state to JSONL, commits, and pushes to remote.

## Usage

```
/sync
```

## Behavior

Executes the Beads 7-step sync process:

1. Export to `.beads/issues.jsonl`
2. `git add .beads/`
3. `git commit -m "beads: sync [timestamp]"`
4. `git pull --rebase`
5. Import any remote changes
6. `git push`
7. Verify success

## Output

```
Syncing Beads state...

Step 1/7: Exporting to JSONL... done
Step 2/7: Staging changes... done
Step 3/7: Committing... done
Step 4/7: Pulling remote... done
Step 5/7: Importing changes... done
Step 6/7: Pushing... done
Step 7/7: Verifying... done

Sync complete.
- 3 tasks exported
- 1 remote change imported
- HEAD is now up to date with origin
```

## Auto-Sync

This command also runs automatically:
- On session end (via SessionEnd hook)
- Ensures no work is lost

## Troubleshooting

If sync fails:
```
bd doctor --fix
```

Common issues:
- Network unavailable → retry later
- Merge conflict → manual resolution needed
- Auth expired → re-authenticate git

## Related Commands

- `/ready` - Show ready tasks
- `/task` - Create a task
