cask "1context" do
  version "0.1.5"
  sha256 "7404b83c849ee2f6f7f87755afffb9d80220cda8026054c2422559e77c910b06"

  url "https://github.com/hapticasensorics/1context/releases/download/v#{version}/1context-#{version}-macos-arm64.tar.gz"
  name "1Context"
  desc "Agentic context engine for local project memory"
  homepage "https://haptica.ai/"

  depends_on arch: :arm64

  app "1context-#{version}-macos-arm64/1Context.app"
  binary "#{appdir}/1Context.app/Contents/MacOS/1context-cli", target: "1context"
  binary "#{appdir}/1Context.app/Contents/MacOS/onecontextd", target: "onecontextd"

  postflight do
    system_command "/bin/bash",
                   args: [
                     "-c",
                     "#{staged_path}/1context-#{version}-macos-arm64/scripts/install-macos-launch-agents.sh " \
                     "#{appdir}/1Context.app " \
                     "#{appdir}/1Context.app/Contents/MacOS/1context-cli || true",
                   ]
  end

  uninstall launchctl: [
              "com.haptica.1context",
              "com.haptica.1context.menu",
            ],
            quit:      "com.haptica.1context.menu",
            delete:    [
              "~/Library/LaunchAgents/com.haptica.1context.menu.plist",
              "~/Library/LaunchAgents/com.haptica.1context.plist",
            ]

  zap trash: [
    "~/.config/1context",
    "~/Library/Application Support/1Context",
    "~/Library/Logs/1Context",
  ]

  caveats <<~EOS
    1Context installs a menu bar app and local runtime.

    To stop 1Context:
      1context stop

    To remove 1Context but keep local data:
      brew uninstall --cask hapticasensorics/tap/1context

    To remove local data too:
      brew uninstall --cask --zap hapticasensorics/tap/1context
  EOS
end
