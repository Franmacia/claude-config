---
name: test-driven-development
description: Use when implementing any feature or bugfix, before writing implementation code
---

# Test-Driven Development (TDD)

**Iron Law:** NO PRODUCTION CODE WITHOUT A FAILING TEST FIRST. Wrote code before the test? Delete it. Start over.

**Exceptions (ask user):** throwaway prototypes, generated code, config files.

## Red-Green-Refactor Cycle

**RED** — Write one minimal failing test. One behavior, clear name, real code (no mocks unless unavoidable).

**Verify RED** — Run test. Confirm it fails because the feature is missing, not due to a typo. If it passes → you're testing existing behavior, fix the test.

**GREEN** — Write the simplest code that makes the test pass. No extra features, no YAGNI.

**Verify GREEN** — Run test suite. All tests pass, no warnings.

**REFACTOR** — Remove duplication, improve names. Keep tests green. Don't add behavior.

**Repeat** for next behavior.

## Red Flags — STOP, delete code, start over

- Code written before test
- Test passes immediately after writing
- Can't explain why test failed
- "I'll test after" / "I already manually tested" / "just this once"

## Checklist before marking complete

- [ ] Every new function/method has a test
- [ ] Watched each test fail before implementing
- [ ] Wrote minimal code to pass each test
- [ ] All tests pass, output pristine
- [ ] Edge cases covered

## When stuck

- Can't test it → simplify the interface
- Must mock everything → code too coupled, use dependency injection
- Test setup huge → extract helpers or simplify design

## References (load on demand)

- `testing-anti-patterns.md` — avoid testing mocks instead of real behavior
