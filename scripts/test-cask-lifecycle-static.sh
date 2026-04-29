#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CASK="$ROOT/Casks/1context.rb"

if grep -Eq '^[[:space:]]*uninstall[[:space:]]+launchctl:' "$CASK"; then
  echo "Do not use Homebrew's uninstall launchctl helper for 1Context." >&2
  echo "It probes both user and root launchctl services and can trigger sudo/password prompts." >&2
  exit 1
fi

grep -q 'uninstall_preflight do' "$CASK"
grep -q 'gui/#{uid}/#{label}' "$CASK"
grep -q '/bin/launchctl' "$CASK"
grep -q 'print_stderr: false' "$CASK"
grep -q 'com.haptica.1context.menu' "$CASK"
grep -q 'com.haptica.1context' "$CASK"

if grep -Eq 'sudo:[[:space:]]*true|sudo_as_root:[[:space:]]*true' "$CASK"; then
  echo "1Context cask lifecycle must not request sudo." >&2
  exit 1
fi

ruby -c "$CASK" >/dev/null
echo "1Context cask lifecycle checks passed."
