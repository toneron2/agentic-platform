#!/bin/bash
#
# Agentic Platform Installer
# Creates a new project with the agentic scaffolding
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/YOUR_REPO/main/install.sh | bash -s my-project
#   OR
#   ./install.sh my-project
#   OR
#   ./install.sh  (interactive mode)
#

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_header() {
    echo -e "${BLUE}"
    echo "╔═══════════════════════════════════════════════════════════════╗"
    echo "║           Agentic Platform - Project Scaffolding              ║"
    echo "║       Long-running projects with AI-powered capture           ║"
    echo "╚═══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

print_step() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
}

check_dependencies() {
    echo -e "\n${BLUE}Checking dependencies...${NC}\n"

    local missing=()

    # Check git
    if command -v git &> /dev/null; then
        print_step "git $(git --version | cut -d' ' -f3)"
    else
        print_error "git not found"
        missing+=("git")
    fi

    # Check python3
    if command -v python3 &> /dev/null; then
        print_step "python3 $(python3 --version | cut -d' ' -f2)"
    else
        print_error "python3 not found"
        missing+=("python3")
    fi

    # Check go (for beads)
    if command -v go &> /dev/null; then
        print_step "go $(go version | cut -d' ' -f3 | sed 's/go//')"
    else
        print_warning "go not found - needed to install Beads CLI"
        echo "         Install Go: https://go.dev/doc/install"
    fi

    # Check bd (beads)
    if command -v bd &> /dev/null; then
        print_step "bd (Beads CLI) installed"
    else
        print_warning "bd (Beads CLI) not found"
        echo "         Install: go install github.com/steveyegge/beads/cmd/bd@latest"
    fi

    # Check claude
    if command -v claude &> /dev/null; then
        print_step "claude (Claude Code CLI) installed"
    else
        print_error "claude (Claude Code CLI) not found"
        echo "         Install: https://docs.anthropic.com/en/docs/claude-code"
        missing+=("claude")
    fi

    if [ ${#missing[@]} -gt 0 ]; then
        echo -e "\n${RED}Missing required dependencies: ${missing[*]}${NC}"
        echo "Please install them and run this script again."
        exit 1
    fi

    echo ""
}

get_project_name() {
    if [ -n "$1" ]; then
        PROJECT_NAME="$1"
    else
        echo -e "${BLUE}What's your project name?${NC}"
        echo "(This will be the directory name, e.g., 'my-startup', 'book-project')"
        read -p "> " PROJECT_NAME
    fi

    # Sanitize project name
    PROJECT_NAME=$(echo "$PROJECT_NAME" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | tr -cd 'a-z0-9-')

    if [ -z "$PROJECT_NAME" ]; then
        print_error "Project name cannot be empty"
        exit 1
    fi

    if [ -d "$PROJECT_NAME" ]; then
        print_error "Directory '$PROJECT_NAME' already exists"
        exit 1
    fi
}

get_project_description() {
    echo -e "\n${BLUE}Describe your project in one line:${NC}"
    echo "(e.g., 'Building a SaaS for restaurant owners')"
    read -p "> " PROJECT_DESCRIPTION

    if [ -z "$PROJECT_DESCRIPTION" ]; then
        PROJECT_DESCRIPTION="My agentic project"
    fi
}

create_structure() {
    echo -e "\n${BLUE}Creating project structure...${NC}\n"

    mkdir -p "$PROJECT_NAME"
    cd "$PROJECT_NAME"

    # Create directories
    mkdir -p .claude/skills/conductor
    mkdir -p .claude/skills/capture
    mkdir -p .claude/skills/classify
    mkdir -p .claude/skills/digest
    mkdir -p .claude/skills/review
    mkdir -p .claude/skills/prime
    mkdir -p .claude/commands
    mkdir -p .claude/hooks
    mkdir -p brain/inbox
    mkdir -p brain/people
    mkdir -p brain/projects
    mkdir -p brain/ideas
    mkdir -p brain/admin
    mkdir -p governance/guardrails
    mkdir -p governance/specs
    mkdir -p state
    mkdir -p schemas

    print_step "Directory structure created"
}

create_gitkeep_files() {
    touch brain/inbox/.gitkeep
    touch brain/people/.gitkeep
    touch brain/projects/.gitkeep
    touch brain/ideas/.gitkeep
    touch brain/admin/.gitkeep
    touch state/.gitkeep

    print_step "Placeholder files created"
}

copy_template_files() {
    # This function copies the template files
    # In a real distribution, these would be downloaded or extracted

    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

    # Check if we're running from the template directory
    if [ -f "$SCRIPT_DIR/.claude/skills/conductor/SKILL.md" ]; then
        # Copy from template
        cp -r "$SCRIPT_DIR/.claude/skills/"* .claude/skills/
        cp -r "$SCRIPT_DIR/.claude/commands/"* .claude/commands/
        cp -r "$SCRIPT_DIR/.claude/hooks/"* .claude/hooks/
        cp "$SCRIPT_DIR/.claude/settings.json" .claude/
        cp -r "$SCRIPT_DIR/governance/"* governance/
        cp -r "$SCRIPT_DIR/schemas/"* schemas/
        cp "$SCRIPT_DIR/.gitignore" .

        print_step "Template files copied"
    else
        print_warning "Template files not found - creating minimal structure"
        create_minimal_files
    fi
}

create_minimal_files() {
    # Create minimal files if template not available
    cat > .claude/settings.json << 'EOF'
{
  "hooks": {
    "SessionEnd": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "python3 .claude/hooks/session_sync.py"
          }
        ]
      }
    ]
  }
}
EOF

    print_step "Minimal configuration created"
}

