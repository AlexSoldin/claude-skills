# Claude Skills

A collection of custom skills for [Claude Code](https://claude.com/claude-code).

## What are Skills?

Skills are reusable prompts that extend Claude Code's capabilities. Each skill is a `SKILL.md` file with YAML frontmatter defining metadata and markdown content with instructions.

## Available Skills

| Skill | Description |
|-------|-------------|
| [commit-push-pr](skills/commit-push-pr/SKILL.md) | Commit staged changes, push to remote, and create a pull request. Enforces branch protection by never pushing directly to main. |

## Installation

### Quick Install

Run the install script to symlink all skills to your Claude skills directory:

```bash
./install.sh
```

### Manual Install

Symlink individual skills to `~/.claude/skills/`:

```bash
ln -sf /path/to/claude-skills/skills/commit-push-pr ~/.claude/skills/commit-push-pr
```

## Usage

Once installed, invoke skills in Claude Code using the slash command:

```
/commit-push-pr
```

## Creating New Skills

1. Create a new directory under `skills/`:
   ```bash
   mkdir skills/my-new-skill
   ```

2. Create a `SKILL.md` file with YAML frontmatter:
   ```markdown
   ---
   name: my-new-skill
   description: Brief description of what the skill does
   allowed-tools: Bash, Read, Write
   ---

   # My New Skill

   Instructions for Claude to follow when this skill is invoked.
   ```

3. Run `./install.sh` to create the symlink

## License

MIT License - see [LICENSE](LICENSE) for details.
