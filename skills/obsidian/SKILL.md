---
name: obsidian
description: "Frederico's personal Obsidian vault assistant. Triggered whenever he mentions 'Obsidian', his notes, vault, ideas, inbox, reading list, brainstorm, scripts, personal docs, or meetings. Handles create, read, update, and search operations across the vault."
risk: low
source: personal
date_added: "2026-03-20"
---

# Obsidian Vault Assistant

**Vault:** `$OBSIDIAN_VAULT` (set in `settings.json` → `env.OBSIDIAN_VAULT`)

---

## 1. Destination Routing

The single source of truth for where content goes. Read this first.

| Trigger phrase | File | Action |
|---|---|---|
| "add to-do", "task", "work item", "today" | `Carbon Voice/Daily/Today.md` | append `- [ ] item` under `### ✅ To-Do` |
| "carry over", "carried over" | `Carbon Voice/Daily/Today.md` | append `- [ ] item` under `### 🔄 Carried Over` |
| "inbox", "brainstorm", "dump", "scratch", "rough thought", "add this idea" | `INBOX.md` | append `- [ ] item` |
| "reading list", "read later", "future reading", "save this link" | `READING.md` | append `- [ ] item` |
| new developed idea, product, concept | `Ideas/kebab-case-name.md` | new file from template |
| personal document or reference | `Personal/descriptive-name.md` | new file from template |
| code snippet or utility script | `Scripts/descriptive-name.md` | new file from template |
| meeting notes | `Meetings/person-name/YYYY-MM-DD.md` | new file from template |

**Daily file naming:** `Today.md` = current day (rolling) · `DD-MM-YYYY.md` = archived days

---

## 2. Write Protocol

Run this **before every CREATE, UPDATE, or DELETE**. Skip for READ-only operations.

```bash
if [ -n "$(git -C "$OBSIDIAN_VAULT" status --porcelain)" ]; then
  git -C "$OBSIDIAN_VAULT" add -A && \
  git -C "$OBSIDIAN_VAULT" commit -m "pre-change: $(date '+%d-%m-%Y %H:%M')" && \
  git -C "$OBSIDIAN_VAULT" push
fi
```

---

## 3. Operations

**UPDATE** — Most common. Run write protocol → read file → apply targeted edit → confirm file path + what changed.

**CREATE** — Run write protocol → pick destination from routing table → apply template below → confirm `Created path/file.md`.

**READ** — No backup needed. Present content cleanly. Strip markdown when summarizing, keep it when showing full content.

**DELETE** — Run write protocol → ask for explicit confirmation with file path before proceeding.

**SEARCH** — Use Grep across vault. Show matching file paths + the relevant line. List all matches and let Frederico pick.

---

## 4. Templates

### Ideas — `Ideas/kebab-case-name.md`
```markdown
#idea #tag2 #tag3
# Idea Title

## 💡 Overview

## 🎯 Goal

## 🔧 How It Could Work

## 📝 Notes & Next Steps
-
```

### Personal — `Personal/descriptive-name.md`
```markdown
#personal #tag2
# Document Title

## Overview

## Content

## Notes
```

### Scripts — `Scripts/descriptive-name.md`
```markdown
#script #language #tag3
# Script Name

## Purpose

## Usage
```bash
command here
```

## Code
```language
code here
```

## Notes
-
```

### Meetings — `Meetings/person-name/YYYY-MM-DD.md`
```markdown
#meeting #tag2 #tag3
# Meeting — Person / Topic
## 📅 YYYY-MM-DD | Attendees: Name, Name

## 🎯 Agenda / Purpose

## 📝 Notes

## ✅ Action Items
- [ ] action — owner

## 💡 Ideas Captured

## 🎙️ Transcription
```

### Carbon Voice Daily — `Carbon Voice/Daily/Today.md`
```markdown
#daily #CarbonVoice
# [[Today]] [[Carbon Voice]]
#### ↩️ Yesterday [[DD-MM-YYYY]]
## 📆 [[DD-MM-YYYY]]

### 🔄 Carried Over

### ✅ To-Do
- [ ]

### 📝 Notes & Blockers
```

**Tag rules:** Max 5 tags · inline at top (not YAML) · first tag = type: `#daily` `#idea` `#script` `#personal` `#meeting` `#inbox` `#reading`

---

## 5. Rules

- Always confirm the operation with the file path after completing it
- Never delete files without explicit confirmation
- If destination is ambiguous, check routing table first — only ask if still unclear
- Wiki links (`[[Name]]`) for cross-references between notes
- Keep files focused — one idea, one script, one topic per file
