#!/usr/bin/env python3
"""
Pre-Tool Use Hook - Validate operations before execution.

Triggered before each tool use via settings.json.
Implements basic guardrail checks from scheme-0.
"""

import sys
import json
import os
from pathlib import Path

# Dangerous patterns to block
BLOCKED_PATTERNS = [
    # Destructive operations on critical directories
    ("rm -rf brain", "Cannot delete entire brain directory"),
    ("rm -rf .beads", "Cannot delete Beads directory"),
    ("rm -r brain", "Cannot recursively delete brain"),
    ("rm -r .beads", "Cannot recursively delete .beads"),

    # Credential exposure
    ("echo $ANTHROPIC_API_KEY", "Cannot expose API keys"),
    ("echo $OPENAI_API_KEY", "Cannot expose API keys"),
    ("cat ~/.ssh", "Cannot expose SSH keys"),

    # Force operations without safety
    ("git push --force", "Force push not allowed without explicit confirmation"),
    ("git reset --hard", "Hard reset not allowed without backup"),
]

def check_bash_command(command: str) -> tuple[bool, str]:
    """Check if a bash command should be blocked."""
    command_lower = command.lower()

    for pattern, reason in BLOCKED_PATTERNS:
        if pattern.lower() in command_lower:
            return False, reason

    return True, ""

def main():
    """Main hook execution."""
    # Read hook input from stdin
    try:
        hook_input = json.load(sys.stdin)
    except json.JSONDecodeError:
        # If no JSON input, allow
        sys.exit(0)

    tool_name = hook_input.get("tool_name", "")
    tool_input = hook_input.get("tool_input", {})

    # Only check Bash commands
    if tool_name != "Bash":
        sys.exit(0)

    command = tool_input.get("command", "")

    allowed, reason = check_bash_command(command)

    if not allowed:
        # Output block decision
        result = {
            "decision": "block",
            "reason": reason
        }
        print(json.dumps(result))
        sys.exit(0)

    # Allow by default
    sys.exit(0)

if __name__ == "__main__":
    main()
