---
name: caveman-stats
description: Use only for /caveman-stats: report real session token usage and estimated caveman savings from Claude Code logs.
---

This skill is delivered by `hooks/caveman-stats.js` (read by `hooks/caveman-mode-tracker.js` on `/caveman-stats`). The model does not need to do anything when this skill fires — the hook returns `decision: "block"` with the formatted stats as the reason. The user sees the numbers immediately.
