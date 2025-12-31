#!/bin/bash
# install.sh - Install O365 Admin skill for Claude Code
# Usage: ./install.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$HOME/.claude/skills/o365"
COMMANDS_DIR="$HOME/.claude/commands"

echo "Installing O365 Admin skill..."

# Create directories
mkdir -p "$SKILL_DIR"
mkdir -p "$COMMANDS_DIR"

# Copy skill files
cp "$SCRIPT_DIR/o365/README.md" "$SKILL_DIR/"
cp "$SCRIPT_DIR/o365/get-token.sh" "$SKILL_DIR/"
cp "$SCRIPT_DIR/o365/graph-call.sh" "$SKILL_DIR/"
cp "$SCRIPT_DIR/o365/powerplatform-call.sh" "$SKILL_DIR/"
cp "$SCRIPT_DIR/o365/.env.example" "$SKILL_DIR/"

# Copy slash command
cp "$SCRIPT_DIR/commands/o365.md" "$COMMANDS_DIR/"

# Make scripts executable
chmod +x "$SKILL_DIR"/*.sh

echo ""
echo "Installation complete!"
echo ""
echo "Next steps:"
echo "1. Configure credentials:"
echo "   cp $SKILL_DIR/.env.example $SKILL_DIR/.env"
echo "   # Edit $SKILL_DIR/.env with your Azure AD credentials"
echo ""
echo "2. Test the connection:"
echo "   $SKILL_DIR/graph-call.sh GET /organization"
echo ""
echo "3. Use in Claude Code:"
echo "   Type /o365 to activate the skill"
echo ""
