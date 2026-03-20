---
name: end-of-day
description: "Daily Obsidian workflow skill. Start of day: reads Today.md and shows what's on the plate. End of day: runs end_of_day.py, archives the day, and summarizes done vs carry-over."
risk: low
source: personal
date_added: "2026-03-19"
---

# Daily Workflow

Handles both ends of your workday in Obsidian.

## Trigger Phrases

### Start of Day — read Today.md and brief you
- "what do I have for today"
- "what's on my plate"
- "what am I working on today"
- "start of day"
- "good morning, what's today"
- "show me today"

### End of Day — archive and summarize
- "we are done for today"
- "close the day"
- "end of day"
- "wrap up today"
- "I'm done for today"
- "run end of day"

---

## START OF DAY

### Step 1 — Read Today.md

File location:
```
$OBSIDIAN_VAULT/Carbon Voice/Daily/Today.md
```

Extract:
- The date from the `## 📆 [[DD-MM-YYYY]]` line
- **Carried Over** — `- [ ]` items under the `🔄 Carried Over` section
- **To-Do** — `- [ ]` items under the `✅ To-Do` section
- **Notes & Blockers** — any content under that section

### Step 2 — Deliver the morning briefing

```
════ START OF DAY — {DD-MM-YYYY} ════════════

🔄 CARRIED OVER ({count} items)
  • item one
  • item two

✅ TO-DO ({count} items)
  • item one
  • item two

📝 NOTES & BLOCKERS
  {content or "nothing noted"}

💪 {short motivating opener, 8–12 words, direct and personal}
```

---

## END OF DAY

### Step 1 — Run the script

```bash
python3 "$OBSIDIAN_VAULT/end_of_day.py"
```

Capture the output to confirm success.

### Step 2 — Read the archived daily note

Today's archived file:
```
$OBSIDIAN_VAULT/Carbon Voice/Daily/{DD-MM-YYYY}.md
```

Extract:
- **Done** — lines containing `- [x]`
- **Carried Over** — lines containing `- [ ]`

### Step 3 — Deliver the day summary

```
════ END OF DAY — {DD-MM-YYYY} ══════════════

✅ DONE TODAY ({count} items)
  • task one
  • task two

🔄 CARRYING OVER ({count} items)
  • unfinished task one
  • unfinished task two

👋 {short closing message, 8–12 words, warm and direct}
```

---

## Rules (both modes)

- Strip checkbox syntax (`- [x]`, `- [ ]`, tabs) — show clean task names
- Preserve parent/child indentation in the output
- If nothing was completed at end of day: acknowledge it honestly, no filler
- If everything was completed: celebrate it briefly
- Do NOT re-run the end-of-day script if it already ran successfully in this session

## Requirements

- `OBSIDIAN_VAULT` env var set in Claude Code `settings.json` → `env` section
- `end_of_day.py` script present at the root of your Obsidian vault
- Vault uses the Carbon Voice daily note structure (`Carbon Voice/Daily/Today.md`)
