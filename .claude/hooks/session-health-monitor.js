#!/usr/bin/env node
// session-health-monitor.js — UserPromptSubmit hook
// Injects a context warning when session turn count crosses 120 / 150 / 200.
// Fires once per threshold per session (keyed by session ID) to avoid spam.

const fs   = require('fs');
const path = require('path');
const os   = require('os');

const THRESHOLDS = [
  {
    id:    'warn',
    turns: 120,
    msg:   (n) => `SESSION HEALTH 🟡 WARN — ${n} turnos alcanzados. Sesión acercándose al límite recomendado (150 turnos). Al terminar tu respuesta actual, añade UNA línea breve al usuario: "⚠️ Sesión a ${n} turnos — considera abrir una nueva sesión pronto (/session-health para diagnóstico)."`,
  },
  {
    id:    'alert',
    turns: 150,
    msg:   (n) => `SESSION HEALTH 🟡 ALERT — ${n} turnos. Sesión en el límite recomendado. Al terminar tu respuesta, avisa al usuario: "⚠️ Sesión a ${n} turnos — buen momento para cambiar de sesión tras la tarea actual."`,
  },
  {
    id:    'critical',
    turns: 200,
    msg:   (n) => `SESSION HEALTH 🔴 CRITICAL — ${n} turnos. Sesión muy larga, contexto posiblemente degradado. IMPORTANTE: menciona al usuario al final de tu respuesta que debe abrir una sesión nueva ahora y actualizar HANDOFF.md. Usa /session-health para diagnóstico completo.`,
  },
];

const claudeDir     = process.env.CLAUDE_CONFIG_DIR || path.join(os.homedir(), '.claude');
const warnedFlagPath = path.join(claudeDir, '.session-health-warned.json');

function countTurns(filePath) {
  try {
    return fs.readFileSync(filePath, 'utf8')
      .split('\n')
      .filter(l => { try { return JSON.parse(l).type === 'assistant'; } catch { return false; } })
      .length;
  } catch { return 0; }
}

function readState()        { try { return JSON.parse(fs.readFileSync(warnedFlagPath, 'utf8')); } catch { return {}; } }
function writeState(state)  { try { fs.writeFileSync(warnedFlagPath, JSON.stringify(state), 'utf8'); } catch {} }

let input = '';
process.stdin.on('data', c => { input += c; });
process.stdin.on('end', () => {
  try {
    const data = JSON.parse(input);
    const sessionFile = data.transcript_path;
    if (!sessionFile) return;

    const sessionId = path.basename(sessionFile, '.jsonl');
    const turns     = countTurns(sessionFile);

    // Find the highest threshold crossed (fire the most severe one not yet warned)
    const state   = readState();
    const alerted = state[sessionId] || [];

    // Walk thresholds from most severe to least — only one fires per turn
    const sorted = [...THRESHOLDS].sort((a, b) => b.turns - a.turns);
    for (const t of sorted) {
      if (turns >= t.turns && !alerted.includes(t.id)) {
        state[sessionId] = [...alerted, t.id];
        writeState(state);

        process.stdout.write(JSON.stringify({
          hookSpecificOutput: {
            hookEventName: 'UserPromptSubmit',
            additionalContext: t.msg(turns),
          },
        }));
        return; // one warning per turn max
      }
    }
  } catch {}
});
