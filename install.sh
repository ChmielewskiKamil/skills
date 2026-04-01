#!/usr/bin/env bash
# Exit on any error (-e), undefined variable (-u), or pipe failure (-o pipefail)
set -euo pipefail

# Resolve the absolute path to this repo, regardless of where the script is called from.
# E.g. if you run ~/projects/skills/install.sh from /tmp, REPO_DIR is still ~/projects/skills
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Create a symlink from Claude Code's global skills directory to this repo's skills/ folder.
# -s: symbolic link (not a hard copy — points to the original files)
# -f: overwrite if a symlink already exists (safe re-run)
# -n: if ~/.claude/skills is already a symlink, replace it rather than creating a link inside it
#
# After this, ~/.claude/skills/audit/SKILL.md is actually <repo>/skills/audit/SKILL.md.
# Any git pull in the repo instantly updates what Claude Code sees.
ln -sfn "${REPO_DIR}/skills" "${HOME}/.claude/skills"

echo "Linked ${HOME}/.claude/skills -> ${REPO_DIR}/skills"
echo "To update, just 'git pull'."
