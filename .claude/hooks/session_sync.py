#!/usr/bin/env python3
"""
Session Sync Hook - Auto-sync Beads on session end.

Triggered by SessionEnd hook in settings.json.
Ensures no work is lost when session terminates.
"""

import subprocess
import sys
import json
from datetime import datetime
from pathlib import Path

# Project root (relative to hook location)
PROJECT_ROOT = Path(__file__).parent.parent.parent

def log(message: str):
    """Log to pipeline.log"""
    log_file = PROJECT_ROOT / "state" / "pipeline.log"
    log_file.parent.mkdir(parents=True, exist_ok=True)

    timestamp = datetime.now().isoformat()
    with open(log_file, "a") as f:
        f.write(f"[{timestamp}] [hook:session_sync] {message}\n")

def run_bd_sync() -> tuple[bool, str]:
    """Run bd sync and return success status and output."""
    try:
        result = subprocess.run(
            ["bd", "sync"],
            capture_output=True,
            text=True,
            timeout=120,
            cwd=PROJECT_ROOT
        )

        if result.returncode == 0:
            return True, result.stdout
        else:
            return False, result.stderr

    except FileNotFoundError:
        return False, "bd command not found. Install: go install github.com/steveyegge/beads/cmd/bd@latest"
    except subprocess.TimeoutExpired:
        return False, "Sync timed out after 120 seconds"
    except Exception as e:
        return False, str(e)

def update_session_state(sync_success: bool):
    """Update session.json with sync status."""
    state_file = PROJECT_ROOT / "state" / "session.json"
    state_file.parent.mkdir(parents=True, exist_ok=True)

    # Load existing or create new
    if state_file.exists():
        with open(state_file) as f:
            state = json.load(f)
    else:
        state = {}

    state["last_sync"] = datetime.now().isoformat()
    state["last_sync_success"] = sync_success
    state["ended_at"] = datetime.now().isoformat()

    with open(state_file, "w") as f:
        json.dump(state, f, indent=2)

def main():
    """Main hook execution."""
    log("Session ending, initiating sync...")

    # Run beads sync
    success, output = run_bd_sync()

    if success:
        log(f"Sync completed successfully")
    else:
        log(f"Sync failed: {output}")

    # Update session state
    update_session_state(success)
    log("Session state saved")

    # Exit with appropriate code
    # Don't block session end even if sync fails
    sys.exit(0)

if __name__ == "__main__":
    main()
