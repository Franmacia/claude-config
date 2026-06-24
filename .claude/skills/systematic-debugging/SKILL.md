---
name: systematic-debugging
description: Use when encountering any bug, test failure, or unexpected behavior, before proposing fixes
---

# Systematic Debugging

**Iron Law:** NO FIXES WITHOUT ROOT CAUSE FIRST. If you haven't completed Phase 1, you cannot propose fixes.

## The Four Phases

### Phase 1: Root Cause Investigation

1. Read error messages completely — stack traces, line numbers, error codes.
2. Reproduce consistently. If not reproducible → gather data, don't guess.
3. Check recent changes: git diff, new deps, config changes.
4. Multi-component system → add boundary instrumentation first, run once to find WHERE it breaks, then investigate that component.
5. Error deep in call stack → trace backward with `root-cause-tracing.md`.

### Phase 2: Pattern Analysis

1. Find similar working code in same codebase.
2. Read reference implementation completely — don't skim.
3. List every difference between working and broken, however small.

### Phase 3: Hypothesis + Minimal Test

1. State: "I think X is root cause because Y." Be specific.
2. Make the SMALLEST change to test hypothesis. One variable at a time.
3. Didn't work? Form NEW hypothesis. Don't stack fixes.

### Phase 4: Implementation

1. Create failing test case first (use `superpowers:test-driven-development`).
2. ONE fix addressing root cause. No "while I'm here" changes.
3. Verify: test passes, no regressions.
4. After 3 failed fixes → STOP. Question architecture before attempting more. Discuss with user.

## Red Flags — STOP, return to Phase 1

- "Quick fix for now" / "Just try X" / "It's probably..."
- Proposing solutions before tracing data flow
- Multiple fixes at once
- 3rd fix attempt without architectural discussion

## References (load on demand)

- `root-cause-tracing.md` — backward call stack tracing
- `defense-in-depth.md` — validation at multiple layers
- `condition-based-waiting.md` — replace arbitrary timeouts
