# ide-skills

Cursor skill routing rules for your projects. Installs a smart skill router that automatically loads the right coding guidelines based on your prompt — NestJS, TypeScript, testing, debugging, and more.

## Quick install (run remotely)

From the root of **any project** where you want the Cursor rules set up:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/fredericomartini/ai-ide-skills/main/install-cursor-skills.sh)
```

Or clone and run locally:

```bash
git clone https://github.com/fredericomartini/ai-ide-skills.git
cd your-project
../ai-ide-skills/install-cursor-skills.sh
```

This will:
- Create `.cursor/rules/` in your project
- Copy the skill router (`00-skill-router.mdc`) into it
- Symlink all supported skills from your global skills directory (`~/.cursor/skills/`)

## Step 1 — Install domain skills

Before running the install script, you need the actual skill files on your machine. These are sourced from [antigravity-awesome-skills](https://github.com/antigravity/awesome-skills) and installed via `npx`:

```bash
# Install skills for each IDE tool you use
npx antigravity-awesome-skills --claude
npx antigravity-awesome-skills --cursor
npx antigravity-awesome-skills --gemini
npx antigravity-awesome-skills --codex
```

Each command installs the corresponding skill files into their standard locations:

| Flag | Skills installed to |
|------|-------------------|
| `--claude` | `~/.claude/skills/` |
| `--cursor` | `~/.cursor/skills/` |
| `--gemini` | `~/.gemini/skills/` |
| `--codex` | `~/.codex/skills/` |

## Step 2 — Install the skill router into your project

Once skills are installed globally, run the setup script from your project root:

```bash
./install-cursor-skills.sh
```

## How it works

The skill router (`00-skill-router.mdc`) is a Cursor rule that runs on every prompt. It scans your message for keywords and loads 1–3 relevant skill files before responding:

| Keywords | Skill loaded |
|----------|-------------|
| NestJS, controllers, guards, DTOs | `nestjs-expert` |
| REST API, endpoints, HTTP methods | `api-design-principles` |
| Backend, Node.js, middleware | `backend-dev-guidelines` |
| MongoDB, Mongoose, schemas | `nosql-expert` |
| TypeScript, types, generics | `typescript-pro` |
| Debugging, errors, stack traces | `systematic-debugging` |
| Code review, PR review | `code-reviewer` |
| Tests, TDD, Jest, Vitest | `javascript-testing-patterns` |
| Architecture, system design | `architecture` |
| Search codebase, find code | `search-specialist` |
| Python, FastAPI, Django | `python-pro` |
| Bash, shell, CLI | `bash-pro` |
| React, frontend, UI | `react-best-practices` |
| AWS, Lambda, S3 | `aws-skills` |

For NestJS/backend work, `nestjs-expert` + `backend-dev-guidelines` are always loaded by default.

## Adding a new skill

1. Add the skill file at `~/.cursor/skills/<skill-name>/SKILL.md`
2. Add a symlink entry in the `RULES` array inside `install-cursor-skills.sh`
3. Add a keyword row to the routing table in `00-skill-router.mdc`
4. Re-run `install-cursor-skills.sh` in your project

---

## Personal Claude Code Skills

The `skills/` folder contains personal skills for [Claude Code](https://claude.ai/code) — AI-powered workflows for daily productivity, note-taking, and personal automation.

### Available skills

| Skill | Folder | Description |
|-------|--------|-------------|
| Obsidian | `skills/obsidian/` | Full Obsidian vault assistant — add to-dos, capture ideas, manage meeting notes, reading list, and inbox via natural language |
| End of Day | `skills/end-of-day/` | Daily workflow — morning briefing from Today.md and end-of-day archive + summary |

### Install personal skills into Claude Code

Clone this repo and copy the skills you want into your Claude Code skills directory:

```bash
git clone https://github.com/fredericomartini/ai-ide-skills.git

# Install a specific skill
cp -r ai-ide-skills/skills/obsidian ~/.claude/skills/obsidian
cp -r ai-ide-skills/skills/end-of-day ~/.claude/skills/end-of-day

# Or install all personal skills at once
for skill in ai-ide-skills/skills/*/; do
  cp -r "$skill" ~/.claude/skills/"$(basename "$skill")"
done
```

### Required: set environment variables

These skills use `$OBSIDIAN_VAULT` to locate your vault. Add it to your Claude Code `settings.json`:

```json
{
  "env": {
    "OBSIDIAN_VAULT": "/path/to/your/Obsidian/vault"
  }
}
```

`settings.json` is typically at `~/.claude/settings.json`.

### Obsidian vault requirements

The skills expect this folder structure inside your vault:

```
YourVault/
├── Carbon Voice/
│   └── Daily/
│       └── Today.md       ← rolling daily note
├── Ideas/                 ← one file per developed idea
├── Meetings/              ← meeting notes by person/date
├── Personal/              ← personal documents
├── Scripts/               ← code snippets
├── INBOX.md               ← brain dump / loose thoughts
└── READING.md             ← reading / watching list
```

The `end-of-day` skill also requires `end_of_day.py` at the vault root. Copy it from the skill folder:

```bash
cp ai-ide-skills/skills/end-of-day/end_of_day.py /path/to/your/vault/end_of_day.py
```
