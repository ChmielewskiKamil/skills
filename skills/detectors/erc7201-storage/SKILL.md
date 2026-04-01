---
name: erc7201-storage
description: Check ERC-7201 namespaced storage conformance and annotation correctness
disable-model-invocation: false
allowed-tools:
  - Read
  - Grep
  - Glob
  - Agent
---

# ERC-7201 Namespaced Storage Conformance

## Background

ERC-7201 defines a convention for namespaced storage in upgradeable contracts. Storage structs must be annotated with a NatSpec `@custom:storage-location` tag so that tooling (e.g. OpenZeppelin Upgrades) can verify storage layout compatibility.

The correct annotation format is:

```solidity
/// @custom:storage-location erc7201:<namespace>
struct MyStorage {
    uint256 value;
}
```

The namespace is typically derived as `keccak256(abi.encode(uint256(keccak256("<namespace.id>")) - 1)) & ~bytes32(uint256(0xff))`.

## Common Violations

1. **Missing annotation**: A struct is used as namespaced storage but has no `@custom:storage-location` tag
2. **Wrong annotation key**: Using `@custom:storage-slot`, `@custom:storage-definition`, `@custom:storage-layout`, or other variants instead of `@custom:storage-location`
3. **Wrong annotation scheme**: Using something other than `erc7201:` as the scheme (e.g. `@custom:storage-location diamond:<ns>` when ERC-7201 is intended)
4. **Mismatched namespace**: The namespace string in the annotation doesn't match the actual keccak derivation in the code

## Methodology

### Step 1: Determine Applicability

If `.audit/context.md` exists in the current working directory, read it for codebase understanding. Either way, search the current project's source files (NOT `~/.claude/`) for indicators of namespaced storage:

- `keccak256` used to derive a fixed storage slot
- Inline assembly with `.slot` access patterns
- OpenZeppelin's `StorageSlot` library usage
- ERC-7201 mentioned in comments or imports
- Diamond storage patterns (`DiamondStorage`, `LibDiamond`)
- Structs accessed via a function that returns a storage pointer from a fixed slot

If none of these patterns exist, write status `NOT_APPLICABLE` and stop.

### Step 2: Inventory Storage Structs

Find all structs that are used as namespaced storage. For each, record:
- File path and line number
- Struct name
- How it's accessed (what function returns a pointer to it, what slot is used)

### Step 3: Check Annotations

For each storage struct found:

1. Check if a `@custom:storage-location` NatSpec comment exists on the struct
2. Check for **incorrect annotation variants**:
   - `@custom:storage-slot` (wrong)
   - `@custom:storage-definition` (wrong)
   - `@custom:storage-layout` (wrong)
   - Any other `@custom:storage-*` tag that isn't `storage-location`
3. If the annotation exists, verify the scheme is `erc7201:<namespace>`
4. If possible, verify the namespace string matches the keccak derivation in code

### Step 4: Report

Write findings to `.audit/findings/erc7201-storage.md` using the standard format.

For each finding, include:
- The file path and line number of the struct
- What annotation is present (or that it's missing)
- What the correct annotation should be
- The storage slot derivation if identifiable

Severity guide:
- Missing annotation on a struct used in an upgradeable contract: **MEDIUM**
- Wrong annotation key (e.g. `storage-slot` instead of `storage-location`): **MEDIUM**
- Wrong namespace value: **LOW** (tooling may still catch this)
- Missing annotation on non-upgradeable contract: **INFO**
