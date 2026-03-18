# ide-skills

Cursor skill routing rules for your projects. Installs a smart skill router that automatically loads the right coding guidelines based on your prompt — NestJS, TypeScript, testing, debugging, and more.

## Quick install (run remotely)

From the root of **any project** where you want the Cursor rules set up:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/fredericoalmeida/ide-skills/main/install-cursor-skills.sh)
```

Or clone and run locally:

```bash
git clone https://github.com/fredericoalmeida/ide-skills.git
cd your-project
../ide-skills/install-cursor-skills.sh
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
