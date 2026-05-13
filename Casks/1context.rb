cask "1context" do
  version "0.1.65"
  sha256 "bd4d282e68611006c4025f409d9483810ce2eb5ebc3900272814987ee1a67d28"

  url "https://github.com/hapticasensorics/1context/releases/download/v#{version}/1Context-#{version}-macos-arm64.dmg",
      verified: "github.com/hapticasensorics/1context/"
  name "1Context"
  desc "Agentic context engine for local project memory"
  homepage "https://haptica.ai/"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on arch: :arm64
  depends_on macos: ">= :ventura"
  depends_on formula: "uv"
  depends_on formula: "node"

  app "1Context.app"
  binary "#{appdir}/1Context.app/Contents/MacOS/1context-cli", target: "1context"

  postflight do
    system_command "/usr/bin/open",
                   args:         ["#{appdir}/1Context.app"],
                   must_succeed: false,
                   print_stderr: false
  end

  uninstall_preflight do
    cli = "#{appdir}/1Context.app/Contents/MacOS/1context-cli"
    if File.executable?(cli)
      system_command cli,
                     args:         ["uninstall", "--keep-app"],
                     must_succeed: false,
                     print_stderr: false
    end

    uid = Process.uid
    labels = [
      "com.haptica.1context.menu",
      "com.haptica.1context",
    ]

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
    rm File.expand_path("~/Library/LaunchAgents/com.haptica.1context.menu.plist")
    rm File.expand_path("~/Library/LaunchAgents/com.haptica.1context.plist")
  end

  zap trash: [
    "/private/var/folders/*/*/*/T/1context-*.command",
    "/private/var/folders/*/*/*/T/1context-update-*",
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
  ]

  caveats <<~EOS
    1Context installs the same signed app used by the direct DMG download.
    The app starts after install and opens setup when local wiki access still
    needs permission.

    To stop 1Context:
      1context stop

    To remove 1Context but keep local data:
      brew uninstall --cask hapticasensorics/tap/1context

    To remove user content and local data too:
      brew uninstall --cask --zap hapticasensorics/tap/1context
  EOS
end
