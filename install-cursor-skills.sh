#!/usr/bin/env bash
set -euo pipefail

# Reproduce a standard .cursor/rules setup in the current project.
# Run from the project root: ./install-cursor-skills.sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RULES_DIR=".cursor/rules"
CURSOR_SKILLS_DIR="${HOME}/.cursor/skills"
CODEX_SKILLS_DIR="${HOME}/.codex/skills"

echo "Setting up Cursor rules in: ${RULES_DIR}"

mkdir -p "${RULES_DIR}"

############################################
# 1) Ensure 00-skill-router.mdc is present #
############################################

SKILL_ROUTER_FILE="${RULES_DIR}/00-skill-router.mdc"
SKILL_ROUTER_SOURCE="${SCRIPT_DIR}/00-skill-router.mdc"

if [[ ! -f "${SKILL_ROUTER_FILE}" ]]; then
  if [[ ! -f "${SKILL_ROUTER_SOURCE}" ]]; then
    echo "ERROR: Source file not found: ${SKILL_ROUTER_SOURCE}" >&2
    exit 1
  fi
  cp "${SKILL_ROUTER_SOURCE}" "${SKILL_ROUTER_FILE}"
  echo "Created ${SKILL_ROUTER_FILE} (copied from ${SKILL_ROUTER_SOURCE})"
else
  echo "Found existing ${SKILL_ROUTER_FILE}, leaving as is."
fi

######################################
# 2) Symlink rule → SKILL mappings   #
######################################

# Each entry: "rule_name.mdc|/path/to/SKILL.md"
RULES=(
  # ~/.cursor/skills/*
  "api-design-principles.mdc|${CURSOR_SKILLS_DIR}/api-design-principles/SKILL.md"
  "architecture.mdc|${CURSOR_SKILLS_DIR}/architecture/SKILL.md"
  "aws-skills.mdc|${CURSOR_SKILLS_DIR}/aws-skills/SKILL.md"
  "backend-dev-guidelines.mdc|${CURSOR_SKILLS_DIR}/backend-dev-guidelines/SKILL.md"
  "bash-pro.mdc|${CURSOR_SKILLS_DIR}/bash-pro/SKILL.md"
  "code-reviewer.mdc|${CURSOR_SKILLS_DIR}/code-reviewer/SKILL.md"
  "javascript-testing-patterns.mdc|${CURSOR_SKILLS_DIR}/javascript-testing-patterns/SKILL.md"
  "nestjs-expert.mdc|${CURSOR_SKILLS_DIR}/nestjs-expert/SKILL.md"
  "nosql-expert.mdc|${CURSOR_SKILLS_DIR}/nosql-expert/SKILL.md"
  "python-pro.mdc|${CURSOR_SKILLS_DIR}/python-pro/SKILL.md"
  "react-best-practices.mdc|${CURSOR_SKILLS_DIR}/react-best-practices/SKILL.md"
  "search-specialist.mdc|${CURSOR_SKILLS_DIR}/search-specialist/SKILL.md"
  "systematic-debugging.mdc|${CURSOR_SKILLS_DIR}/systematic-debugging/SKILL.md"
  "typescript-pro.mdc|${CURSOR_SKILLS_DIR}/typescript-pro/SKILL.md"

  # ~/.codex/skills/*
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
