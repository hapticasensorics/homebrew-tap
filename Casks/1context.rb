cask "1context" do
  version "0.1.48"
  sha256 "31f28d090f99b231aeb041a4acbe2134d90aa99e0a2aed9ce5cc2d78ea280bd5"

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

  zap trash: [
    "~/1Context",
    "~/Library/Application Support/1Context",
    "~/Library/Caches/1Context",
    "~/Library/Caches/com.haptica.1context.menu",
    "~/Library/HTTPStorages/1context",
    "~/Library/HTTPStorages/1context.binarycookies",
    "~/Library/HTTPStorages/com.haptica.1context.menu",
    "~/Library/HTTPStorages/com.haptica.1context.menu.binarycookies",
    "~/Library/Logs/1Context",
    "~/Library/Preferences/com.haptica.1context.plist",
    "~/Library/Saved Application State/com.haptica.1context.menu.savedState",
    "~/Library/WebKit/com.haptica.1context.menu",
    "/private/var/folders/*/*/*/T/1context-*.command",
    "/private/var/folders/*/*/*/T/1context-update-*",
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
