#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OLD_CASK_DIR="$(mktemp -d)"
OLD_CASK="$OLD_CASK_DIR/1context.rb"
trap 'rm -rf "$OLD_CASK_DIR"' EXIT

cat >"$OLD_CASK" <<'RUBY'
cask "1context" do
  version "0.1.49"
  sha256 "2ad824f9382807c0adf580ea244231a111ef79137086850b835182cc2d0b8e05"

  url "https://github.com/hapticasensorics/1context/releases/download/v#{version}/1context-#{version}-macos-arm64.tar.gz",
      verified: "github.com/hapticasensorics/1context/"
  name "1Context"
  desc "Agentic context engine for local project memory"
  homepage "https://haptica.ai/"

  depends_on arch: :arm64
  depends_on macos: ">= :ventura"
  depends_on formula: "uv"
  depends_on formula: "node"

  app "1context-#{version}-macos-arm64/1Context.app"
  binary "#{appdir}/1Context.app/Contents/MacOS/1context-cli", target: "1context"

  postflight do
    system_command "/bin/bash",
                   args: [
                     "-c",
                     "#{staged_path}/1context-#{version}-macos-arm64/scripts/install-macos-launch-agents.sh " \
                     "#{appdir}/1Context.app " \
                     "#{appdir}/1Context.app/Contents/MacOS/1context-cli",
                   ]
  end

  uninstall_preflight do
    uid = Process.uid
    labels = [
      "com.haptica.1context.menu",
      "com.haptica.1context",
    ]

    system_command "#{appdir}/1Context.app/Contents/MacOS/1context-cli",
                   args:         ["agent", "integrations", "uninstall"],
                   must_succeed: false,
                   print_stderr: false

    system_command "/usr/bin/osascript",
                   args:         ["-e", "tell application id \"com.haptica.1context.menu\" to quit"],
                   must_succeed: false,
                   print_stderr: false

    labels.each do |label|
      plist = File.expand_path("~/Library/LaunchAgents/#{label}.plist")
      system_command "/bin/launchctl",
                     args:         ["bootout", "gui/#{uid}/#{label}"],
                     must_succeed: false,
                     print_stderr: false
      system_command "/bin/launchctl",
                     args:         ["bootout", "gui/#{uid}", plist],
                     must_succeed: false,
                     print_stderr: false
    end
  end

  uninstall_postflight do
    FileUtils.rm_f File.expand_path("~/Library/LaunchAgents/com.haptica.1context.menu.plist")
    FileUtils.rm_f File.expand_path("~/Library/LaunchAgents/com.haptica.1context.plist")
  end
end
RUBY

cleanup() {
  brew uninstall --cask --zap 1context >/dev/null 2>&1 || true
  brew uninstall --cask --zap hapticasensorics/tap/1context >/dev/null 2>&1 || true
}
trap 'cleanup; rm -rf "$OLD_CASK_DIR"' EXIT

cleanup
brew install --cask "$OLD_CASK"

if [[ ! -x /Applications/1Context.app/Contents/MacOS/1context-cli ]]; then
  echo "Previous public cask did not install /Applications/1Context.app." >&2
  exit 1
fi

brew tap hapticasensorics/tap "$ROOT" >/dev/null
brew upgrade --cask --greedy hapticasensorics/tap/1context

if [[ ! -x /Applications/1Context.app/Contents/MacOS/1context-cli ]]; then
  echo "Upgraded cask did not leave an executable bundled CLI." >&2
  exit 1
fi

installed_version="$(/Applications/1Context.app/Contents/MacOS/1context-cli --version)"
expected_version="$(ruby -ne 'puts $1 if /^  version "([^"]+)"/ =~ $_' "$ROOT/Casks/1context.rb")"
if [[ "$installed_version" != "$expected_version" ]]; then
  echo "Expected upgraded CLI version $expected_version, got $installed_version." >&2
  exit 1
fi

brew uninstall --cask --zap hapticasensorics/tap/1context
