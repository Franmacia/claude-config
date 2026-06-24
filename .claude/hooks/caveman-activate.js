#!/usr/bin/env node
// caveman — Claude Code SessionStart activation hook
//
// Runs on every session start:
//   1. Writes flag file at $CLAUDE_CONFIG_DIR/.caveman-active (statusline reads this)
//   2. Emits caveman ruleset as hidden SessionStart context
//   3. Detects missing statusline config and emits setup nudge

const fs = require('fs');
const path = require('path');
const os = require('os');
const { getDefaultMode, safeWriteFlag } = require('./caveman-config');

const claudeDir = process.env.CLAUDE_CONFIG_DIR || path.join(os.homedir(), '.claude');
const flagPath = path.join(claudeDir, '.caveman-active');
const settingsPath = path.join(claudeDir, 'settings.json');

const mode = getDefaultMode();

// "off" mode — skip activation entirely, don't write flag or emit rules
if (mode === 'off') {
  try { fs.unlinkSync(flagPath); } catch (e) {}
  process.stdout.write('OK');
  process.exit(0);
}

// 1. Write flag file (symlink-safe)
safeWriteFlag(flagPath, mode);

// 2. Emit minimal activation line — full rules live in global CLAUDE.md (always present,
//    survives context compression better than hook output). SKILL.md emission removed
//    to save ~1250 tokens per session. Statusline check removed (already configured).
const INDEPENDENT_MODES = new Set(['commit', 'review', 'compress']);
const modeLabel = INDEPENDENT_MODES.has(mode) ? mode : (mode === 'wenyan' ? 'wenyan-full' : mode);

process.stdout.write('CAVEMAN MODE ACTIVE — level: ' + modeLabel);
