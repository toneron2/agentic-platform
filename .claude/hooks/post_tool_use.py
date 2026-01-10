#!/usr/bin/env python3
"""
Post-Tool Use Hook - Log operations for audit trail.

Triggered after each tool use via settings.json.
Records significant operations to pipeline.log.
"""

import sys
import json
from datetime import datetime
from pathlib import Path

# Project root
PROJECT_ROOT = Path(__file__).parent.parent.parent

# Tools to log
LOGGED_TOOLS = ["Bash", "Write", "Edit"]

# Skip logging for these patterns
SKIP_PATTERNS = [
    "cat ",
    "ls ",
    "pwd",
    "echo ",
    "date",
]

def should_log(tool_name: str, tool_input: dict) -> bool:
    """Determine if this operation should be logged."""
    if tool_name not in LOGGED_TOOLS:
        return False

    if tool_name == "Bash":
        command = tool_input.get("command", "")
        for pattern in SKIP_PATTERNS:
            if command.startswith(pattern):
                return False

    return True

def log_operation(tool_name: str, tool_input: dict, result: dict):
    """Log operation to pipeline.log."""
    log_file = PROJECT_ROOT / "state" / "pipeline.log"
    log_file.parent.mkdir(parents=True, exist_ok=True)

    timestamp = datetime.now().isoformat()

    # Format log entry based on tool
    if tool_name == "Bash":
        command = tool_input.get("command", "")[:100]
        entry = f"[{timestamp}] [tool:bash] {command}"
    elif tool_name == "Write":
        file_path = tool_input.get("file_path", "")
        entry = f"[{timestamp}] [tool:write] {file_path}"
    elif tool_name == "Edit":
        file_path = tool_input.get("file_path", "")
        entry = f"[{timestamp}] [tool:edit] {file_path}"
    else:
        entry = f"[{timestamp}] [tool:{tool_name.lower()}] operation"

    with open(log_file, "a") as f:
        f.write(entry + "\n")

def main():
    """Main hook execution."""
    try:
        hook_input = json.load(sys.stdin)
    except json.JSONDecodeError:
        sys.exit(0)

    tool_name = hook_input.get("tool_name", "")
    tool_input = hook_input.get("tool_input", {})
    tool_result = hook_input.get("tool_result", {})

    if should_log(tool_name, tool_input):
        log_operation(tool_name, tool_input, tool_result)

    sys.exit(0)

if __name__ == "__main__":
    main()
