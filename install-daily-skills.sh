#!/usr/bin/env bash
set -euo pipefail

# install-daily-skills.sh
# ───────────────────────────────────────────────────────────────────────────
# Installs the antigravity community skill pack for all tools, then prunes
# everything down to the audited daily-use set (score 7+ only).
#
# Usage:
#   ./install-daily-skills.sh            # install + prune all tools
#   ./install-daily-skills.sh --prune-only  # skip install, just prune
#
# To install a specific extra skill later:
#   npx antigravity-awesome-skills --claude  (then delete what you don't want)
#   Or manually: cp -r <repo>/skills/<name> ~/.claude/skills/<name>
# ───────────────────────────────────────────────────────────────────────────

# ── Daily skill list (score 7+, audited 2026-03-21) ───────────────────────
DAILY_SKILLS=(
  # Core backend
  "nestjs-expert"
  "backend-dev-guidelines"
  "nosql-expert"
  "typescript-pro"
  "typescript-expert"
  "nodejs-best-practices"

  # API & architecture
  "api-patterns"
  "architecture"

  # Code quality
  "code-reviewer"
  "code-review-checklist"
  "systematic-debugging"

  # Testing
  "javascript-testing-patterns"
  "test-driven-development"

  # Frontend
  "react-best-practices"
  "nextjs-best-practices"
  "nextjs-app-router-patterns"

  # Infrastructure
  "docker-expert"
  "aws-skills"
  "git-advanced-workflows"

  # Security
  "api-security-best-practices"
  "backend-security-coder"

  # Python / shell (used on demand)
  "python-pro"
  "bash-pro"
)

is_daily() {
  local name="$1"
  for skill in "${DAILY_SKILLS[@]}"; do
    [[ "$skill" == "$name" ]] && return 0
  done
  return 1
}

prune_dir() {
  local dir="$1"
  local removed=0
  local kept=0

  echo "  Pruning: ${dir}"

  for skill_dir in "${dir}"/*/; do
    [[ -d "$skill_dir" ]] || continue
    skill_name="$(basename "$skill_dir")"
    skill_file="${skill_dir}SKILL.md"

    # Only touch community-sourced skills — leave PAI and personal skills alone
    if grep -q "source: community" "$skill_file" 2>/dev/null; then
      if is_daily "$skill_name"; then
        echo "    ✓ keep  ${skill_name}"
        ((kept++))
      else
        rm -rf "$skill_dir"
        ((removed++))
      fi
    fi
  done

  echo "    → kept ${kept} daily skills, removed ${removed} community skills"
}

# ── Step 1: Install (optional) ────────────────────────────────────────────
if [[ "${1:-}" != "--prune-only" ]]; then
  echo "Installing antigravity skills for all tools..."
  npx antigravity-awesome-skills --claude
  npx antigravity-awesome-skills --cursor
  npx antigravity-awesome-skills --gemini
  npx antigravity-awesome-skills --codex
  echo ""
fi

# ── Step 2: Prune ─────────────────────────────────────────────────────────
echo "Pruning to daily skill set..."
echo ""

prune_dir "${HOME}/.claude/skills"
echo ""
prune_dir "${HOME}/.cursor/skills"
echo ""
prune_dir "${HOME}/.gemini/skills"
echo ""
prune_dir "${HOME}/.codex/skills"

# Remove the Gemini antigravity duplicate directory if it exists
if [[ -d "${HOME}/.gemini/antigravity" ]]; then
  rm -rf "${HOME}/.gemini/antigravity"
  echo ""
  echo "  Removed ~/.gemini/antigravity (duplicate install dir)"
fi

echo ""
echo "Done. Active daily skills: ${#DAILY_SKILLS[@]}"
echo ""
echo "To install a bundle when you need it:"
echo "  npx antigravity-awesome-skills --claude && ./install-daily-skills.sh --prune-only"
echo "  Then manually keep the extra bundle skills you need."