create_project_claude_md() {
    cat > CLAUDE.md << EOF
# ${PROJECT_NAME} - Claude Code Context

## Project Overview

**Purpose**: ${PROJECT_DESCRIPTION}

**Architecture**: Beads (task tracking) + Brain (knowledge capture) + Agentic orchestration

---

## Quick Commands

| Command | Description |
|---------|-------------|
| \`/capture [thought]\` | Capture and classify a thought |
| \`/ready\` | Show unblocked tasks |
| \`/task [title]\` | Create a new task |
| \`/done [id]\` | Mark task complete |
| \`/sync\` | Sync state to git |
| \`/digest\` | Generate daily summary |

---

## Brain Categories

| Category | Directory | When to Use |
|----------|-----------|-------------|
| People | \`brain/people/\` | Relationship notes, contacts |
| Projects | \`brain/projects/\` | Multi-step work efforts |
| Ideas | \`brain/ideas/\` | Concepts to explore later |
| Admin | \`brain/admin/\` | Tasks with due dates |

---

## Session Lifecycle

\`\`\`
Session Start → Prime Context → Work → Auto-Sync → Session End
\`\`\`

---

## Getting Started

1. Capture your first thought: \`/capture [your idea here]\`
2. Check ready work: \`/ready\`
3. Generate your first digest: \`/digest\`

---

**Project**: ${PROJECT_NAME}
**Created**: $(date +%Y-%m-%d)
EOF

    print_step "CLAUDE.md created"
}

create_project_readme() {
    cat > README.md << EOF
# ${PROJECT_NAME}

${PROJECT_DESCRIPTION}

## Quick Start

\`\`\`bash
# Start Claude Code
claude

# Capture your first thought
/capture My first project idea...

# Check what's ready to work on
/ready

# Create a task
/task Set up the basic structure

# Generate a digest
/digest
\`\`\`

## Structure

\`\`\`
${PROJECT_NAME}/
├── brain/               # Your knowledge base
│   ├── inbox/           # Uncategorized captures
│   ├── people/          # Relationship notes
│   ├── projects/        # Project context
│   ├── ideas/           # Ideas to explore
│   └── admin/           # Tasks with dates
├── .beads/              # Task tracking (Beads)
├── .claude/             # Claude Code configuration
│   ├── skills/          # Agentic expertise
│   ├── commands/        # Slash commands
│   └── hooks/           # Automation
├── governance/          # Safety guardrails
└── state/               # Session state
\`\`\`

## Workflow

1. **Capture** thoughts with \`/capture\` - they get classified automatically
2. **Track** work with Beads - tasks have dependencies and priorities
3. **Review** progress with \`/digest\` (daily) and \`/review\` (weekly)
4. **Sync** happens automatically when you end a session

## Built With

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) - AI coding assistant
- [Beads](https://github.com/steveyegge/beads) - Git-backed issue tracking
- Agentic Platform scaffolding

---

Created: $(date +%Y-%m-%d)
EOF

    print_step "README.md created"
}

initialize_git() {
    git init -q
    git add .
    git commit -q -m "Initial commit: ${PROJECT_NAME} scaffolding"

    print_step "Git repository initialized"
}

initialize_beads() {
    if command -v bd &> /dev/null; then
        bd init --quiet 2>/dev/null || true
        print_step "Beads initialized"
    else
        print_warning "Skipping Beads init (bd not installed)"
    fi
}

print_success() {
    echo -e "\n${GREEN}════════════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}  Success! Project '${PROJECT_NAME}' is ready.${NC}"
    echo -e "${GREEN}════════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo "Next steps:"
    echo ""
    echo -e "  ${BLUE}cd ${PROJECT_NAME}${NC}"
    echo -e "  ${BLUE}claude${NC}"
    echo ""
    echo "Then try:"
    echo ""
    echo -e "  ${YELLOW}/capture My first thought about this project${NC}"
    echo -e "  ${YELLOW}/ready${NC}"
    echo -e "  ${YELLOW}/digest${NC}"
    echo ""

    if ! command -v bd &> /dev/null; then
        echo -e "${YELLOW}Don't forget to install Beads:${NC}"
        echo "  go install github.com/steveyegge/beads/cmd/bd@latest"
        echo ""
    fi

    echo "Happy building!"
    echo ""
}

# Main execution
main() {
    print_header
    check_dependencies
    get_project_name "$1"
    get_project_description
    create_structure
    create_gitkeep_files
    copy_template_files
    create_project_claude_md
    create_project_readme
    initialize_git
    initialize_beads
    print_success
}

main "$@"
