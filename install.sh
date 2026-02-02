#!/bin/bash
# Install Claude skills and/or Cursor rules by creating symlinks

set -e

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_SKILLS_DIR="$HOME/.claude/skills"
CURSOR_RULES_DIR="$HOME/.cursor/rules"
FORCE=false
INSTALL_CLAUDE=false
INSTALL_CURSOR=false

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --force|-f)
            FORCE=true
            shift
            ;;
        --claude)
            INSTALL_CLAUDE=true
            shift
            ;;
        --cursor)
            INSTALL_CURSOR=true
            shift
            ;;
        --both)
            INSTALL_CLAUDE=true
            INSTALL_CURSOR=true
            shift
            ;;
        *)
            echo "Unknown option: $1"
            echo "Usage: ./install.sh [--force] [--claude|--cursor|--both]"
            exit 1
            ;;
    esac
done

# If no tool specified, prompt interactively
if [ "$INSTALL_CLAUDE" = false ] && [ "$INSTALL_CURSOR" = false ]; then
    echo "Install for which tool?"
    echo "1) Claude only"
    echo "2) Cursor only"
    echo "3) Both (Recommended)"
    read -p "Choice [3]: " choice
    choice=${choice:-3}

    case $choice in
        1)
            INSTALL_CLAUDE=true
            ;;
        2)
            INSTALL_CURSOR=true
            ;;
        3|"")
            INSTALL_CLAUDE=true
            INSTALL_CURSOR=true
            ;;
        *)
            echo "Invalid choice. Defaulting to both."
            INSTALL_CLAUDE=true
            INSTALL_CURSOR=true
            ;;
    esac
fi

# Install Claude skills
if [ "$INSTALL_CLAUDE" = true ]; then
    echo ""
    echo "=== Installing Claude skills ==="
    mkdir -p "$CLAUDE_SKILLS_DIR"

    for skill in "$REPO_DIR/skills/"*/; do
        skill_name=$(basename "$skill")
        target="$CLAUDE_SKILLS_DIR/$skill_name"

        if [ -L "$target" ]; then
            if [ "$FORCE" = true ]; then
                rm "$target"
            else
                echo "Skipping $skill_name (symlink exists, use --force to update)"
                continue
            fi
        elif [ -e "$target" ]; then
            echo "Skipping $skill_name (directory exists at $target)"
            continue
        fi

        ln -s "$skill" "$target"
        echo "Linked $skill_name -> $target"
    done
fi

# Install Cursor rules
if [ "$INSTALL_CURSOR" = true ]; then
    echo ""
    echo "=== Installing Cursor rules ==="
    mkdir -p "$CURSOR_RULES_DIR"

    for rule in "$REPO_DIR/cursor-rules/"*.mdc; do
        [ -e "$rule" ] || continue  # Skip if no .mdc files exist
        rule_name=$(basename "$rule")
        target="$CURSOR_RULES_DIR/$rule_name"

        if [ -L "$target" ]; then
            if [ "$FORCE" = true ]; then
                rm "$target"
            else
                echo "Skipping $rule_name (symlink exists, use --force to update)"
                continue
            fi
        elif [ -e "$target" ]; then
            echo "Skipping $rule_name (file exists at $target)"
            continue
        fi

        ln -s "$rule" "$target"
        echo "Linked $rule_name -> $target"
    done
fi

echo ""
echo "Done!"
[ "$INSTALL_CLAUDE" = true ] && echo "Claude skills are now available in Claude Code."
[ "$INSTALL_CURSOR" = true ] && echo "Cursor rules are now available in ~/.cursor/rules/"
