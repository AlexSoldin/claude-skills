#!/bin/bash
# Install Claude skills by creating symlinks to ~/.claude/skills/

set -e

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILLS_DIR="$HOME/.claude/skills"

# Create skills directory if it doesn't exist
mkdir -p "$SKILLS_DIR"

# Link each skill
for skill in "$REPO_DIR/skills/"*/; do
    skill_name=$(basename "$skill")
    target="$SKILLS_DIR/$skill_name"

    # Remove existing symlink or directory
    if [ -L "$target" ]; then
        rm "$target"
    elif [ -d "$target" ]; then
        echo "Warning: $target exists and is not a symlink. Skipping."
        echo "  Remove it manually if you want to link: rm -rf $target"
        continue
    fi

    ln -s "$skill" "$target"
    echo "Linked $skill_name -> $target"
done

echo "Done! Skills are now available in Claude Code."
