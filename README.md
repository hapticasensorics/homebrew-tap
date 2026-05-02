# 1Context Homebrew Tap

macOS public preview for 1Context.

```bash
brew install --cask hapticasensorics/tap/1context
```

The cask installs the same signed and notarized `1Context.app` distributed in
the direct DMG release. The app launches after install, moves into the normal
menu bar flow, and uses Sparkle for app-owned updates.

Requires Apple Silicon and macOS 13 Ventura or newer. The preview runtime also
uses `uv` and `node`, which Homebrew installs as cask dependencies.

```bash
brew uninstall --cask hapticasensorics/tap/1context
brew uninstall --cask --zap hapticasensorics/tap/1context
```

1Context stores human-readable, user-owned content in `~/1Context`. Runtime
state lives in `~/Library/Application Support/1Context`, logs in
`~/Library/Logs/1Context`, and disposable cache in `~/Library/Caches/1Context`.
