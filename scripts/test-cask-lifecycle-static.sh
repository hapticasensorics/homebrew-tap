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
grep -q '1Context-#{version}-macos-arm64.dmg' "$CASK"
grep -q 'app "1Context.app"' "$CASK"
grep -q 'auto_updates true' "$CASK"
grep -q '"/usr/bin/open"' "$CASK"
grep -q '"uninstall", "--keep-app"' "$CASK"
grep -q 'gui/#{uid}/#{label}' "$CASK"
grep -q '/bin/launchctl' "$CASK"
grep -q 'print_stderr: false' "$CASK"
grep -q 'com.haptica.1context.menu' "$CASK"
grep -q 'com.haptica.1context' "$CASK"

if grep -Eq 'sudo:[[:space:]]*true|sudo_as_root:[[:space:]]*true' "$CASK"; then
  echo "1Context cask lifecycle must not request sudo." >&2
  exit 1
fi

if grep -q 'install-macos-launch-agents.sh' "$CASK"; then
  echo "1Context cask must not install legacy launch agents directly." >&2
  exit 1
fi

if grep -q '1context-#{version}-macos-arm64.tar.gz' "$CASK"; then
  echo "1Context cask must install the signed DMG, not the legacy tarball." >&2
  exit 1
fi

ruby -c "$CASK" >/dev/null
echo "1Context cask lifecycle checks passed."
