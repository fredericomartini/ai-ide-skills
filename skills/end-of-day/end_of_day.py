#!/usr/bin/env python3
"""
End of Day — Obsidian Daily Notes
----------------------------------
Run when you're done working for the day:
  python3 end_of_day.py

What it does:
  1. Archives Today.md as {today_date}.md
  2. Extracts all unchecked tasks ( - [ ] )
  3. Resets Today.md for tomorrow with carried-over items

Requirements:
  - OBSIDIAN_VAULT env var set to your vault's absolute path
  - Vault uses the Carbon Voice daily note structure (Carbon Voice/Daily/Today.md)
"""

import os
import re
import subprocess
from datetime import datetime, timedelta

VAULT = os.environ.get("OBSIDIAN_VAULT") or os.path.expanduser("~/Documents/Obsidian")
DAILY_DIR = os.path.join(VAULT, "Carbon Voice", "Daily")
TODAY_FILE = os.path.join(DAILY_DIR, "Today.md")


def date_str(d):
    return d.strftime("%d-%m-%Y")


def extract_unchecked(lines):
    """Keep only unchecked task lines, preserving indentation."""
    return [line for line in lines if re.search(r"-\s\[\s\]", line)]


def build_new_today(archived_date, new_date, unchecked_lines):
    if unchecked_lines:
        carried = "\n".join(unchecked_lines)
    else:
        carried = "- (nothing carried over — clean slate! 🎉)"

    return f"""#daily #CarbonVoice
# [[Today]] [[Carbon Voice]]
#### ↩️ Yesterday [[{archived_date}]]
## 📆 [[{new_date}]]

### 🔄 Carried Over
{carried}

### ✅ To-Do
- [ ]

### 📝 Notes & Blockers

"""


def main():
    if not os.path.exists(TODAY_FILE):
        print(f"❌ Today.md not found at:\n   {TODAY_FILE}")
        return

    today = datetime.now()
    today_str = date_str(today)
    tomorrow_str = date_str(today + timedelta(days=1))

    # Read current Today.md
    with open(TODAY_FILE, "r") as f:
        lines = f.read().splitlines()

    # Archive as today's date
    archive_path = os.path.join(DAILY_DIR, f"{today_str}.md")
    with open(archive_path, "w") as f:
        f.write("\n".join(lines))
    print(f"✅ Archived  → Carbon Voice/Daily/{today_str}.md")

    # Extract unchecked tasks
    unchecked = extract_unchecked(lines)
    print(f"📋 Carrying over {len(unchecked)} unchecked task(s)")
    for task in unchecked:
        print(f"   {task.strip()}")

    # Reset Today.md for tomorrow
    new_content = build_new_today(today_str, tomorrow_str, unchecked)
    with open(TODAY_FILE, "w") as f:
        f.write(new_content)

    print(f"✅ Today.md  → reset for {tomorrow_str}")

    # Commit and push to GitHub
    try:
        subprocess.run(["git", "-C", VAULT, "add", "-A"], check=True)
        subprocess.run(["git", "-C", VAULT, "commit", "-m", f"end of day: {today_str}"], check=True)
        subprocess.run(["git", "-C", VAULT, "push"], check=True)
        print(f"☁️  Pushed    → github (end of day: {today_str})")
    except subprocess.CalledProcessError as e:
        print(f"⚠️  Git push failed: {e}")

    print("\n👋 Done for today. See you tomorrow!")


if __name__ == "__main__":
    main()
