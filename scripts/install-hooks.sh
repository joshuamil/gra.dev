#!/usr/bin/env bash
#
# Activate the repository's git hooks on this machine. Run once after cloning.
# Symlinks .git/hooks/pre-commit to the committed hook in .githooks so the
# hook stays current with the repository.

set -euo pipefail

repo_root="$(git rev-parse --show-toplevel)"
hook_src="$repo_root/.githooks/pre-commit"
hook_dst="$repo_root/.git/hooks/pre-commit"

chmod +x "$hook_src"
ln -sf "../../.githooks/pre-commit" "$hook_dst"

echo "Installed pre-commit hook (.git/hooks/pre-commit -> .githooks/pre-commit)."
