---
name: audit
description: Orchestrate a security audit of the current codebase by running all detectors
disable-model-invocation: true
---

# Security Audit Orchestrator

You are a security audit orchestrator for smart contract codebases.

## Phase 1: Build Context (optional)

If the Trail of Bits `audit-context-building` skill is installed, run it first and save the output to `.audit/context.md`. This gives detectors shared codebase understanding so they don't each re-explore independently.

If it's not installed, skip this phase. Detectors will explore the codebase on their own.

## Phase 2: Run Detectors

Detectors live at `~/.claude/skills/detectors/`. Each subdirectory there (e.g. `~/.claude/skills/detectors/erc7201-storage/`) contains a `SKILL.md` that defines one detector.

List all subdirectories in `~/.claude/skills/detectors/`. For each one, read its `SKILL.md` and spawn a sub-agent to execute it. Run all sub-agents in parallel.

Each sub-agent should:

1. Read `.audit/context.md` if it exists (from Phase 1)
2. Read the detector's `SKILL.md` and follow its methodology against the current project's codebase
3. Write structured findings to `.audit/findings/<detector-name>.md` in the current project directory

Use this format for each findings file:

```markdown
# <Detector Name>

## Status
<PASS | FAIL | NOT_APPLICABLE | INFO>

## Severity
<CRITICAL | HIGH | MEDIUM | LOW | INFO | BEST PRACTICES | N/A>

## Summary
<1-2 sentence summary>

## Findings
<Detailed findings with file paths, code snippets and explanations>

## Recommendations
<Specific fixes if applicable>
```

Each finding should follow the following flow:
- introduce context about a specific piece of code to let reader that is
  unfamiliar with it, get to know the background info required to understand the
  bug (don't introduce the problem or impact yet).
- introduce the problem; explain what is wrong and why
- introduce the impact of the problem

## Phase 3: Aggregate Report

After all detectors complete, read all files in `.audit/findings/` and produce `.audit/report.md`:

1. **Summary table** — detector name, status, severity, finding count
2. **Critical/High findings** — expanded details, grouped
3. **Medium/Low/Info findings** — condensed
4. **Detectors that returned NOT_APPLICABLE** — listed briefly so the user knows they ran

Print the summary table to the user when done.
