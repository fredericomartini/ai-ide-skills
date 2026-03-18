# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

A Cursor IDE skill routing system. It provides two things:

1. **`00-skill-router.mdc`** — A Cursor rule (`alwaysApply: true`) that intercepts every prompt, selects 1–3 relevant skills from a keyword lookup table, reads those skill files, and prefixes the response with `**Skills activated:** ...`. Default skills for backend/NestJS work are `nestjs-expert` + `backend-dev-guidelines`.

2. **`install-cursor-skills.sh`** — A setup script run from a project root (`./install-cursor-skills.sh`) that:
   - Creates `.cursor/rules/` in the target project
   - Copies `00-skill-router.mdc` into it
   - Symlinks each skill name (e.g. `nestjs-expert.mdc`) to the canonical `SKILL.md` stored globally at `~/.cursor/skills/<skill-name>/SKILL.md` or `~/.codex/skills/<skill-name>/SKILL.md`

## Skill locations

| Source | Path pattern |
|--------|-------------|
| Cursor skills | `~/.cursor/skills/<skill-name>/SKILL.md` |
| Codex skills | `~/.codex/skills/<skill-name>/SKILL.md` |

Skills referenced in the router: `nestjs-expert`, `api-design-principles`, `backend-dev-guidelines`, `nosql-expert`, `typescript-pro`, `systematic-debugging`, `code-reviewer`, `javascript-testing-patterns`, `architecture`, `search-specialist`, `python-pro`, `bash-pro`, `react-best-practices`, `aws-skills`, and `backend-architect-brain` (Codex only).

## Adding a new skill

1. Create the skill file at `~/.cursor/skills/<skill-name>/SKILL.md`
2. Add a symlink entry to the `RULES` array in `install-cursor-skills.sh`
3. Add a row to the keyword table in `00-skill-router.mdc`

## Running the install script

```bash
# From any project root where you want these Cursor rules installed:
/path/to/ide-skills/install-cursor-skills.sh
```

The script is idempotent — existing files and symlinks are left unchanged.
