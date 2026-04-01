#!/usr/bin/env bash
set -euo pipefail

#######################################################################
# install-cursor-skills.sh
#
# Sets up Cursor skill routing rules in the current project.
# Safe to run via curl pipe or directly from a local clone — the
# script bootstraps itself by cloning/updating the repo first.
#
# Usage (from any project root):
#   bash <(curl -fsSL https://raw.githubusercontent.com/fredericomartini/ai-ide-skills/main/install-cursor-skills.sh)
#######################################################################

REPO_URL="https://github.com/fredericomartini/ai-ide-skills.git"
REPO_LOCAL="${HOME}/.local/share/ai-ide-skills"

# ── Bootstrap ──────────────────────────────────────────────────────────
# If we're not already running from the canonical local clone, ensure it
# exists and is up to date, then re-exec from there (CWD is preserved).
_SCRIPT_DIR=""
_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-/dev/stdin}")" 2>/dev/null && pwd)" || true

if [[ "${_SCRIPT_DIR}" != "${REPO_LOCAL}" ]]; then
  if [[ -d "${REPO_LOCAL}/.git" ]]; then
    echo "Updating ai-ide-skills ..."
    git -C "${REPO_LOCAL}" pull --ff-only --quiet
  else
    echo "Cloning ai-ide-skills into ${REPO_LOCAL} ..."
    git clone --quiet "${REPO_URL}" "${REPO_LOCAL}"
  fi
  exec bash "${REPO_LOCAL}/install-cursor-skills.sh"
fi
# ───────────────────────────────────────────────────────────────────────

SCRIPT_DIR="${REPO_LOCAL}"
RULES_DIR=".cursor/rules"
CURSOR_SKILLS_DIR="${HOME}/.cursor/skills"
CODEX_SKILLS_DIR="${HOME}/.codex/skills"

echo "Setting up Cursor rules in: ${RULES_DIR}"
mkdir -p "${RULES_DIR}"

############################################
# 1) Ensure 00-skill-router.mdc is present #
############################################

SKILL_ROUTER_FILE="${RULES_DIR}/00-skill-router.mdc"

if [[ ! -f "${SKILL_ROUTER_FILE}" ]]; then
  cp "${SCRIPT_DIR}/00-skill-router.mdc" "${SKILL_ROUTER_FILE}"
  echo "Created ${SKILL_ROUTER_FILE}"
else
  echo "Found existing ${SKILL_ROUTER_FILE}, leaving as is."
fi

############################################
# 2) Install personal skills from this repo #
############################################

PERSONAL_SKILLS=(
  "backend-architect-brain"
)

echo "Installing personal skills to ${CODEX_SKILLS_DIR} ..."

for skill in "${PERSONAL_SKILLS[@]}"; do
  src="${SCRIPT_DIR}/skills/${skill}/SKILL.md"
  dest_dir="${CODEX_SKILLS_DIR}/${skill}"
  dest="${dest_dir}/SKILL.md"

  mkdir -p "${dest_dir}"
  cp "${src}" "${dest}"
  echo "  + Installed/updated ${skill} -> ${dest}"
done

######################################
# 3) Symlink rule → SKILL mappings   #
######################################

# Each entry: "rule_name.mdc|/path/to/SKILL.md"
# Only includes skills scored 7+ in quality audit (2026-03-21)
RULES=(
  # Core backend — daily use
  "nestjs-expert.mdc|${CURSOR_SKILLS_DIR}/nestjs-expert/SKILL.md"
  "backend-dev-guidelines.mdc|${CURSOR_SKILLS_DIR}/backend-dev-guidelines/SKILL.md"
  "nosql-expert.mdc|${CURSOR_SKILLS_DIR}/nosql-expert/SKILL.md"
  "typescript-expert.mdc|${CURSOR_SKILLS_DIR}/typescript-expert/SKILL.md"
  "nodejs-best-practices.mdc|${CURSOR_SKILLS_DIR}/nodejs-best-practices/SKILL.md"

  # API & architecture
  "api-patterns.mdc|${CURSOR_SKILLS_DIR}/api-patterns/SKILL.md"
  "architecture.mdc|${CURSOR_SKILLS_DIR}/architecture/SKILL.md"

  # Code quality & review
  "code-reviewer.mdc|${CURSOR_SKILLS_DIR}/code-reviewer/SKILL.md"
  "systematic-debugging.mdc|${CURSOR_SKILLS_DIR}/systematic-debugging/SKILL.md"

  # Testing
  "javascript-testing-patterns.mdc|${CURSOR_SKILLS_DIR}/javascript-testing-patterns/SKILL.md"
  "test-driven-development.mdc|${CURSOR_SKILLS_DIR}/test-driven-development/SKILL.md"

  # Frontend
  "react-best-practices.mdc|${CURSOR_SKILLS_DIR}/react-best-practices/SKILL.md"
  "nextjs-best-practices.mdc|${CURSOR_SKILLS_DIR}/nextjs-best-practices/SKILL.md"
  "nextjs-app-router-patterns.mdc|${CURSOR_SKILLS_DIR}/nextjs-app-router-patterns/SKILL.md"

  # Infrastructure
  "docker-expert.mdc|${CURSOR_SKILLS_DIR}/docker-expert/SKILL.md"
  "aws-skills.mdc|${CURSOR_SKILLS_DIR}/aws-skills/SKILL.md"
  "git-advanced-workflows.mdc|${CURSOR_SKILLS_DIR}/git-advanced-workflows/SKILL.md"

  # Security
  "api-security-best-practices.mdc|${CURSOR_SKILLS_DIR}/api-security-best-practices/SKILL.md"
  "backend-security-coder.mdc|${CURSOR_SKILLS_DIR}/backend-security-coder/SKILL.md"

  "bash-pro.mdc|${CURSOR_SKILLS_DIR}/bash-pro/SKILL.md"

  # ~/.codex/skills/* — personal skills
  "backend-architect-brain.mdc|${CODEX_SKILLS_DIR}/backend-architect-brain/SKILL.md"
)

echo "Creating symlinks in ${RULES_DIR} ..."

for entry in "${RULES[@]}"; do
  rule_file="${entry%%|*}"
  target="${entry##*|}"
  dest="${RULES_DIR}/${rule_file}"

  if [[ -L "${dest}" || -f "${dest}" ]]; then
    echo "  - ${rule_file} already exists, skipping."
    continue
  fi

  if [[ ! -f "${target}" ]]; then
    echo "  ! WARNING: Target SKILL not found for ${rule_file}: ${target}" >&2
    continue
  fi

  ln -s "${target}" "${dest}"
  echo "  + Linked ${dest} -> ${target}"
done

echo "Done. Cursor rules are set up for this project."
