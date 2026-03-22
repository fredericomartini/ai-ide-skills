#!/usr/bin/env bash
set -euo pipefail

# Reproduce a standard .cursor/rules setup in the current project.
# Run from the project root: ./install-cursor-skills.sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RULES_DIR=".cursor/rules"
CURSOR_SKILLS_DIR="${HOME}/.cursor/skills"
CODEX_SKILLS_DIR="${HOME}/.codex/skills"
REPO_RAW="https://raw.githubusercontent.com/fredericomartini/ai-ide-skills/main"

echo "Setting up Cursor rules in: ${RULES_DIR}"

mkdir -p "${RULES_DIR}"

############################################
# 1) Ensure 00-skill-router.mdc is present #
############################################

SKILL_ROUTER_FILE="${RULES_DIR}/00-skill-router.mdc"
SKILL_ROUTER_SOURCE="${SCRIPT_DIR}/00-skill-router.mdc"

if [[ ! -f "${SKILL_ROUTER_FILE}" ]]; then
  if [[ -f "${SKILL_ROUTER_SOURCE}" ]]; then
    cp "${SKILL_ROUTER_SOURCE}" "${SKILL_ROUTER_FILE}"
    echo "Created ${SKILL_ROUTER_FILE} (copied from ${SKILL_ROUTER_SOURCE})"
  else
    echo "Downloading 00-skill-router.mdc from GitHub ..."
    curl -fsSL "${REPO_RAW}/00-skill-router.mdc" -o "${SKILL_ROUTER_FILE}"
    echo "Created ${SKILL_ROUTER_FILE} (downloaded from GitHub)"
  fi
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

  if [[ ! -f "${src}" ]]; then
    echo "  ! WARNING: Personal skill source not found: ${src}" >&2
    continue
  fi

  mkdir -p "${dest_dir}"

  if [[ -f "${dest}" ]]; then
    echo "  - ${skill} already installed, skipping."
  else
    cp "${src}" "${dest}"
    echo "  + Installed ${skill} -> ${dest}"
  fi
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
  "typescript-pro.mdc|${CURSOR_SKILLS_DIR}/typescript-pro/SKILL.md"
  "typescript-expert.mdc|${CURSOR_SKILLS_DIR}/typescript-expert/SKILL.md"
  "nodejs-best-practices.mdc|${CURSOR_SKILLS_DIR}/nodejs-best-practices/SKILL.md"

  # API & architecture
  "api-patterns.mdc|${CURSOR_SKILLS_DIR}/api-patterns/SKILL.md"
  "architecture.mdc|${CURSOR_SKILLS_DIR}/architecture/SKILL.md"

  # Code quality & review
  "code-reviewer.mdc|${CURSOR_SKILLS_DIR}/code-reviewer/SKILL.md"
  "code-review-checklist.mdc|${CURSOR_SKILLS_DIR}/code-review-checklist/SKILL.md"
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

  # Python (on demand)
  "python-pro.mdc|${CURSOR_SKILLS_DIR}/python-pro/SKILL.md"
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
