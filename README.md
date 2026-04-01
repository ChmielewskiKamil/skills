# Web3 Audit Skills for Claude Code

Reusable security audit detectors for smart contract codebases. Each detector encodes knowledge about a specific bug class or best practice, following the philosophy: **find a bug once, encode it, never miss it again.**

## Install

```bash
git clone https://github.com/ChmielewskiKamil/skills
cd skills
chmod +x install.sh
./install.sh
```

This symlinks `~/.claude/skills` to the cloned repo so skills are available in every Claude Code session. To update, just `git pull`.

## Usage

In any smart contract project:

```
/audit
```

This runs the orchestrator which:
1. If Trail of Bits `audit-context-building` skill is installed, runs it first to build `.audit/context.md` (skipped otherwise)
2. Spawns sub-agents for each detector in parallel
3. Each detector writes findings to `.audit/findings/<name>.md`
4. Aggregates results into `.audit/report.md`

You can also run individual detectors:

```
/detectors/erc7201-storage
```

## Detectors

| Detector | Type | Description |
|----------|------|-------------|
| `erc7201-storage` | Conformance | Checks ERC-7201 namespaced storage annotation correctness |

## Adding a Detector

Create a new directory under `skills/detectors/<name>/` with a `SKILL.md`:

```
skills/detectors/my-detector/
  SKILL.md          # detector prompt
  references/       # optional: spec excerpts, examples
```

Your `SKILL.md` should follow this structure:
1. **Background** — what the bug/best practice is
2. **Common Violations** — what to look for
3. **Methodology** — step-by-step (check applicability first!)
4. **Report format** — use the standard findings format

The orchestrator will automatically discover and run it.

## Compatibility

Works well with the [Trail of Bits skills](https://github.com/trailofbits/skills) `audit-context-building` skill if installed. Not required.

## License

MIT
