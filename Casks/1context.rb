cask "1context" do
  version "0.1.12"
  sha256 "85a61f724e00f7cb047ee99fc34a1ff82c3086cdb95605f957cb0fe2c422135b"

  url "https://github.com/hapticasensorics/1context/releases/download/v#{version}/1context-#{version}-macos-arm64.tar.gz",
      verified: "github.com/hapticasensorics/1context/"
  name "1Context"
  desc "Agentic context engine for local project memory"
  homepage "https://haptica.ai/"

  depends_on arch: :arm64
  depends_on macos: ">= :ventura"

  app "1context-#{version}-macos-arm64/1Context.app"
  binary "#{appdir}/1Context.app/Contents/MacOS/1context-cli", target: "1context"

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
            quit:      "com.haptica.1context.menu"

  uninstall_postflight do
    FileUtils.rm_f File.expand_path("~/Library/LaunchAgents/com.haptica.1context.menu.plist")
    FileUtils.rm_f File.expand_path("~/Library/LaunchAgents/com.haptica.1context.plist")
  end

  zap trash: [
    "~/1Context",
    "~/Library/Application Support/1Context",
    "~/Library/Caches/1Context",
    "~/Library/Logs/1Context",
    "~/Library/Preferences/com.haptica.1context.plist",
  ]

  caveats <<~EOS
    1Context installs a menu bar app and local runtime.

    To stop 1Context:
      1context stop

    To remove 1Context but keep local data:
      brew uninstall --cask hapticasensorics/tap/1context

    To remove user content and local data too:
      brew uninstall --cask --zap hapticasensorics/tap/1context
  EOS
end
